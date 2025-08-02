import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'api_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final ValueNotifier<User?> currentUserNotifier = ValueNotifier(
    currentUser,
  );

  static Future<void> postLoginSetup() async {
    try {
      await ApiService().syncUser();
      // CRITICAL: Reload the user from Firebase to get the updated displayName
      await _firebaseAuth.currentUser?.reload();
      
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        await ApiService().updateFcmToken(fcmToken);
      }

      // Notify the UI that the user object has new data
      currentUserNotifier.value = _firebaseAuth.currentUser;
    } catch (e) {
      if (kDebugMode) {
        print("Error during post-login setup: $e");
      }
      await logout(); // Log out on failure to prevent a broken state
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

      await _firebaseAuth.signInWithCredential(credential);
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
        await _firebaseAuth.signInWithCredential(credential);
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
      return true;
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

  static Future<String?> getIdToken() async {
    return await _firebaseAuth.currentUser?.getIdToken();
  }

  static Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  static User? get currentUser => _firebaseAuth.currentUser;
}