import 'package:flutter/material.dart';
import 'dart:async';
import 'api_service.dart';
import 'path_detail_model.dart';

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
      
      // If the widget is still mounted, pop back to the home screen
      // and pass the ID of the newly created path as a result.
      if (mounted) {
        Navigator.pop(context, newPath.id);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating path: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context);
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
      appBar: AppBar(
        title: Text(
          'Tutti Learny',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Pulsating logo animation
              FadeTransition(
                opacity: _animationController,
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/logo.png', // This should be the path to your logo
                    width: 120, // Adjust the size as needed
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
