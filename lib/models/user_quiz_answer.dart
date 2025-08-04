class UserQuizAnswer {
  final int questionId;
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;
  final int selectedAnswerIndex;

  UserQuizAnswer({
    required this.questionId,
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
    required this.selectedAnswerIndex,
  });

  factory UserQuizAnswer.fromJson(Map<String, dynamic> json) {
    return UserQuizAnswer(
      questionId: json['questionId'],
      questionText: json['questionText'],
      options: List<String>.from(json['options']),
      correctAnswerIndex: json['correctAnswerIndex'],
      selectedAnswerIndex: json['selectedAnswerIndex'],
    );
  }
}