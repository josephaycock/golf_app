import 'package:flutter/material.dart';

class ViewGolfCourses extends StatefulWidget {
  const ViewGolfCourses({super.key});

  @override
  State<ViewGolfCourses> createState() => _ViewGolfCoursesState();
}

class _ViewGolfCoursesState extends State<ViewGolfCourses> {
  // Placeholder for current score
  int _currentScore = 0;

  // Placeholder for distance to hole
  double _distanceToHole = 150.0; // in yards, just an example

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Golf Course'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Scorekeeping UI
            Card(
              child: ListTile(
                title: const Text('Current Score'),
                subtitle: Text('$_currentScore'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          _currentScore--;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _currentScore++;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Distance tracking UI
            Card(
              child: ListTile(
                title: const Text('Distance to Hole'),
                subtitle: Text('${_distanceToHole.toStringAsFixed(1)} yards'),
              ),
            ),

            const SizedBox(height: 16),

            // Placeholder for map widget
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.green[200],
                alignment: Alignment.center,
                child: const Text(
                  'Map of Golf Course\n(Coming Soon)',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// TODO: Connect distance to real GPS location data
// TODO: Replace placeholder map with interactive map widget
// TODO: Expand score tracker to handle 18-hole course with per-hole input
