import 'package:flutter/material.dart';
import 'dart:async';
import 'services/api_service.dart';
import 'models/quiz_model.dart';
import 'l10n/app_localizations.dart';

class QuizGeneratingScreen extends StatefulWidget {
  final int pathTemplateId;

  const QuizGeneratingScreen({super.key, required this.pathTemplateId});

  @override
  State<QuizGeneratingScreen> createState() => _QuizGeneratingScreenState();
}

class _QuizGeneratingScreenState extends State<QuizGeneratingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _generateQuizAndPop();
  }

  Future<void> _generateQuizAndPop() async {
    try {
      final quiz = await ApiService().generateQuiz(widget.pathTemplateId);
      if (mounted) {
        Navigator.of(context).pop(quiz); // Return the generated quiz
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Pop without data on error
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
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _animationController,
                child: Image.asset(
                  isDarkMode ? 'assets/images/logo_dark.png' : 'assets/images/logo_original_size.png',
                  width: 150,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                l10n.quizScreen_loadingTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}