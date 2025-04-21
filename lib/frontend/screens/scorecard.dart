import 'package:flutter/material.dart';

class ScorecardScreen extends StatefulWidget {
  const ScorecardScreen({super.key});

  @override
  State<ScorecardScreen> createState() => _ScorecardScreenState();
}

class _ScorecardScreenState extends State<ScorecardScreen> {
  final List<int> scores = List.filled(18, 0); // 18 holes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scorecard'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: scores.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Hole ${index + 1}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (scores[index] > 0) scores[index]--;
                    });
                  },
                ),
                Text(scores[index].toString()),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      scores[index]++;
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
