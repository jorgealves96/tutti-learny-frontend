import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'api_service.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final ApiService _apiService = ApiService();

  // --- Native Google Sign-In Flow for Firebase ---
  static Future<bool> signInWithGoogle() async {
    try {
      // 1. Configure Google Sign-In to request an idToken
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // 2. Trigger the native Google Sign-In UI
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled the sign-in
        return false;
      }

      // 3. Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 4. Create a new credential for Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 5. Sign in to Firebase with the credential
      await _firebaseAuth.signInWithCredential(credential);

      // 6. Sync user with our backend
      await _apiService.syncUser();
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error during Google Sign-In: $e');
      }
      return false;
    }
  }

  // --- Logout ---
  static Future<void> logout() async {
    try {
      await GoogleSignIn().signOut();
      await _firebaseAuth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print('Error during logout: $e');
      }
    }
  }

  // --- Helper Methods ---
  static Future<String?> getIdToken() async {
    return await _firebaseAuth.currentUser?.getIdToken();
  }

  static Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  static User? get currentUser => _firebaseAuth.currentUser;
}
