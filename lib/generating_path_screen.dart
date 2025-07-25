import 'package:flutter/material.dart';
import 'dart:async';
import 'services/api_service.dart';
import 'l10n/app_localizations.dart';

class GeneratingPathScreen extends StatefulWidget {
  final String prompt;

  const GeneratingPathScreen({super.key, required this.prompt});

  @override
  State<GeneratingPathScreen> createState() => _GeneratingPathScreenState();
}

class _GeneratingPathScreenState extends State<GeneratingPathScreen>
    with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _createPathAndNavigate();
  }

  Future<void> _createPathAndNavigate() async {
    try {
      final newPath = await _apiService.createLearningPath(widget.prompt);

      if (mounted) {
        Navigator.pop(context, newPath.userPathId);
      }
    } catch (e) {
      if (mounted) {
        if (e.toString().toLowerCase().contains('limit')) {
          // Pop and send a signal back to HomeScreen
          Navigator.of(context).pop({'limit_error': e.toString()});
        } else {
          // For other errors, pop and send the error back
          Navigator.of(context).pop({'error': e.toString()});
        }
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (l10n == null) {
      // Return a temporary widget or an empty container while localizations load
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _animationController,
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 120,
                    height: 120,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                l10n.generatingPathsScreen_craftingPersonalizedLearningPath,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.generatingPathsScreen_loadingPathGenerationMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
