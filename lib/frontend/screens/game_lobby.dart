import 'package:flutter/material.dart';
import 'package:golf_app/backend/services/game_service.dart';

class GameLobbyScreen extends StatefulWidget {
  const GameLobbyScreen({super.key});

  @override
  State<GameLobbyScreen> createState() => _GameLobbyScreenState();
}

class _GameLobbyScreenState extends State<GameLobbyScreen> {
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _gameService = GameService();
  String _message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Game Lobby')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Your Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final code = await _gameService.createGameSession(_nameController.text.trim());
                setState(() {
                  _message = 'Game created! Share this code: $code';
                });
              },
              child: const Text('Create Game'),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(labelText: 'Enter Game Code'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final error = await _gameService.joinGameSession(
                  _codeController.text.trim().toUpperCase(),
                  _nameController.text.trim(),
                );
                setState(() {
                  _message = error ?? 'Joined game successfully!';
                });
              },
              child: const Text('Join Game'),
            ),
            const SizedBox(height: 30),
            Text(_message, style: const TextStyle(color: Colors.green)),
          ],
        ),
      ),
    );
  }
}
