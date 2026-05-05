import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../models/user.dart';

class AuthService {
  final fb.FirebaseAuth _firebaseAuth = fb.FirebaseAuth.instance;

  AppUser? get currentUser {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return AppUser(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? 'User',
      avatarUrl: user.photoURL,
    );
  }

  Stream<AppUser?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;
      return AppUser(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? 'User',
        avatarUrl: user.photoURL,
      );
    });
  }

  Future<AppUser> signUpWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(displayName);

      return AppUser(
        id: userCredential.user!.uid,
        email: email,
        displayName: displayName,
      );
    } catch (e) {
      print('Error signing up: $e');
      rethrow;
    }
  }

  Future<AppUser> loginWithEmail(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return AppUser(
        id: userCredential.user!.uid,
        email: email,
        displayName: userCredential.user?.displayName ?? 'User',
        avatarUrl: userCredential.user?.photoURL,
      );
    } catch (e) {
      print('Error logging in: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print('Error logging out: $e');
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Error resetting password: $e');
      rethrow;
    }
  }
}
