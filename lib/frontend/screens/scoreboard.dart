import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../backend/services/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../backend/services/game_service.dart';

class GolfScoreBoard extends StatefulWidget {
  const GolfScoreBoard({super.key});

  @override
  State<GolfScoreBoard> createState() => _GolfScoreBoardState();
}

class _GolfScoreBoardState extends State<GolfScoreBoard> {
  final FirebaseService _firebaseService = FirebaseService();
  final GameService _gameService = GameService();

  bool hasStartedRound = false;
  final List<String> golfCourseNames = [
    "BREC's Webb Memorial Golf Course",
    "Santa Maria Golf Course",
    "City Park Golf Course",
    "Howell Park Golf Course",
    "Dumas Memorial Golf Course",
    "LSU Golf Course",
    "Pelican Point Golf Club",
    "The Island Golf Course",
    "Copper Mill Golf Club",
    "The Bluffs on Thompson Creek",
  ];
  String selectedCourse = 'BREC\'s Webb Memorial Golf Course';
  String gameFormat = 'Traditional';
  int currentHole = 1;
  bool showSummary = false;
  String? gameCode;

  List<Map<String, dynamic>> roundData = List.generate(
    18,
    (i) => {
      'score': 0,
      'putts': 0,
      'penalty': 0,
      'drive': 'Center',
      'sand': false,
    },
  );

  @override
  void initState() {
    super.initState();
    _loadRound();
  }

  Future<void> _loadRound() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final roundJson = prefs.getString('roundData');
      final savedCode = prefs.getString('gameCode');
      final savedStarted = prefs.getBool('hasStartedRound') ?? false;

