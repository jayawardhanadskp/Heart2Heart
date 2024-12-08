import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paint/services/firestore_service.dart';
import 'package:paint/services/auth_service.dart';

class GFAuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  User? _user;
  String? _error;

  User? get user => _user;
  String? get error => _error;

  GFAuthProvider() {
    _authService.authStateChanges().listen((User? user) {
      _user = user;
      _error = null;
      notifyListeners();
    });
  }

  // Sign-in with Google
  Future<void> signInWIthGoogle() async {
    try {
      await _authService.signInWithGoogle();
      final user = _authService.currentUser;
      if (user != null) {
        // Save Google user data to Firestore
        await _firestoreService.saveUserDetails(user, 'google');
      }
    } catch (e) {
      _error = e.toString();
      _user = null;
      notifyListeners();
    }
  }

  // Sign-in anonymously
  Future<void> signInAnon(BuildContext context) async {
    try {
      await _authService.signInAnon();
      final user = _authService.currentUser;
      if (user != null) {
        // Save anonymous user data to Firestore
        await _firestoreService.saveUserDetails(user, 'anonymous');
      }
      Navigator.pushNamed(context, '/home');
    } catch (e) {
      _error = e.toString();
      _user = null;
      notifyListeners();
    }
  }

  // Sign-out
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      _user = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // Check if anonymous user exists
  Future<bool> checkIfUserExists() async {
    return await _authService.doesAnonymousUserExist();
  }
}
