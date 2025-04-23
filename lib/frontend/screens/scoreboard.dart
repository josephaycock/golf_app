import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData.dark().copyWith(
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: AppBarTheme(backgroundColor: Colors.black),
      textTheme: ThemeData.dark().textTheme.apply(bodyColor: Colors.white),
    ),
    home: GolfScoreBoard(),
  ));
}

class GolfScoreBoard extends StatelessWidget {
  final int playerCount = 5;
  final int holeCount = 8;

  const GolfScoreBoard({super.key});


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text('Golf Scoreboard')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildHeaderRow(),
            Expanded(
              child: ListView.builder(
                itemCount: playerCount,
                itemBuilder: (context, index) => _buildPlayerRow(index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      children: [
        SizedBox(width: 60, child: Text('Player', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
        ...List.generate(holeCount, (index) => _buildCell('H${index + 1}', isHeader: true)),
      ],
    );
  }

  Widget _buildPlayerRow(int playerIndex) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: Colors.grey[800],
                child: Icon(Icons.person, size: 16, color: Colors.white),
              ),
              SizedBox(width: 4),
              Text('P${playerIndex + 1}', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        ...List.generate(holeCount, (index) => _buildCell('')),
      ],
    );
  }

  Widget _buildCell(String text, {bool isHeader = false}) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(2),
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: Colors.white),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
