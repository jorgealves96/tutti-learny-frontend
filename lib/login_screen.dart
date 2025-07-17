import 'package:flutter/material.dart';
import 'auth_service.dart';

class LoginScreen extends StatelessWidget {
  final VoidCallback onLoginSuccess;

  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo_original_size.png',
                width: 150,
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome to Tutti Learni',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Your personal guide to learn anything.',
                style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 143, 142, 142)),
              ),
              const SizedBox(height: 60),
              // Google Sign-In Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Image.asset('assets/images/google_logo.png', height: 24.0),
                  label: const Text('Continue with Google'),
                  onPressed: () async {
                    final success = await AuthService.signInWithGoogle();
                    if (success) {
                      onLoginSuccess();
                    } else {
                      // Optionally show an error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to sign in with Google.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
