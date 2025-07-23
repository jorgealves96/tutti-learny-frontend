import 'package:flutter/material.dart';
import 'dart:async';
import 'api_service.dart';

class GeneratingPathScreen extends StatefulWidget {
  final String prompt;

  const GeneratingPathScreen({super.key, required this.prompt});

  @override
  State<GeneratingPathScreen> createState() => _GeneratingPathScreenState();
}

class _GeneratingPathScreenState extends State<GeneratingPathScreen> with SingleTickerProviderStateMixin {
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
        // Show the specific error message from the API
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            // Remove the generic "Exception: " prefix for a cleaner message
            content: Text(e.toString().replaceFirst("Exception: ", "")),
            backgroundColor: Colors.orange, // Use a warning color for this type of error
          ),
        );
        
        // --- START OF FIX ---
        // Pop all routes until we get back to the first one (the MainScreen).
        // This ensures the user is returned to the home screen, not the suggestions screen.
        Navigator.of(context).popUntil((route) => route.isFirst);
        // --- END OF FIX ---
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
              const Text(
                'Crafting your personalized learning path',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Our AI is working hard to create a curriculum tailored to your goals and learning style. This may take a few moments.',
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
