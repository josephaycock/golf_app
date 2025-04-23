import 'package:flutter/material.dart';
import 'frontend/screens/welcome.dart';
import 'frontend/widgets/nav_wrapper.dart';
import 'frontend/screens/login.dart';
import 'frontend/screens/register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Golf App',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterWidget(),
        '/nav': (context) => const NavWrapper(), // Home + navbar
      },
    );
  }
}
