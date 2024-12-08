import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Save user details to Firestore
  Future<void> saveUserDetails(User user, String signInMethod) async {
    try {
      await _db.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'displayName': user.displayName ?? 'Anonymous User',
        'signInMethod': signInMethod, // Track sign-in method (google or anonymous)
      });
    } catch (e) {
      throw Exception('Failed to save user details to Firestore: $e');
    }
  }
}
