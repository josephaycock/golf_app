// lib/frontend/screens/nav_wrapper.dart
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

  final List<Widget> _pages = const [
    GolfScoreBoard(), // 0
    HelpScreen(), // 1
    HomeScreen(), // 2
    ViewGolfCourses(), // 3
    PlayerProfileScreen(), // 4
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
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
