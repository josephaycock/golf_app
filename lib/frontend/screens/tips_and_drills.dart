import 'package:flutter/material.dart';
import '../../backend/models/tips_and_drills.dart';

class TipsAndDrillsScreen extends StatelessWidget {
  const TipsAndDrillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tips & Drills'),
          backgroundColor: Colors.green[800],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Professional Tips'),
              Tab(text: 'Practice Drills'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTipsList(),
            _buildDrillsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTipsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: golfTips.length,
      itemBuilder: (context, index) {
        final tip = golfTips[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ExpansionTile(
            title: Text(
              tip.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              tip.category,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  tip.description,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrillsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: practiceDrills.length,
      itemBuilder: (context, index) {
        final drill = practiceDrills[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ExpansionTile(
            title: Text(
              drill.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Difficulty: ${drill.difficulty}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Time: ${drill.estimatedTime} minutes',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      drill.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Equipment needed: ${drill.equipment}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 