      if (mounted && savedStarted && roundJson != null && savedCode != null) {
        setState(() {
          hasStartedRound = true;
          roundData = List<Map<String, dynamic>>.from(jsonDecode(roundJson));
          gameCode = savedCode;
          showSummary = false;
          currentHole = prefs.getInt('currentHole') ?? 1;
        });
      }
    } catch (e) {
      debugPrint('Error loading round data: $e');
    }
  }

  void _startRound() {
    setState(() {
      hasStartedRound = true;
      showSummary = false;
      currentHole = 1;
    });
    _saveRound();
  }

  Future<void> _updateFirestoreScore() async {
    try {
      if (gameCode == null) return;
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      await FirebaseFirestore.instance.collection('games').doc(gameCode).update(
        {'players.$uid.scores': roundData},
      );
    } catch (e) {
      debugPrint('Error updating Firestore: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to sync scores: $e')));
    }
  }

  Future<void> _updateStat(int hole, String key, dynamic value) async {
    setState(() {
      roundData[hole - 1][key] = value;
      currentHole = hole;
    });
    await _saveRound();
    await _updateFirestoreScore();
  }

  Future<void> _saveRound() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasStartedRound', hasStartedRound);
      await prefs.setString('roundData', jsonEncode(roundData));
      await prefs.setInt('currentHole', currentHole);
      if (gameCode != null) {
        await prefs.setString('gameCode', gameCode!);
      }
    } catch (e) {
      debugPrint('Error saving round data: $e');
    }
  }

  int _countPlayed() => roundData.where((d) => d['score'] > 0).length;
  int _sum(String key) =>
      roundData.fold(0, (sum, e) => sum + ((e[key] ?? 0) as int));
  int _countDrive(String dir) =>
      roundData.where((d) => d['drive'] == dir && d['score'] > 0).length;
  int _countSandSave() =>
      roundData.where((d) => d['sand'] == true && d['score'] > 0).length;

  Future<void> _updateStatsAfterRound() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      int totalStrokes = _sum("score");
      int birdies = roundData.where((d) => d['score'] == 3).length;
      int pars = roundData.where((d) => d['score'] == 4).length;
      int bogeys = roundData.where((d) => d['score'] == 5).length;

      final newStats = {
        'gamesPlayed': FieldValue.increment(1),
        'totalStrokes': FieldValue.increment(totalStrokes),
        'birdies': FieldValue.increment(birdies),
        'pars': FieldValue.increment(pars),
        'bogeys': FieldValue.increment(bogeys),
      };

      await _firebaseService.updatePlayerStats(userId, newStats);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Stats updated successfully!')),
        );
      }
    } catch (e) {
      debugPrint('Error updating stats: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to update stats: $e')));
      }
    }
  }

  Future<String?> _askForName() async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Enter Your Name'),
            content: TextField(controller: controller),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
                style: ElevatedButton.styleFrom(foregroundColor: Colors.white),
              ),
              ElevatedButton(
                onPressed:
                    () => Navigator.of(context).pop(controller.text.trim()),
                child: const Text('OK'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
    );
  }

  void _showOtherPlayerScores() async {
    try {
      if (gameCode == null) return;
      final gameData = await _gameService.getGameData(gameCode!);
      if (gameData == null || !mounted) return;

      final players = gameData['players'] as Map<String, dynamic>;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => Scaffold(
                appBar: AppBar(
                  title: Text('Code: $gameCode'),
                  backgroundColor: Colors.green[800],
                ),
                body: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(
                      Colors.green.withOpacity(0.2),
                    ),
                    columns: [
                      const DataColumn(label: Text('Player')),
                      ...List.generate(
                        18,
                        (i) => DataColumn(label: Text('${i + 1}')),
                      ),
                      const DataColumn(label: Text('Total')),
                    ],
                    rows:
                        players.entries.map((entry) {
                          final name = entry.value['name'] ?? 'Unnamed';
                          final scores = List<Map<String, dynamic>>.from(
                            entry.value['scores'] ?? [],
                          );

                          while (scores.length < 18) {
                            scores.add({
                              'score': 0,
                              'putts': 0,
                              'penalty': 0,
                              'drive': 'Center',
                              'sand': false,
                            });
                          }

                          final total = scores.fold<int>(
                            0,
                            (sum, s) => sum + ((s['score'] ?? 0) as int),
                          );

                          return DataRow(
                            cells: [
                              DataCell(Text(name)),
                              ...scores.asMap().entries.map((entry) {
                                final i = entry.key;
                                final s = entry.value;
                                return DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          i + 1 == currentHole
                                              ? Colors.yellow.withOpacity(0.3)
                                              : null,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text('${s["score"] ?? 0}'),
                                  ),
                                );
                              }),
                              DataCell(Text('$total')),
                            ],
                          );
                        }).toList(),
                  ),
                ),
              ),
        ),
      );
    } catch (e) {
      debugPrint('Error showing player scores: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load scores: $e')));
      }
    }
  }

  Widget _buildSlider(
    String label,
    int value,
    Function(int) onChanged, {
    int max = 12,
  }) {
    return Column(
      children: [
        Text(
          '$label: $value',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: max,
            itemBuilder:
                (_, i) => GestureDetector(
                  onTap: () => onChanged(i + 1),
                  child: Container(
                    width: 40,
                    margin: const EdgeInsets.all(4),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          (i + 1) == value
                              ? Colors.green[800]
                              : Colors.green[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        '${i + 1}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: Image.asset('assets/images/titleImage.png', height: 100),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        automaticallyImplyLeading: false,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child:
            hasStartedRound
                ? (showSummary
                    ? _buildSummary()
                    : SingleChildScrollView(child: _buildStatInput()))
                : _buildSetupScreen(),
      ),
    );
  }

  Widget _buildStatInput() {
    final holeStats = roundData[currentHole - 1];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: gameCode != null ? () => _showOtherPlayerScores() : null,
            icon: const Icon(Icons.visibility, color: Colors.white),
            label: const Text(
              'View All Scores',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Text(
          'Hole $currentHole',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildSlider(
          'Score',
          holeStats['score'],
          (v) => _updateStat(currentHole, 'score', v),
        ),
        _buildSlider(
          'Putts',
          holeStats['putts'],
          (v) => _updateStat(currentHole, 'putts', v),
          max: 6,
        ),
        _buildSlider(
          'Penalties',
          holeStats['penalty'],
          (v) => _updateStat(currentHole, 'penalty', v),
          max: 4,
        ),
        const SizedBox(height: 12),
        const Text(
          'Drive Accuracy',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children:
              ['Left', 'Center', 'Right'].map((d) {
                final isSelected = holeStats['drive'] == d;
                return ChoiceChip(
                  label: Text(
                    d,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (_) => _updateStat(currentHole, 'drive', d),
                  selectedColor: Colors.green,
                  backgroundColor: Colors.grey[200],
                );
              }).toList(),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Text(
              'Sand Save:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Switch(
              activeColor: Colors.green,
              value: holeStats['sand'],
              onChanged: (v) => _updateStat(currentHole, 'sand', v),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed:
                  currentHole > 1 ? () => setState(() => currentHole--) : null,
              child: const Text(
                'Previous',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed:
                  currentHole < 18 ? () => setState(() => currentHole++) : null,
              child: const Text('Next', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            ),
            onPressed: () => setState(() => showSummary = true),
            child: const Text(
              'Finish Round',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummary() {
    final played = _countPlayed();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Round Summary',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text('Holes Played: $played'),
        Text('Total Score: ${_sum("score")}'),
        Text('Total Putts: ${_sum("putts")}'),
        Text('Total Penalties: ${_sum("penalty")}'),
        const SizedBox(height: 12),
        const Text('Drive Accuracy:'),
        Text('  Left: ${_countDrive("Left")}'),
        Text('  Center: ${_countDrive("Center")}'),
        Text('  Right: ${_countDrive("Right")}'),
        const SizedBox(height: 12),
        Text('Sand Saves: ${_countSandSave()}'),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            ),
            onPressed: () async {
              await _updateStatsAfterRound();
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('hasStartedRound');
              await prefs.remove('roundData');
              await prefs.remove('gameCode');
              await prefs.remove('currentHole');

              if (mounted) {
                setState(() {
                  hasStartedRound = false;
                  showSummary = false;
                  gameCode = null;
                  roundData = List.generate(
                    18,
                    (i) => {
                      'score': 0,
                      'putts': 0,
                      'penalty': 0,
                      'drive': 'Center',
                      'sand': false,
                    },
                  );
                });
              }
            },
            child: const Text(
              'End Round',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSetupScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select Course:', style: TextStyle(fontSize: 18)),
        DropdownButton<String>(
          value: selectedCourse,
          isExpanded: true,
          items:
              golfCourseNames.map((course) {
                return DropdownMenuItem<String>(
                  value: course,
                  child: Text(course),
                );
              }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                selectedCourse = value;
              });
            }
          },
        ),
        const SizedBox(height: 16),
        const Text('Game Format:', style: TextStyle(fontSize: 18)),
        Text('$gameFormat - Keep track of all stats during the round.'),
        const SizedBox(height: 24),
        const Text(
          'Start a game:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: () async {
            final codeController = TextEditingController();
            final nameController = TextEditingController();
            final result = await showDialog<bool>(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: const Text('Join Multiplayer Game'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Your Name',
                          ),
                        ),
                        TextField(
                          controller: codeController,
                          decoration: const InputDecoration(
                            labelText: 'Game Code',
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Join'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
            );

            if (result == true) {
              final name = nameController.text.trim();
              final code = codeController.text.trim();

              if (name.isEmpty || code.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Name and code required')),
                );
                return;
              }

              final error = await _gameService.joinGameSession(code, name);
              if (error != null) {
                if (mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(error)));
                }
              } else {
                setState(() {
                  gameCode = code;
                  hasStartedRound = true;
                  showSummary = false;
                  currentHole = 1;
                });
                await _saveRound();
                if (mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Joined game $code')));
                }
              }
            }
          },
          icon: const Icon(Icons.login, color: Colors.white),
          label: const Text('Join Game', style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: () async {
            final name = await _askForName();
            if (name == null || name.isEmpty) return;

            try {
              final code = await _gameService.createGameSession(name);
              setState(() {
                gameCode = code;
                hasStartedRound = true;
                showSummary = false;
                currentHole = 1;
              });
              await _saveRound();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Game created! Code: $code')),
                );
              }
            } catch (e) {
              debugPrint('Error creating game: $e');
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to create game: $e')),
                );
              }
            }
          },
          icon: const Icon(Icons.group_add, color: Colors.white),
          label: const Text(
            'Create Multiplayer Game',
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            onPressed: _startRound,
            child: const Text(
              'Start Solo Round',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
