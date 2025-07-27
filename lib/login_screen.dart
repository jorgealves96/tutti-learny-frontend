import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'phone_login_screen.dart';
import 'l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  // Changed to StatefulWidget
  final VoidCallback onLoginSuccess;

  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // 2. Define theme-aware colors
    final tuttiColor = isDarkMode ? Colors.white : const Color(0xFF141443);
    final learniColor = theme.colorScheme.secondary;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo_original_size.png', width: 150),
              const SizedBox(height: 20),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  // Default style for "Welcome to "
                  style: GoogleFonts.lora(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  children: [
                    TextSpan(text: "${l10n.loginScreen_welcomePrimary} "),
                    TextSpan(
                      text: 'Tutti',
                      style: TextStyle(color: tuttiColor),
                    ),
                    TextSpan(
                      text: ' Learni',
                      style: TextStyle(color: learniColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                l10n.loginScreen_welcomeSecondary,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 60),
              // Google Sign-In Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Image.asset(
                    'assets/images/google_logo.png',
                    height: 24.0,
                  ),
                  label: Text(l10n.loginScreen_continueWithGoogle),
                  onPressed: () async {
                    final success = await AuthService.signInWithGoogle();
                    if (success) {
                      widget.onLoginSuccess();
                    } else {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              l10n.loginScreen_failedToSignInGoogle,
                            ),
                          ),
                        );
                      }
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
              const SizedBox(height: 16),
              // Phone Sign-In Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.phone_android),
                  label: Text(l10n.loginScreen_continueWithPhoneNumber),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhoneLoginScreen(
                          onLoginSuccess: widget.onLoginSuccess,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
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
