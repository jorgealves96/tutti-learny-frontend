import 'dart:async';
import 'package:flutter/material.dart';
import '../models/subscription_status_model.dart';
import '../l10n/app_localizations.dart';

class RotatingHintTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback? onSubmitted;
  final int maxLength;
  final SubscriptionStatus? subscriptionStatus;

  const RotatingHintTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onSubmitted,
    this.maxLength = 300,
    this.subscriptionStatus,
  });

  @override
  State<RotatingHintTextField> createState() => _RotatingHintTextFieldState();
}

class _RotatingHintTextFieldState extends State<RotatingHintTextField> {
  // Suggestions will now be built inside the build method
  int _currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    // Timer logic is now slightly different
    _startHintRotation();
  }

  void _onTextChanged() {
    if (mounted) setState(() {});
  }

  void _startHintRotation() {
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!widget.focusNode.hasFocus && widget.controller.text.isEmpty) {
        setState(() {
          // We don't know the list length here, so we just increment.
          // The modulo will be applied in the build method.
          _currentIndex++;
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
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const SizedBox(height: 50); // Fallback height
    }

    // --- Build the suggestions list dynamically ---
    final List<String> suggestions = [
      l10n.rotatingHintTextField_suggestion1,
      l10n.rotatingHintTextField_suggestion2,
      l10n.rotatingHintTextField_suggestion3,
      l10n.rotatingHintTextField_suggestion4,
      l10n.rotatingHintTextField_suggestion5,
      l10n.rotatingHintTextField_suggestion6,
      l10n.rotatingHintTextField_suggestion7,
      l10n.rotatingHintTextField_suggestion8,
      l10n.rotatingHintTextField_suggestion9,
      l10n.rotatingHintTextField_suggestion10,
    ];

    // Apply modulo here to prevent range errors
    final int displayIndex = _currentIndex % suggestions.length;
    final bool showAnimatedHint = widget.controller.text.isEmpty;

    // --- Build the usage text dynamically ---
    String usageText = '';
    if (widget.subscriptionStatus != null) {
      if (widget.subscriptionStatus!.pathGenerationLimit == null) {
        usageText = l10n.rotatingHintTextField_unlimitedGenerations;
      } else {
        final remaining =
            widget.subscriptionStatus!.pathGenerationLimit! -
            widget.subscriptionStatus!.pathsGeneratedThisMonth;
        usageText = l10n.rotatingHintTextField_generationsLeft(remaining);
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
                    key: ValueKey(suggestions[displayIndex]),
                    child: Text(
                      suggestions[displayIndex],
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
                counterText: "",
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
              Text(
                usageText,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
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