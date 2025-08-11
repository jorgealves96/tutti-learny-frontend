import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'api_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthService {
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

static Future<void> postLoginSetup() async {
  try {
    // We still try to sync the latest data.
    await ApiService().syncUser();
    await firebaseAuth.currentUser?.reload();
  } catch (e) {
    // If the sync fails, we don't crash. We just log the error
    // and let the app continue with the user's cached data.
    if (kDebugMode) {
      print("Non-critical error during post-login setup: $e. App will continue with cached user.");
    }
  }
}

  static Future<void> updateFcmTokenInBackground() async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        // This runs quietly in the background.
        await ApiService().updateFcmToken(fcmToken);
      }
    } catch (e) {
      // A failure here shouldn't crash the app or log the user out.
      // Just log it for debugging purposes.
      if (kDebugMode) {
        print("Failed to update FCM token in background: $e");
      }
    }
  }

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

      await firebaseAuth.signInWithCredential(credential);
      return true;
    } catch (e) {
      if (kDebugMode) print('Error during Google Sign-In: $e');
      return false;
    }
  }

  static Future<bool> signInWithPhoneCredential(
    PhoneAuthCredential credential,
  ) async {
    try {
      await firebaseAuth.signInWithCredential(credential);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Failed to sign in with phone credential: $e");
      }
      return false;
    }
  }

  static Future<void> startPhoneLogin({
    required String phoneNumber,
    required Function(PhoneAuthCredential) onVerificationCompleted,
    required Function() onAutoVerificationStarted, // ADD THIS
    required Function(String, int?) codeSent,
    required Function(FirebaseAuthException) verificationFailed,
  }) async {
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        onAutoVerificationStarted(); // Call this immediately
        onVerificationCompleted(credential);
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
      await firebaseAuth.signInWithCredential(credential);
      return true;
    } catch (e) {
      if (kDebugMode) print('Error verifying phone login: $e');
      return false;
    }
  }

  static Future<void> logout() async {
    try {
      await GoogleSignIn().signOut();
      await firebaseAuth.signOut();
    } catch (e) {
      if (kDebugMode) print('Error during logout: $e');
    }
  }

  static Future<String?> getIdToken() async {
    return await firebaseAuth.currentUser?.getIdToken();
  }

  static Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();
  static User? get currentUser => firebaseAuth.currentUser;
}
