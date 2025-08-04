class Quiz {
  final int id;
  final String title;
  final List<QuizQuestion> questions;
  final Map<int, int> savedAnswers;

  Quiz({required this.id, required this.title, required this.questions, required this.savedAnswers});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    var questionsList = json['questions'] as List? ?? [];
    List<QuizQuestion> questions = questionsList.map((i) => QuizQuestion.fromJson(i)).toList();

  Map<int, int> answers = {};
    if (json['savedAnswers'] != null) {
      var answerList = json['savedAnswers'] as List;
      for (var answer in answerList) {
        answers[answer['questionId']] = answer['selectedAnswerIndex'];
      }
    }

    return Quiz(
      id: json['quizId'] ?? json['id'],
      title: json['title'],
      questions: questions,
      savedAnswers: answers,
    );
  }
}

class QuizQuestion {
  final int id;
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;

  QuizQuestion({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'],
      questionText: json['questionText'],
      options: List<String>.from(json['options']),
      correctAnswerIndex: json['correctAnswerIndex'],
    );
  }
}