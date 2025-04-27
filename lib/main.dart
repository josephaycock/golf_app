import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'frontend/screens/welcome.dart';
import 'frontend/screens/login.dart';
import 'frontend/widgets/nav_wrapper.dart'; // <-- wherever your NavWrapper is

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Golf App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const WelcomeScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/nav': (context) => const NavWrapper(),
      },
    );
  }
}
