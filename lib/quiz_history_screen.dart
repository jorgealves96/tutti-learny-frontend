import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'services/api_service.dart';
import 'models/quiz_history_model.dart';
import 'quiz_screen.dart';
import 'quiz_review_screen.dart';
import 'l10n/app_localizations.dart';
import 'models/subscription_status_model.dart';
import 'subscription_screen.dart';

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
    ).then((_) => _refreshHistory());
  }

  void _showUpgradeDialog(String errorMessage) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.homeScreen_usageLimitReached),
          content: Text(errorMessage.replaceFirst("Exception: ", "")),
          actions: <Widget>[
            TextButton(
              child: Text(l10n.homeScreen_maybeLater),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            ElevatedButton(
              child: Text(l10n.homeScreen_upgrade),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _showSubscriptionSheet();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToNewQuiz() async {
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
        _showUpgradeDialog(result['error']);
      }
    } else if (result == true) {
      _refreshHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.quizHistoryScreen_title)),
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
                  ElevatedButton.icon(
                    onPressed: _navigateToNewQuiz,
                    icon: const Icon(Icons.quiz),
                    label: Text(l10n.quizHistoryScreen_createQuizButton),
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
                    child: ElevatedButton.icon(
                      onPressed: _navigateToNewQuiz,
                      icon: const Icon(Icons.add),
                      label: Text(
                        l10n.quizHistoryScreen_createAnotherQuizButton,
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
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
