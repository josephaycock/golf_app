import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log In')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Welcome Back!', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            TextField(decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TEMP: Route to home via NavWrapper
                Navigator.pushReplacementNamed(context, '/nav');
              },
              child: const Text('Log In'),
            ),
          ],
        ),
      ),
    );
  }
}
