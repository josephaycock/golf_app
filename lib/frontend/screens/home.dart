import 'package:flutter/material.dart';
import 'package:golf_app/frontend/screens/viewGolfCourses.dart';
import 'package:golf_app/frontend/screens/stats.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          Container(color: Colors.black.withOpacity(0.4)),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildLogo(),
                  const SizedBox(height: 30),
                  _buildWelcomeText(context),
                  const SizedBox(height: 50),
                  _buildNavButton(
                    context,
                    label: 'View Golf Courses',
                    icon: Icons.golf_course,
                    destination: const ViewGolfCourses(),
                  ),
                  const SizedBox(height: 20),
                  _buildNavButton(
                    context,
                    label: 'View Stats',
                    icon: Icons.bar_chart,
                    destination: const StatsPage(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return SizedBox.expand(
      child: Image.asset('assets/images/loginbg.png', fit: BoxFit.cover),
    );
  }

  Widget _buildLogo() {
    return Image.asset('assets/images/BirdieBoard.png', width: 250);
  }

  Widget _buildWelcomeText(BuildContext context) {
    return Text(
      'Welcome to BirdieBoard!',
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontSize: 34,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildNavButton(BuildContext context,
      {required String label, required IconData icon, required Widget destination}) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => destination),
        );
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
      ),
      icon: Icon(icon),
      label: Text(label, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
    );
  }
}
