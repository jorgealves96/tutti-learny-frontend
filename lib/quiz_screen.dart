import 'package:flutter/material.dart';
import 'dart:async';
import 'services/api_service.dart';
import 'models/quiz_model.dart';
import 'l10n/app_localizations.dart';
import 'quiz_review_screen.dart';
import 'models/user_answer_model.dart';
import 'models/subscription_status_model.dart';
import 'package:google_fonts/google_fonts.dart';

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

  void _handleBackNavigation() {
    if (_showResults) {
      // If results are showing, just pop
      Navigator.of(context).pop(true);
    } else {
      // Otherwise, save the progress
      _saveProgressAndExit();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) return;
        _handleBackNavigation();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              if (_showResults) {
                Navigator.of(context).pop(true);
              } else {
                _saveProgressAndExit();
              }
            },
          ),
          title: Text(
            'Quiz - ${widget.pathTitle}',
            style: GoogleFonts.lora(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: FutureBuilder<Quiz?>(
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
                        widget.quizResultIdToResume != null
                            ? l10n.quizScreen_resumingTitle
                            : l10n.quizScreen_loadingTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.quizScreen_loadingSubtitle,
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
              );
            }
            if (snapshot.hasError) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  Navigator.of(
                    context,
                  ).pop({'error': snapshot.error.toString()});
                }
              });
              return const SizedBox.shrink();
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('Failed to load quiz.'));
            }

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
    final progress = (index + 1) / total;
    final bottomSafeArea = MediaQuery.of(context).viewPadding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 24.0 + bottomSafeArea),
      child: Column(
        children: [
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.secondary,
            ),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.quizScreen_questionOf(index + 1, total),
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
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
                elevation: 0,
                color: isSelected
                    ? Theme.of(context).colorScheme.secondary.withOpacity(0.15)
                    : Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected
                        ? Theme.of(context).colorScheme.secondary
                        : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                ),
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
              ElevatedButton.icon(
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
                icon: _isSubmitting && isLastQuestion
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(
                        isLastQuestion
                            ? Icons.check_circle
                            : Icons.arrow_forward,
                      ),
                label: Text(
                  isLastQuestion
                      ? l10n.quizScreen_submit
                      : l10n.quizScreen_nextQuestion,
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultsView(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.emoji_events_outlined,
                size: 80,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.quizScreen_quizComplete,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.quizScreen_yourScore,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                '$_score / ${_quiz!.questions.length}',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(l10n.quizScreen_backToPath),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_quizResultId != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizReviewScreen(
                                quizResultId: _quizResultId!,
                              ),
                            ),
                          );
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.rate_review_outlined,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              l10n.quizReviewScreen_reviewAnswersButton,
                              textAlign:
                                  TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
