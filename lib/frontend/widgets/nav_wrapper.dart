import 'package:flutter/material.dart';
import 'package:golf_app/frontend/screens/home.dart';
import '../widgets/navbar.dart';
import '../screens/help.dart';
import '../screens/scoreboard.dart';
import '../screens/viewGolfCourses.dart';
import '../screens/stats.dart'; // <-- This now imports the updated StatsPage

class NavWrapper extends StatefulWidget {
  final int initialIndex;
  const NavWrapper({super.key, this.initialIndex = 2});

  @override
  State<NavWrapper> createState() => _NavWrapperState();
}

class _NavWrapperState extends State<NavWrapper> {
  late int _selectedIndex;
late final List<Widget> _pages;

@override
void initState() {
  super.initState();
  _selectedIndex = widget.initialIndex;

  _pages = [
    const GolfScoreBoard(key: PageStorageKey('scoreboard')),
    const HelpScreen(),
    const HomeScreen(),
    const ViewGolfCourses(),
    const StatsPage(),
  ];
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
