import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;

  // Stream to listen for auth state changes
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  // Sign in with Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? gUser = await _googleSignIn.signIn();
      if (gUser == null) throw Exception("Google sign-in failed: User canceled the sign-in");

      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      throw Exception('Google sign-in failed: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // Anonymous sign-in
  Future<UserCredential> signInAnon() async {
    try {
      return await _auth.signInAnonymously();
    } catch (e) {
      throw Exception('Anonymous sign-in failed: $e');
    }
  }

  // Anonymous sign-out
  Future<void> anonymousSignOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Anonymous sign-out failed: $e');
    }
  }

  // Check if the current anonymous user still exists
  Future<bool> doesAnonymousUserExist() async {
    final user = _auth.currentUser;
    if (user != null && user.isAnonymous) {
      try {
        await _auth.currentUser?.reload();
        return true;  // User still exists
      } catch (e) {
        return false; // User doesn't exist anymore (deleted or invalid)
      }
    }
    return false;
  }
}
