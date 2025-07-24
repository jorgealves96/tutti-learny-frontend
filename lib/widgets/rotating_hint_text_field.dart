import 'dart:async';
import 'package:flutter/material.dart';
import '../models/subscription_status_model.dart'; // Make sure to import your model

class RotatingHintTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback? onSubmitted;
  final int maxLength;
  final SubscriptionStatus? subscriptionStatus; // Add this

  const RotatingHintTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onSubmitted,
    this.maxLength = 300,
    this.subscriptionStatus, // Add this
  });

  @override
  State<RotatingHintTextField> createState() => _RotatingHintTextFieldState();
}

class _RotatingHintTextFieldState extends State<RotatingHintTextField> {
  final List<String> _suggestions = [
    'e.g. Learn guitar basics…',
    'e.g. Start a course on public speaking…',
    'e.g. Master Excel in 30 days…',
    'e.g. Learn to cook Italian food…',
    'e.g. Improve your photography skills…',
    'e.g. Study for the SATs…',
    'e.g. Learn French for travel…',
    'e.g. Build a personal budget…',
    'e.g. Practice meditation techniques…',
    'e.g. Learn to code in Python...',
  ];

  int _currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    _startHintRotation();
  }

  void _onTextChanged() {
    if (mounted) setState(() {});
  }

  void _startHintRotation() {
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!widget.focusNode.hasFocus && widget.controller.text.isEmpty) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _suggestions.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool showAnimatedHint = widget.controller.text.isEmpty;

    String usageText = '';
    if (widget.subscriptionStatus != null) {
      if (widget.subscriptionStatus!.pathGenerationLimit == null) {
        usageText = 'Unlimited Generations';
      } else {
        final remaining =
            widget.subscriptionStatus!.pathGenerationLimit! -
            widget.subscriptionStatus!.pathsGeneratedThisMonth;
        usageText = '$remaining Path Generations Left';
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            if (showAnimatedHint)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    key: ValueKey(_suggestions[_currentIndex]),
                    child: Text(
                      _suggestions[_currentIndex],
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ),
            TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              style: const TextStyle(fontSize: 16),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              maxLength: widget.maxLength,
              decoration: InputDecoration(
                hintText: '',
                filled: false,
                counterText: "", // Hide the default counter
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 20.0,
                ),
              ),
              onSubmitted: (_) => widget.onSubmitted?.call(),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // --- Usage Counter ---
              Text(
                usageText,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              // --- Character Counter ---
              Text(
                "${widget.controller.text.length} / ${widget.maxLength}",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
