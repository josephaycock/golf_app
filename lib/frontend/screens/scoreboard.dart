import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(backgroundColor: Colors.black),
        textTheme: ThemeData.dark().textTheme.apply(bodyColor: Colors.white),
      ),
      home: GolfScoreBoard(),
    ),
  );
}

class GolfScoreBoard extends StatefulWidget {
  const GolfScoreBoard({super.key});

  @override
  State<GolfScoreBoard> createState() => _GolfScoreBoardState();
}

class _GolfScoreBoardState extends State<GolfScoreBoard> {
  final List<String> holeHeaders = [
    ...List.generate(9, (i) => 'H${i + 1}'),
    'Total',
    ...List.generate(9, (i) => 'H${i + 10}'),
    'Total'
  ];
//needs to be updated per course we add
  final List<List<String>> teeData = [
    [
      'Black Tee', '###', '###', '###', '###', '###', '###', '###', '###', '###', 'Black Tee', '###', '###', '###', '###', '###', '###', '###', '###', '###', '###'
    ],
    [
      'Blue Tee', '###', '###', '###', '###', '###', '###', '###', '###', '###', 'Blue Tee', '###', '###', '###', '###', '###', '###', '###', '###', '###', '###'
    ],
    [
      'White Tee', '###', '###', '###', '###', '###', '###', '###', '###', '###', 'White Tee', '###', '###', '###', '###', '###', '###', '###', '###', '###', '###'
    ],
    [
      'Red Tee', '###', '###', '###', '###', '###', '###', '###', '###', '###', 'Red Tee', '###', '###', '###', '###', '###', '###', '###', '###', '###', '###'
    ],
    [
      'Par', '#', '#', '#', '#', '#', '#', '#', '#', '#', 'Par', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#'
    ]
  ];

  List<String> playerNames = List.generate(5, (index) => 'Player ${index + 1}');
  List<List<String>> playerScores = List.generate(5, (_) => List.generate(18, (_) => ''));

  @override
  void initState() {
    super.initState();
    _loadGame();
  }

  Future<void> _loadGame() async {
    final prefs = await SharedPreferences.getInstance();
    final savedNames = prefs.getStringList('playerNames');
    final savedScores = prefs.getString('playerScores');
    
    if (savedNames != null) {
      setState(() {
        playerNames = savedNames;
      });
    }
    
    if (savedScores != null) {
      setState(() {
        playerScores = List<List<String>>.from(
          jsonDecode(savedScores).map((list) => List<String>.from(list))
        );
      });
    }
  }

  Future<void> _saveGame() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('playerNames', playerNames);
    await prefs.setString('playerScores', jsonEncode(playerScores));
  }

  void _showNameDialog(int index) {
    final TextEditingController controller = TextEditingController(text: playerNames[index]);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Player Name'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter player name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  playerNames[index] = controller.text.isEmpty ? 'Player ${index + 1}' : controller.text;
                });
                _saveGame();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[800],
                foregroundColor: Colors.black,
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showNewGameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Start New Game'),
          content: const Text('Are you sure you want to start a new game? All current scores will be lost.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  playerNames = List.generate(5, (index) => 'Player ${index + 1}');
                  playerScores = List.generate(5, (_) => List.generate(18, (_) => ''));
                });
                _saveGame();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[800],
                foregroundColor: Colors.black,
              ),
              child: const Text('New Game'),
            ),
          ],
        );
      },
    );
  }

  void _showAddPlayerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: const Text('Add New Player'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter player name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  playerNames.add(controller.text.isEmpty ? 'Player ${playerNames.length + 1}' : controller.text);
                  playerScores.add(List.generate(18, (_) => ''));
                });
                _saveGame();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[800],
                foregroundColor: Colors.black,
              ),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _removePlayer(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Player'),
          content: Text('Are you sure you want to remove ${playerNames[index]}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  playerNames.removeAt(index);
                  playerScores.removeAt(index);
                });
                _saveGame();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Golf Scoreboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _showNewGameDialog,
            tooltip: 'New Game',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTable(teeData),
                  const SizedBox(height: 8),
                  _buildPlayerHeaderRow(),
                  ...List.generate(playerNames.length, (index) => _buildPlayerRow(index)),
                  _buildAddPlayerButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTable(List<List<String>> data) {
    return Column(
      children: data.map((row) {
        return Row(
          children: row.asMap().entries.map((entry) {
            int i = entry.key;
            String cell = entry.value;
            bool isTotal = holeHeaders.contains('Total') && (holeHeaders[i % holeHeaders.length] == 'Total');
            return Container(
              width: isTotal ? 60 : 50,
              margin: const EdgeInsets.all(1),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                color: Colors.black,
              ),
              child: Center(
                child: Text(
                  cell,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  Widget _buildPlayerHeaderRow() {
    return Row(
      children: [
        Container(
          width: 60,
          margin: const EdgeInsets.all(1),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            color: Colors.black,
          ),
          child: const Center(
            child: Text('', style: TextStyle(color: Colors.white)),
          ),
        ),
        ...holeHeaders.map((label) {
          bool isTotal = label == 'Total';
          return Container(
            width: isTotal ? 60 : 50,
            margin: const EdgeInsets.all(1),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              color: Colors.black,
            ),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPlayerRow(int index) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => _showNameDialog(index),
          onLongPress: () => _removePlayer(index),
          child: Container(
            width: 60,
            margin: const EdgeInsets.all(1),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              color: Colors.black,
            ),
            child: Center(
              child: Text(
                playerNames[index],
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        ...holeHeaders.map((_) {
          return Container(
            width: 50,
            margin: const EdgeInsets.all(1),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              color: Colors.black,
            ),
            child: const Center(
              child: Text('', style: TextStyle(color: Colors.white)),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildAddPlayerButton() {
    return GestureDetector(
      onTap: _showAddPlayerDialog,
      child: Container(
        width: 60,
        margin: const EdgeInsets.all(1),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          color: Colors.black,
        ),
        child: const Center(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

