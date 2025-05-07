import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'frontend/screens/welcome.dart';
import 'frontend/screens/home.dart'; // Or your actual homepage widget

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Toggle this to skip WelcomeScreen during dev
  static const bool skipWelcomeScreen = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: skipWelcomeScreen ? const HomeScreen() : const WelcomeScreen(),
    );
  }
}
