import 'user_quiz_answer.dart';

class QuizReview {
  final int quizResultId;
  final String quizTitle;
  final int score;
  final int totalQuestions;
  final DateTime completedAt;
  final List<UserQuizAnswer> answers;

  QuizReview({
    required this.quizResultId,
    required this.quizTitle,
    required this.score,
    required this.totalQuestions,
    required this.completedAt,
    required this.answers,

  });

  factory QuizReview.fromJson(Map<String, dynamic> json) {
    var answerList = json['answers'] as List? ?? [];
    List<UserQuizAnswer> answers =
        answerList.map((i) => UserQuizAnswer.fromJson(i)).toList();
        
    return QuizReview(
      quizResultId: json['quizResultId'],
      quizTitle: json['quizTitle'],
      score: json['score'],
      totalQuestions: json['totalQuestions'],
      completedAt: DateTime.parse(json['completedAt']),
      answers: answers,
    );
  }
}