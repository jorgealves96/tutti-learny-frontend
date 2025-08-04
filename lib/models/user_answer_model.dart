class UserAnswer {
  final int questionId;
  final int selectedAnswerIndex;

  UserAnswer({required this.questionId, required this.selectedAnswerIndex});

  Map<String, dynamic> toJson() => {
        'questionId': questionId,
        'selectedAnswerIndex': selectedAnswerIndex,
      };
}