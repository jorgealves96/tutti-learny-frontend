import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  // Replace with your Auth0 Domain and Client ID
  static const String _auth0Domain = 'dev-wu2380ysyl7jqidm.eu.auth0.com';
  static const String _auth0ClientId = '7YoiGcglKQjv6rZgZHnhGgA1rLmdJI8k';
  
  // This should be the 'Identifier' of the API you created in the Auth0 Dashboard
  static const String _auth0Audience = 'https://api.learning-app.com';

  static final Auth0 _auth0 = Auth0(_auth0Domain, _auth0ClientId);
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Method to handle user login
  static Future<bool> login() async {
    try {
      final credentials = await _auth0
          .webAuthentication(scheme: 'demo')
          .login(audience: _auth0Audience); // Add the audience parameter here

      // Securely store the access token
      await _secureStorage.write(
        key: 'access_token',
        value: credentials.accessToken,
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // Method to handle user logout
  static Future<void> logout() async {
    try {
      await _auth0
          .webAuthentication(scheme: 'demo')
          .logout();
      await _secureStorage.delete(key: 'access_token');
    } catch (e) {
      print(e);
    }
  }

  // Method to get the stored access token
  static Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: 'access_token');
  }

  // Method to check if the user is currently logged in
  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null;
  }
}
