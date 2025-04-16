//this is just a temp file so I can figure out what I am doing with firebase 
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() => _instance;

  FirebaseService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Call this in your main() function
  Future<void> initialize() async {
    await Firebase.initializeApp();
  }

  // Anonymous sign in
  Future<User?> signInAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      return result.user;
    } catch (e) {
      print('Error signing in anonymously: $e');
      return null;
    }
  }

  // Add data to Firestore
  Future<void> addData(String collection, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).add(data);
      print('Data added successfully.');
    } catch (e) {
      print('Error adding data: $e');
    }
  }

  // Read data from Firestore
  Stream<QuerySnapshot> getData(String collection) {
    return _firestore.collection(collection).snapshots();
  }
}
