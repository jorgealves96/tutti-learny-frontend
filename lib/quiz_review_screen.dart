import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'models/quiz_review_model.dart';
import 'l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizReviewScreen extends StatefulWidget {
  final int quizResultId;
  const QuizReviewScreen({super.key, required this.quizResultId});

  @override
  State<QuizReviewScreen> createState() => _QuizReviewScreenState();
}

class _QuizReviewScreenState extends State<QuizReviewScreen> {
  late Future<QuizReview> _reviewFuture;

  @override
  void initState() {
    super.initState();
    _reviewFuture = ApiService().fetchQuizResultDetails(widget.quizResultId);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          l10n.quizReviewScreen_title,
          style: GoogleFonts.lora(
            // Use the Lora font
            fontWeight: FontWeight.bold,
            // Set color based on light/dark mode
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
      body: FutureBuilder<QuizReview>(
        future: _reviewFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Failed to load quiz details.'));
          }

          final review = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: review.answers.length,
            itemBuilder: (context, index) {
              final answer = review.answers[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.quizScreen_questionOf(
                          index + 1,
                          review.totalQuestions,
                        ),
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        answer.questionText,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      ...answer.options.asMap().entries.map((entry) {
                        int optionIndex = entry.key;
                        String optionText = entry.value;

                        Color? tileColor;
                        IconData? iconData;
                        Color? iconColor;

                        // Determine highlighting
                        if (optionIndex == answer.correctAnswerIndex) {
                          tileColor = Colors.green.withOpacity(0.15);
                          iconData = Icons.check_circle;
                          iconColor = Colors.green;
                        } else if (optionIndex == answer.selectedAnswerIndex) {
                          tileColor = Colors.red.withOpacity(0.15);
                          iconData = Icons.cancel;
                          iconColor = Colors.red;
                        }

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          decoration: BoxDecoration(
                            color: tileColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: ListTile(
                            title: Text(optionText),
                            trailing: iconData != null
                                ? Icon(iconData, color: iconColor)
                                : null,
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
