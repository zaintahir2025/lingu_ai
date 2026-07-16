class WrongAnswerLog {
  final String questionId;
  final String userAnswer;
  final String correctAnswer;
  final DateTime timestamp;

  const WrongAnswerLog({
    required this.questionId,
    required this.userAnswer,
    required this.correctAnswer,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'userAnswer': userAnswer,
      'correctAnswer': correctAnswer,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory WrongAnswerLog.fromJson(Map<String, dynamic> json) {
    return WrongAnswerLog(
      questionId: json['questionId'] as String,
      userAnswer: json['userAnswer'] as String,
      correctAnswer: json['correctAnswer'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}
