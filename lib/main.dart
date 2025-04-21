import 'package:flutter/material.dart';
import 'frontend/screens/welcome.dart';
import 'frontend/screens/scorecard.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Golf App', 
      theme: ThemeData(primarySwatch: Colors.green),
      home: const WelcomeScreen(),
    );
  }
}
// Kendrick was here again
//sitting at internship rn, ill work on this later