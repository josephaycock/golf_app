import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          SizedBox.expand(
            child: Image.asset('assets/images/loginbg.png', fit: BoxFit.cover),
          ),
          // Semi-transparent overlay
          Container(color: Colors.black.withOpacity(0.4)),
          // Main Content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 40.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title logo (Black version)
                  Image.asset('assets/images/BirdieBoard.png', width: 250),
                  const SizedBox(height: 30),
                  const Text(
                    'Welcome to BirdieBoard!',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Your complete golf companion:\n'
                    '✔️ Real-time score tracking\n'
                    '✔️ Discover and map new courses\n'
                    '✔️ Scoreboards and Stats Updates\n'
                    '✔️ Analytics that will help improve your game\n',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // Features Section
                  FeatureCard(
                    icon: Icons.golf_course,
                    title: 'Course Finder',
                    description:
                        'Explore various courses nearby and map out your next round.',
                  ),
                  const SizedBox(height: 20),
                  FeatureCard(
                    icon: Icons.leaderboard,
                    title: 'Scoreboard Battles',
                    description:
                        'Climb the ranks and compete with other players.',
                  ),
                  const SizedBox(height: 20),
                  FeatureCard(
                    icon: Icons.insights,
                    title: 'Stat Tracking',
                    description:
                        'Analyze your birdies, pars, and greens live durinng play with detailed insights.',
                  ),
                  const SizedBox(height: 40),

                  // Bottom Logo
                  Image.asset(
                    'assets/images/BirdieBoard.png', // ✅ Black Main logo
                    width: 100,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'BirdieBoard — Master Your Golf Game.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// FeatureCard Widget
class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 40, color: Colors.white),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
