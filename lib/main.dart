//Cayden Anderson 

import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}
// This is Kendrick's first commit on Github
// This is Joshua's first commit on Github
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
