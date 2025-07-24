import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'api_service.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final ApiService _apiService = ApiService();
  static final ValueNotifier<User?> currentUserNotifier = ValueNotifier(currentUser);

  // --- NEW: Private helper to handle sync and error rollback ---
  static Future<bool> _syncAndFinalizeLogin() async {
    try {
      // Try to sync with your backend and reload the user profile
      await _apiService.syncUser();
      await _firebaseAuth.currentUser?.reload();
      currentUserNotifier.value = _firebaseAuth.currentUser;
      return true; // Success!
    } catch (e) {
      // If ANY error occurs (e.g., server is down), log it.
      if (kDebugMode) {
        print('Failed to sync or reload user. Logging out. Error: $e');
      }
      // CRITICAL: Log the user out of Firebase to roll back the login.
      await logout(); 
      return false; // Signal that the overall login failed.
    }
  }

  static Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return false;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _firebaseAuth.signInWithCredential(credential);
      // Use the new helper method for sync and error handling
      return await _syncAndFinalizeLogin();
    } catch (e) {
      if (kDebugMode) print('Error during Google Sign-In: $e');
      return false;
    }
  }

  static Future<void> startPhoneLogin({
    required String phoneNumber,
    required void Function(String, int?) codeSent,
    required void Function(FirebaseAuthException) verificationFailed,
  }) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _firebaseAuth.signInWithCredential(credential);
        // Use the new helper method. We don't need the return value here.
        await _syncAndFinalizeLogin();
      },
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  static Future<bool> verifyPhoneLogin({
    required String verificationId,
    required String otp,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      await _firebaseAuth.signInWithCredential(credential);
      // Use the new helper method for sync and error handling
      return await _syncAndFinalizeLogin();
    } catch (e) {
      if (kDebugMode) print('Error verifying phone login: $e');
      return false;
    }
  }
  
  static Future<void> logout() async {
    try {
      await GoogleSignIn().signOut();
      await _firebaseAuth.signOut();
      currentUserNotifier.value = null;
    } catch (e) {
      if (kDebugMode) print('Error during logout: $e');
    }
  }
  
  // --- Rest of your AuthService methods ---
  static Future<String?> getIdToken() async {
    return await _firebaseAuth.currentUser?.getIdToken();
  }
  
  static Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  static User? get currentUser => _firebaseAuth.currentUser;
}