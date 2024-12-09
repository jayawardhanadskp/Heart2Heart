import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Generate a random 4-5 digit code
  String generateShortCode() {
    var rng = Random();
    return (1000 + rng.nextInt(90000)).toString(); // Generates a random 4-5 digit code
  }

  // Save user details to Firestore with short code
  Future<void> saveUserDetails(User user, String signInMethod) async {
    try {
      String uniqueCode = generateShortCode(); // Generate 4-5 digit code for user

      await _db.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'displayName': user.displayName ?? 'Anonymous User',
        'signInMethod': signInMethod,
        'code': uniqueCode,  // Store the generated 4-5 digit code
        'pairedWith': null,   // Initially, user is not paired
      });

      print('User details saved with code: $uniqueCode');
    } catch (e) {
      print('Failed to save user details to Firestore: $e');
      throw Exception('Failed to save user details to Firestore: $e');
    }
  }

  // Get a user's code from Firestore
  Future<String?> getUserCode(String uid) async {
    DocumentSnapshot userDoc = await _db.collection('users').doc(uid).get();
    return userDoc['code']; // Return the user's unique code
  }

  // Get paired user ID from Firestore
  Future<String?> getPairedUserId(String uid) async {
    DocumentSnapshot userDoc = await _db.collection('users').doc(uid).get();
    return userDoc['pairedWith'];
  }

  // Pair users based on the code entered
  Future<void> pairUsers(String user1Code, String user2Id) async {
    try {
      // Fetch user 1 using the code provided by user 2
      QuerySnapshot userQuery = await _db.collection('users')
          .where('code', isEqualTo: user1Code)
          .get();

      if (userQuery.docs.isEmpty) {
        throw Exception('No user found with that code.');
      }

      String user1Id = userQuery.docs.first.id;

      // Check if user 1 is already paired
      DocumentSnapshot user1Doc = await _db.collection('users').doc(user1Id).get();
      if (user1Doc['pairedWith'] != null) {
        throw Exception('User 1 is already paired with another user.');
      }

      // Generate a pair ID and update both users to indicate they are paired
      List<String> pairIds = [user1Id, user2Id]..sort();  // Sort the list first
      String finalPairId = pairIds.join('-');  // Join the list into a single string

      await _db.collection('users').doc(user1Id).update({'pairedWith': finalPairId});
      await _db.collection('users').doc(user2Id).update({'pairedWith': finalPairId});

      // Save pairId in the drawings collection for real-time syncing
      await _db.collection('drawings').doc(finalPairId).set({
        'pairId': finalPairId,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('Pairing successful between $user1Id and $user2Id!');
    } catch (e) {
      print('Error pairing users: $e');
      throw e;
    }
  }

  // Save the drawing data (points) to Firestore for real-time sync
  Future<void> saveDrawing(String pairId, List<Offset> points, double strokeWidth, Color color) async {
    try {
      await _db.collection('drawings').doc(pairId).set({
        'points': points.map((point) => {'dx': point.dx, 'dy': point.dy}).toList(),
        'strokeWidth': strokeWidth,
        'color': color.value,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));  // Ensure data is merged
    } catch (e) {
      print('Error saving drawing: $e');
    }
  }

  // Listen to real-time drawing data of a paired user
  Stream<DocumentSnapshot> listenToDrawing(String pairId) {
    print(_db);
    return _db.collection('drawings').doc(pairId).snapshots();
  }
}
