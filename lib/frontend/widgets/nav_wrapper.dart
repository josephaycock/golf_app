import 'package:flutter/material.dart';
import 'package:golf_app/frontend/screens/home.dart';
import '../widgets/navbar.dart';
import '../screens/help.dart';
import '../screens/scoreboard.dart';
import '../screens/viewGolfCourses.dart';
import '../screens/player_profile.dart';

class NavWrapper extends StatefulWidget {
  final int initialIndex;
  const NavWrapper({super.key, this.initialIndex = 2});

  @override
  State<NavWrapper> createState() => _NavWrapperState();
}

class _NavWrapperState extends State<NavWrapper> {
  late int _selectedIndex;

  final List<Widget> _pages = [
    GolfScoreBoard(), // 0
    const HelpScreen(), // 1
    const HomeScreen(), // 2
    const ViewGolfCourses(), // 3
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_selectedIndex], // Main content
          // Floating Profile Icon (smaller + tighter)
          Positioned(
            top: 12, // Tighter to top
            right: 12, // Tighter to right
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PlayerProfileScreen(),
                      ),
                    );
                  },
                  child: const CircleAvatar(
                    radius: 20, // 🔥 Smaller and cleaner (was 26 before)
                    backgroundColor: Colors.black,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 22,
                    ), // 🔥 Also smaller inside
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'View Profile',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 11, // 🔥 Slightly smaller
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
