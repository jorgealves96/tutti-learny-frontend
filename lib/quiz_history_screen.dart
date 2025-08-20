import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'services/api_service.dart';
import 'models/quiz_history_model.dart';
import 'quiz_screen.dart';
import 'quiz_review_screen.dart';
import 'l10n/app_localizations.dart';
import 'models/subscription_status_model.dart';
import 'subscription_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizHistoryScreen extends StatefulWidget {
  final int pathTemplateId;
  final String pathTitle;
  final SubscriptionStatus? subscriptionStatus;

  const QuizHistoryScreen({
    super.key,
    required this.pathTemplateId,
    required this.pathTitle,
    this.subscriptionStatus,
  });

  @override
  State<QuizHistoryScreen> createState() => _QuizHistoryScreenState();
}

class _QuizHistoryScreenState extends State<QuizHistoryScreen> {
  late Future<List<QuizResultSummary>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = ApiService().fetchQuizHistory(widget.pathTemplateId);
  }

  void _refreshHistory() {
    setState(() {
      _historyFuture = ApiService().fetchQuizHistory(widget.pathTemplateId);
    });
  }

  void _showSubscriptionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) =>
          SubscriptionScreen(currentStatus: widget.subscriptionStatus),
    ).then((needsRefresh) {
      if (needsRefresh == true) {
        _refreshHistory();
      }
    });
  }

  void _showUpgradeDialog(
    AppLocalizations l10n,
    errorMessage,
    SubscriptionStatus? status,
  ) {
    String nextResetDateText = '';
    if (status != null) {
      final nextResetDate = status.lastUsageResetDate.add(
        const Duration(days: 30),
      );
      // Format the date into a user-friendly string (e.g., "August 10, 2025")
      final formattedDate = DateFormat.yMMMMd(
        l10n.localeName,
      ).format(nextResetDate);
      nextResetDateText = l10n.homeScreen_limitResetsOn(formattedDate);
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.homeScreen_usageLimitReached),
          // Use a Column to display multiple lines of text
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(errorMessage.replaceFirst("Exception: ", "")),
              if (nextResetDateText.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  nextResetDateText,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(l10n.homeScreen_maybeLater),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            ElevatedButton(
              child: Text(l10n.homeScreen_upgrade),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
                _showSubscriptionSheet(); // Open the subscription sheet
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToNewQuiz() async {
    final l10n = AppLocalizations.of(context)!;
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(
          pathTemplateId: widget.pathTemplateId,
          pathTitle: widget.pathTitle,
          subscriptionStatus: widget.subscriptionStatus,
        ),
      ),
    );

    // After returning, check the result
    if (result is Map && result.containsKey('error')) {
      if (result['error'].toString().toLowerCase().contains('limit')) {
        _showUpgradeDialog(l10n, l10n.quizHistoryScreen_creationLimitExceeded, widget.subscriptionStatus);
      }
    } else if (result == true) {
      _refreshHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          l10n.quizHistoryScreen_title,
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
      body: FutureBuilder<List<QuizResultSummary>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Failed to load quiz history.'));
          }

          final history = snapshot.data ?? [];

          if (history.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.quizHistoryScreen_noQuizzesTaken,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.quizHistoryScreen_cta, textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: _navigateToNewQuiz,
                    icon: const Icon(Icons.quiz_outlined),
                    label: Text(l10n.quizHistoryScreen_createQuizButton),
                    style: OutlinedButton.styleFrom(
                      // Add padding to make the button bigger
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 32,
                      ),
                      // Set the color for the text and icon
                      foregroundColor: Theme.of(context).colorScheme.secondary,
                      // Set the color and thickness of the border
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 2,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final result = history[index];
                      final bool isComplete = result.isComplete;
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: isComplete
                                ? Text(
                                    '${result.score}/${result.totalQuestions}',
                                  )
                                : const Icon(Icons.play_arrow),
                          ),
                          title: Text(
                            isComplete
                                ? l10n.quizHistoryScreen_score(
                                    result.score,
                                    result.totalQuestions,
                                  )
                                : l10n.quizHistoryScreen_quizInProgress,
                          ),
                          subtitle: Text(
                            l10n.quizHistoryScreen_takenOn(
                              DateFormat.yMd().format(result.completedAt),
                            ),
                          ),
                          onTap: () {
                            if (isComplete) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      QuizReviewScreen(quizResultId: result.id),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QuizScreen(
                                    pathTemplateId: widget.pathTemplateId,
                                    pathTitle: widget.pathTitle,
                                    quizResultIdToResume: result.id,
                                    subscriptionStatus:
                                        widget.subscriptionStatus,
                                  ),
                                ),
                              ).then((_) => _refreshHistory());
                            }
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _navigateToNewQuiz,
                      icon: Icon(Icons.quiz_outlined),
                      label: Text(
                        l10n.quizHistoryScreen_createAnotherQuizButton,
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.secondary,
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 2,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
