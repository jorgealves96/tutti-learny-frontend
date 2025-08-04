class QuizResultSummary {
  final int id;
  final int score;
  final int totalQuestions;
  final DateTime completedAt;
  final bool isComplete;

  QuizResultSummary({
    required this.id,
    required this.score,
    required this.totalQuestions,
    required this.completedAt,
    required this.isComplete,
  });

  factory QuizResultSummary.fromJson(Map<String, dynamic> json) {
    return QuizResultSummary(
      id: json['id'],
      score: json['score'],
      totalQuestions: json['totalQuestions'],
      completedAt: DateTime.parse(json['completedAt']),
      isComplete: json['isComplete'] ?? false,
    );
  }
}