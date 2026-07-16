import 'package:flutter_test/flutter_test.dart';
import 'package:lingu_ai/features/quiz/domain/models/wrong_answer_log.dart';

void main() {
  group('WrongAnswerLog Serialization', () {
    test('toJson and fromJson work correctly', () {
      final timestamp = DateTime.utc(2026, 7, 13, 12, 0, 0);
      final log = WrongAnswerLog(
        questionId: 'q1',
        userAnswer: 'wrong',
        correctAnswer: 'right',
        timestamp: timestamp,
      );

      final json = log.toJson();
      expect(json, {
        'questionId': 'q1',
        'userAnswer': 'wrong',
        'correctAnswer': 'right',
        'timestamp': '2026-07-13T12:00:00.000Z',
      });

      final decodedLog = WrongAnswerLog.fromJson(json);
      expect(decodedLog.questionId, log.questionId);
      expect(decodedLog.userAnswer, log.userAnswer);
      expect(decodedLog.correctAnswer, log.correctAnswer);
      expect(decodedLog.timestamp, log.timestamp);
    });
  });
}
