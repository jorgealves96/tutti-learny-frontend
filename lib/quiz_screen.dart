import 'package:flutter/material.dart';
import 'dart:async';
import 'services/api_service.dart';
import 'models/quiz_model.dart';
import 'l10n/app_localizations.dart';
import 'quiz_review_screen.dart';
import 'models/user_answer_model.dart';
import 'models/subscription_status_model.dart';
import 'subscription_screen.dart';

class QuizScreen extends StatefulWidget {
  final int pathTemplateId;
  final String pathTitle;
  final int? quizResultIdToResume;
  final SubscriptionStatus? subscriptionStatus;

  const QuizScreen({
    super.key,
    required this.pathTemplateId,
    required this.pathTitle,
    this.quizResultIdToResume,
    this.subscriptionStatus,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  late Future<Quiz> _quizFuture;
  late final AnimationController _animationController;
  final PageController _pageController = PageController();

  // --- State Variables ---
  final Map<int, int> _userAnswers = {};
  bool _showResults = false;
  int _score = 0;
  bool _isSubmitting = false;
  int? _quizResultId;
  Quiz? _quiz; // Variable to hold the loaded quiz data

  @override
  void initState() {
    super.initState();

    if (widget.quizResultIdToResume != null) {
      _quizFuture = ApiService().resumeQuiz(widget.quizResultIdToResume!);
    } else {
      _quizFuture = ApiService().generateQuiz(widget.pathTemplateId);
    }

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _submitQuiz() async {
    // Guard against null quiz object, this is the main fix
    if (_quiz == null) return;

    setState(() => _isSubmitting = true);
    final l10n = AppLocalizations.of(context)!;

    try {
      int correctAnswers = 0;
      List<UserAnswer> answersList = [];
      for (var question in _quiz!.questions) {
        final selectedIndex = _userAnswers[question.id] ?? -1;
        final isCorrect = selectedIndex == question.correctAnswerIndex;

        if (isCorrect) {
          correctAnswers++;
        }

        answersList.add(
          UserAnswer(
            questionId: question.id,
            selectedAnswerIndex: selectedIndex,
          ),
        );
      }

      final result = await ApiService().submitQuizResult(
        _quiz!.id,
        answersList,
      );

      setState(() {
        _score = result['score']!;
        _quizResultId = result['quizResultId']!;
        _showResults = true;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to submit quiz: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _saveProgressAndExit() async {
    if (_quiz == null) {
      Navigator.of(context).pop(true);
      return;
    }

    // Create a list of the user's current answers (can be empty)
    List<UserAnswer> answers = [];
    _userAnswers.forEach((questionId, selectedIndex) {
      answers.add(
        UserAnswer(questionId: questionId, selectedAnswerIndex: selectedIndex),
      );
    });

    try {
      // Call the API with isFinalSubmission set to false
      await ApiService().submitQuizResult(
        _quiz!.id,
        answers,
        isFinalSubmission: false,
      );
    } catch (e) {
      // Fail silently, as the user is exiting anyway.
      print("Failed to save quiz progress on exit: $e");
    }

    if (mounted) {
      Navigator.of(context).pop(true); // Pop and signal a refresh
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            if (_showResults) {
              // If results are showing, just pop
              Navigator.of(context).pop(true);
            } else {
              // Otherwise, save the progress
              _saveProgressAndExit();
            }
          },
        ),
        title: Text(widget.pathTitle),
        centerTitle: true,
      ),
      body: FutureBuilder<Quiz>(
        future: _quizFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeTransition(
                      opacity: _animationController,
                      child: Image.asset(
                        isDarkMode
                            ? 'assets/images/logo_original_size_dark.png'
                            : 'assets/images/logo_original_size.png',
                        width: 150,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      // Check if you are resuming a quiz and show different text
                      widget.quizResultIdToResume != null
                          ? l10n
                                .quizScreen_resumingTitle // New string for resuming
                          : l10n.quizScreen_loadingTitle, // Original string for generating
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          if (snapshot.hasError) {
            // Use a post-frame callback to safely show the dialog after the build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                Navigator.of(context).pop({'error': snapshot.error.toString()});
              }
            });
            // Show an empty container while the dialog is being prepared
            return const SizedBox.shrink();
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Failed to load quiz.'));
          }

          // Store the loaded quiz in the state variable
          _quiz = snapshot.data!;

          if (_userAnswers.isEmpty && _quiz!.savedAnswers.isNotEmpty) {
            _userAnswers.addAll(_quiz!.savedAnswers);
          }

          if (_showResults) {
            return _buildResultsView(l10n);
          }

          return PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _quiz!.questions.length,
            itemBuilder: (context, index) {
              final question = _quiz!.questions[index];
              return _buildQuestionView(question, index, l10n);
            },
          );
        },
      ),
    );
  }

  Widget _buildQuestionView(
    QuizQuestion question,
    int index,
    AppLocalizations l10n,
  ) {
    final total = _quiz!.questions.length;
    final isLastQuestion = index == total - 1;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.quizScreen_questionOf(index + 1, total),
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            question.questionText,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          ...question.options.asMap().entries.map((entry) {
            int optionIndex = entry.key;
            String optionText = entry.value;
            bool isSelected = _userAnswers[question.id] == optionIndex;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Card(
                color: isSelected
                    ? Theme.of(context).colorScheme.secondary.withValues(alpha: 0.25)
                    : null,
                child: ListTile(
                  title: Text(optionText),
                  onTap: () =>
                      setState(() => _userAnswers[question.id] = optionIndex),
                ),
              ),
            );
          }),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (index > 0)
                TextButton(
                  onPressed: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  },
                  child: Text(l10n.quizScreen_back),
                ),
              const Spacer(),
              ElevatedButton(
                onPressed:
                    (_userAnswers.containsKey(question.id) && !_isSubmitting)
                    ? () {
                        if (isLastQuestion) {
                          _submitQuiz();
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        }
                      }
                    : null,
                child: _isSubmitting && isLastQuestion
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.black),
                      )
                    : Text(
                        isLastQuestion
                            ? l10n.quizScreen_submit
                            : l10n.quizScreen_nextQuestion,
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultsView(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l10n.quizScreen_quizComplete,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          Text(
            l10n.quizScreen_yourScore,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            '$_score / ${_quiz!.questions.length}',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(l10n.quizScreen_backToPath),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  if (_quizResultId != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // You only need to pass the quizResultId
                        builder: (context) =>
                            QuizReviewScreen(quizResultId: _quizResultId!),
                      ),
                    );
                  }
                },
                child: Text(l10n.quizReviewScreen_reviewAnswersButton),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
