import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> savePlayerStats(String userId, Map<String, dynamic> stats) async {
    await _firestore.collection('playerStats').doc(userId).set(stats);
  }

  Future<Map<String, dynamic>?> getPlayerStats(String userId) async {
    var doc = await _firestore.collection('playerStats').doc(userId).get();
    if (doc.exists) {
      return doc.data();
    } else {
      return null;
    }
  }
}
