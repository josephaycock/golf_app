import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GameService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _generateGameCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    return List.generate(6, (_) => chars[rand.nextInt(chars.length)]).join();
  }

  Future<String> createGameSession(String playerName) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not signed in");
    final uid = user.uid;
    final gameCode = _generateGameCode();

    await _firestore.collection('games').doc(gameCode).set({
      'hostId': uid,
      'createdAt': FieldValue.serverTimestamp(),
      'players': {
        uid: {
          'name': playerName,
          'scores': List.generate(18, (_) => {
            'score': 0,
            'putts': 0,
            'penalty': 0,
            'drive': 'Center',
            'sand': false,
          }),
        }
      },
    });

    return gameCode;
  }

  Future<String?> joinGameSession(String gameCode, String playerName) async {
    final user = _auth.currentUser;
    if (user == null) return 'User not signed in';
    final uid = user.uid;

    final docRef = _firestore.collection('games').doc(gameCode);
    final doc = await docRef.get();

    if (!doc.exists) return 'Game not found';
    final players = doc.data()?['players'] ?? {};
    if (players.containsKey(uid)) return 'Already joined this game';

    await docRef.update({
      'players.$uid': {
        'name': playerName,
        'scores': List.generate(18, (_) => {
          'score': 0,
          'putts': 0,
          'penalty': 0,
          'drive': 'Center',
          'sand': false,
        }),
      }
    });

    return null; // Success
  }

  Future<Map<String, dynamic>?> getGameData(String gameCode) async {
    final doc = await _firestore.collection('games').doc(gameCode).get();
    return doc.data();
  }
}
