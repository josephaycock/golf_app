// Golf Scoreboard with Stats Summary (Phase 3 Complete)
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(
  MaterialApp(
    theme: ThemeData.dark().copyWith(
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: AppBarTheme(backgroundColor: Colors.black),
      textTheme: ThemeData.dark().textTheme.apply(bodyColor: Colors.white),
    ),
    home: GolfScoreBoard(),
  ),
);

class GolfScoreBoard extends StatefulWidget {
  const GolfScoreBoard({super.key});

  @override
  State<GolfScoreBoard> createState() => _GolfScoreBoardState();
}

class _GolfScoreBoardState extends State<GolfScoreBoard> {
  bool hasStartedRound = false;
  String selectedCourse = 'Course A';
  String gameFormat = 'Traditional';
  int currentHole = 1;
  bool showSummary = false;

  List<String> playerNames = ['Player 1'];
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

  void _startRound() {
    setState(() {
      hasStartedRound = true;
      showSummary = false;
      currentHole = 1;
    });
  }

  void _updateStat(int hole, String key, dynamic value) {
    setState(() => roundData[hole - 1][key] = value);
    _saveRound();
  }

  Future<void> _saveRound() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('roundData', jsonEncode(roundData));
  }

  int _countPlayed() => roundData.where((d) => d['score'] > 0).length;
  int _sum(String key) =>
      roundData.fold(0, (sum, e) => sum + ((e[key] ?? 0) as int));
  int _countDrive(String dir) =>
      roundData.where((d) => d['drive'] == dir && d['score'] > 0).length;
  int _countSandSave() =>
      roundData.where((d) => d['sand'] == true && d['score'] > 0).length;

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
        Text('Total Score: ${_sum('score')}'),
        Text('Total Putts: ${_sum('putts')}'),
        Text('Total Penalties: ${_sum('penalty')}'),
        const SizedBox(height: 12),
        Text('Drive Accuracy:'),
        Text('  Left: ${_countDrive('Left')}'),
        Text('  Center: ${_countDrive('Center')}'),
        Text('  Right: ${_countDrive('Right')}'),
        const SizedBox(height: 12),
        Text('Sand Saves: ${_countSandSave()}'),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton(
            onPressed:
                () => setState(() {
                  hasStartedRound = false;
                  showSummary = false;
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
                }),
            child: const Text('End Round'),
          ),
        ),
      ],
    );
  }

  Widget _buildSlider(
    String label,
    int value,
    Function(int) onChanged, {
    int max = 12,
  }) {
    return Column(
      children: [
        Text('$label: $value'),
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
                      color: (i + 1) == value ? Colors.green : Colors.grey[800],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(child: Text('${i + 1}')),
                  ),
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatInput() {
    final holeStats = roundData[currentHole - 1];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Hole $currentHole', style: const TextStyle(fontSize: 20)),
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
        Text('Drive Accuracy'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children:
              ['Left', 'Center', 'Right']
                  .map(
                    (d) => ChoiceChip(
                      label: Text(d),
                      selected: holeStats['drive'] == d,
                      onSelected: (_) => _updateStat(currentHole, 'drive', d),
                    ),
                  )
                  .toList(),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Text('Sand Save: '),
            Switch(
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
              onPressed:
                  currentHole > 1 ? () => setState(() => currentHole--) : null,
              child: const Text('Previous'),
            ),
            ElevatedButton(
              onPressed:
                  currentHole < 18 ? () => setState(() => currentHole++) : null,
              child: const Text('Next'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton(
            onPressed: () => setState(() => showSummary = true),
            child: const Text('Finish Round'),
          ),
        ),
      ],
    );
  }

  Widget _buildSetupScreen() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Course:', style: TextStyle(fontSize: 18)),
          DropdownButton<String>(
            value: selectedCourse,
            items:
                ['Course A', 'Course B'].map((course) {
                  return DropdownMenuItem(value: course, child: Text(course));
                }).toList(),
            onChanged: (val) => setState(() => selectedCourse = val!),
          ),
          const SizedBox(height: 16),
          const Text('Game Format:', style: TextStyle(fontSize: 18)),
          Text(
            '$gameFormat - Keep track of score, putts, penalties, drives, and sand saves.',
          ),
          const Spacer(),
          Center(
            child: ElevatedButton(
              onPressed: _startRound,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text('Start Round'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Golf Scorecard')),
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
}
