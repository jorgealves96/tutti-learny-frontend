import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'services/auth_service.dart';
import 'l10n/app_localizations.dart';

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
  String? _verificationId;
  String _countryCode = '+1'; // Default to US

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp(l10n) async {
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.phoneLoginScreen_pleaseEnterPhoneNumber)),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });
    try {
      final fullPhoneNumber = '$_countryCode${_phoneController.text.trim()}';
      await AuthService.startPhoneLogin(
        phoneNumber: fullPhoneNumber,
        codeSent: (verificationId, forceResendingToken) {
          setState(() {
            _verificationId = verificationId;
            _isOtpSent = true;
            _isLoading = false;
          });
        },
        verificationFailed: (e) {
          if (!mounted) return;
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to send code: ${e.message}')),
          );
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
    }
  }

  Future<void> _verifyOtp(AppLocalizations l10n) async {
    if (_verificationId == null) return;
    setState(() {
      _isLoading = true;
    });

    final success = await AuthService.verifyPhoneLogin(
      verificationId: _verificationId!,
      otp: _otpController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop();
      widget.onLoginSuccess();
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.phoneLoginScreen_invalidCode)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final fullPhoneNumber = '$_countryCode${_phoneController.text}';

    if (l10n == null) {
      // Return a temporary widget or an empty container while localizations load
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
            if (!_isOtpSent)
              Row(
                children: [
                  CountryCodePicker(
                    onChanged: (country) {
                      setState(() {
                        _countryCode = country.dialCode!;
                      });
                    },
                    initialSelection: 'US',
                    favorite: const ['+1', 'US'],
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
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              )
            else
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.phoneLoginScreen_otpLabel,
                  border: OutlineInputBorder(),
                ),
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : (_isOtpSent ? () => _verifyOtp(l10n) : () => _sendOtp(l10n)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
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
