enum QuestionType { multipleChoice, fillBlank, translation, listening }

class QuizQuestion {
  final String id;
  final QuestionType type;
  final String prompt;
  final List<String> options;
  final String correctAnswer;
  final String explanation;

  const QuizQuestion({
    required this.id,
    required this.type,
    required this.prompt,
    this.options = const [],
    required this.correctAnswer,
    required this.explanation,
  });
}
