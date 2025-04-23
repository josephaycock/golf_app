import 'package:flutter/material.dart';

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

class GolfScoreBoard extends StatelessWidget {
  final List<String> holeHeaders = [
    ...List.generate(9, (i) => 'H${i + 1}'),
    'Total',
    ...List.generate(9, (i) => 'H${i + 10}'),
    'Total'
  ];

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

  final int playerCount = 5;

  GolfScoreBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Golf Scoreboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTable(teeData),
            const SizedBox(height: 8),
            _buildPlayerHeaderRow(),
            ...List.generate(playerCount, (index) => _buildPlayerRow(index)),
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
        }).toList(),
      ],
    );
  }

  Widget _buildPlayerRow(int index) {
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
            child: Text('Name', style: TextStyle(color: Colors.white)),
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
        }).toList(),
      ],
    );
  }
}

