import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> savePlayerStats(String userId, Map<String, dynamic> stats) async {
    await _firestore.collection('playerStats').doc(userId).set(stats, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getPlayerStats(String userId) async {
    DocumentSnapshot doc = await _firestore.collection('playerStats').doc(userId).get();
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    }
    return null;
  }
}