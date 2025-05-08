import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GameService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Generate 6-character game code
  String _generateGameCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    return List.generate(6, (_) => chars[rand.nextInt(chars.length)]).join();
  }

  // Create a new game session
  Future<String> createGameSession(String playerName) async {
    final uid = _auth.currentUser!.uid;
    final gameCode = _generateGameCode();

    await _firestore.collection('games').doc(gameCode).set({
      'hostId': uid,
      'createdAt': FieldValue.serverTimestamp(),
      'players': {
        uid: {
          'name': playerName,
          'scores': List.generate(18, (_) => 0),
        }
      },
    });

    return gameCode;
  }

  // Join an existing game session by code
  Future<String?> joinGameSession(String gameCode, String playerName) async {
    final uid = _auth.currentUser!.uid;
    final docRef = _firestore.collection('games').doc(gameCode);
    final doc = await docRef.get();

    if (!doc.exists) return 'Game not found';
    final players = doc.data()?['players'] ?? {};
    if (players.containsKey(uid)) return 'Already joined this game';

    await docRef.update({
      'players.$uid': {
        'name': playerName,
        'scores': List.generate(18, (_) => 0),
      }
    });

    return null; // Success
  }

  // Fetch game data
  Future<Map<String, dynamic>?> getGameData(String gameCode) async {
    final doc = await _firestore.collection('games').doc(gameCode).get();
    return doc.data();
  }
}
