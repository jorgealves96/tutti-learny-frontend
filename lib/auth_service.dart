import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'api_service.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final ApiService _apiService = ApiService();

  // Create a ValueNotifier to broadcast user changes
  static final ValueNotifier<User?> currentUserNotifier = ValueNotifier(
    currentUser,
  );

  // --- Helper to update and notify ---
  static Future<void> _syncAndRefreshUser() async {
    await _apiService.syncUser();
    await _firebaseAuth.currentUser?.reload();
    // Update the notifier with the latest user object
    currentUserNotifier.value = _firebaseAuth.currentUser;
  }

  // --- Native Google Sign-In Flow for Firebase ---
  static Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return false;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _firebaseAuth.signInWithCredential(credential);
      await _syncAndRefreshUser();

      return true;
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
        // This callback will be triggered on Android devices that support automatic SMS code resolution.
        await _firebaseAuth.signInWithCredential(credential);
        await _syncAndRefreshUser();
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
      await _syncAndRefreshUser();
      
      return true;
    } catch (e) {
      if (kDebugMode) print('Error verifying phone login: $e');
      return false;
    }
  }

  // --- Existing Methods ---
  static Future<void> logout() async {
    try {
      await GoogleSignIn().signOut();
      await _firebaseAuth.signOut();
    } catch (e) {
      if (kDebugMode) print('Error during logout: $e');
    }
  }

  static Future<String?> getIdToken() async {
    return await _firebaseAuth.currentUser?.getIdToken();
  }

  static Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  static User? get currentUser => _firebaseAuth.currentUser;
}
