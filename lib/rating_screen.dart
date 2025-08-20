import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'l10n/app_localizations.dart';
import 'package:confetti/confetti.dart';

class RatingScreen extends StatefulWidget {
  final int pathTemplateId;
  final String pathTitle;

  const RatingScreen({
    super.key,
    required this.pathTemplateId,
    required this.pathTitle,
  });

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int _rating = 8;
  bool _isLoading = false;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 1),
    );
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _showThankYouSnackBar(AppLocalizations l10n) {
    if (!mounted) return;

    final snackBar = SnackBar(
      content: Text(
        l10n.ratingScreen_thankYouTitle,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 24,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      dismissDirection: DismissDirection.up,
      duration: const Duration(seconds: 4),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _submitRating() async {
    setState(() => _isLoading = true);
    final l10n = AppLocalizations.of(context)!;

    try {
      await ApiService().ratePath(widget.pathTemplateId, _rating.toInt());

      if (mounted) {
        _showThankYouSnackBar(l10n);

        if (mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst("Exception: ", ""))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildRatingSelector() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double totalMarginSpace = 10 * 8.0;
        double itemSize = (constraints.maxWidth - totalMarginSpace) / 10;

        if (itemSize > 60) itemSize = 60;
        if (itemSize < 30) itemSize = 30;

        return Row(
          mainAxisAlignment: MainAxisAlignment
              .spaceBetween,
          children: List.generate(10, (index) {
            final number = index + 1;
            final isSelected = _rating == number;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _rating = number;
                });
              },
              child: Container(
                width: itemSize,
                height: itemSize,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(itemSize / 2),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : Colors.grey.shade400,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).colorScheme.secondary.withValues(alpha: 0.3),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    number.toString(),
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).textTheme.bodyLarge?.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          // This is your original UI
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🎉', style: TextStyle(fontSize: 50)),
                  const SizedBox(height: 8),
                  Text(
                    l10n.ratingScreen_congratulationsTitle(widget.pathTitle),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.ratingScreen_callToAction,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(height: 60, child: _buildRatingSelector()),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitRating,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : Text(l10n.ratingScreen_submitRating),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(
                      context,
                    ).popUntil((route) => route.isFirst),
                    child: Text(l10n.ratingScreen_noThanks),
                  ),
                ],
              ),
            ),
          ),

          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            numberOfParticles: 20,
            emissionFrequency: 0.015,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
            ],
          ),
        ],
      ),
    );
  }
}
