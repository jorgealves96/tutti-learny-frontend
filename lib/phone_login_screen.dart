import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'services/auth_service.dart';
import 'l10n/app_localizations.dart';
import 'package:country_codes/country_codes.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneLoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const PhoneLoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();

  bool _isOtpSent = false;
  bool _isLoading = false;
  bool _isAutoVerifying = false;
  String? _verificationId;
  String _countryCode = '+1'; // Default to US
  String? _initialCountryCode;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp(AppLocalizations l10n) async {
    setState(() => _isLoading = true);

    await AuthService.startPhoneLogin(
      phoneNumber: '$_countryCode${_phoneController.text.trim()}',
      onAutoVerificationStarted: () {
        if (mounted) {
          setState(() {
            _isAutoVerifying = true;
            _isLoading = true; // Ensure the loader shows
          });
        }
      },
      onVerificationCompleted: (PhoneAuthCredential credential) {
        _otpController.text = credential.smsCode ?? '';
        _verifyOtp(l10n, credential: credential);
      },
      codeSent: (verificationId, resendToken) {
        if (mounted) {
          setState(() {
            _verificationId = verificationId;
            _isOtpSent = true;
            _isLoading = false;
          });
        }
      },
      verificationFailed: (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to send code: ${e.message}')),
          );
        }
      },
    );
  }

  Future<void> _verifyOtp(
    AppLocalizations l10n, {
    PhoneAuthCredential? credential,
  }) async {
    // If a credential is not passed (manual flow), create it.
    // If it is passed (auto flow), use it directly.
    final authCredential =
        credential ??
        PhoneAuthProvider.credential(
          verificationId: _verificationId!,
          smsCode: _otpController.text.trim(),
        );

    setState(() => _isLoading = true);

    // Use the central sign-in method
    final success = await AuthService.signInWithPhoneCredential(authCredential);

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop();
      widget.onLoginSuccess();
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.phoneLoginScreen_invalidCode)),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _initCountryCode();
  }

  Future<void> _initCountryCode() async {
    // This must be called before accessing country details
    await CountryCodes.init();

    final CountryDetails? details = CountryCodes.detailsForLocale();
    if (details != null && mounted) {
      setState(() {
        _initialCountryCode = details.alpha2Code; // e.g., 'US' or 'PT'
        _countryCode = details.dialCode ?? '+1'; // Set the initial dial code
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final fullPhoneNumber = '$_countryCode${_phoneController.text}';

    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final List<String> favoriteCodes = ['+1', 'US']; // Start with your defaults
    if (_initialCountryCode != null &&
        !favoriteCodes.contains(_initialCountryCode)) {
      favoriteCodes.add(_initialCountryCode!);
    }

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isOtpSent
                  ? l10n.phoneLoginScreen_enterVerificationCodeTitle
                  : l10n.phoneLoginScreen_enterPhoneNumberTitle,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              _isOtpSent
                  ? l10n.phoneLoginScreen_codeSentSubtitle(fullPhoneNumber)
                  : l10n.phoneLoginScreen_enterPhoneNumberSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),

            // --- Phone Number Input ---
            if (!_isOtpSent)
              Row(
                children: [
                  CountryCodePicker(
                    onChanged: (country) {
                      setState(() {
                        _countryCode = country.dialCode!;
                      });
                    },
                    initialSelection: _initialCountryCode ?? 'US',
                    favorite: favoriteCodes,
                    backgroundColor: Colors.transparent,
                    dialogBackgroundColor: theme.scaffoldBackgroundColor,
                    dialogTextStyle: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    searchStyle: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    closeIcon: Icon(
                      Icons.close,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    alignLeft: false,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: l10n.phoneLoginScreen_phoneNumberLabel,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              )
            // --- OTP Code Input (with new logic) ---
            else
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                // Disable the field when auto-verification is happening
                enabled: !_isAutoVerifying,
                decoration: InputDecoration(
                  // Change the label to give user feedback
                  labelText: _isAutoVerifying
                      ? l10n.phoneLoginScreen_verifyingAutomatically
                      : l10n.phoneLoginScreen_otpLabel,
                  border: const OutlineInputBorder(),
                ),
              ),
            const SizedBox(height: 24),

            // --- Main Button (with new logic) ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                // Disable the button if loading or auto-verifying
                onPressed: _isLoading || _isAutoVerifying
                    ? null
                    : (_isOtpSent
                          ? () => _verifyOtp(l10n)
                          : () => _sendOtp(l10n)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : Text(
                        _isOtpSent
                            ? l10n.phoneLoginScreen_verifyCode
                            : l10n.phoneLoginScreen_sendCode,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
