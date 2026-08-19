import 'package:flutter_test/flutter_test.dart';
import 'package:lingu_ai/core/srs/srs_service.dart';

void main() {
  group('SrsService', () {
    test('persistent errors are reviewed again within two days', () {
      final result = SrsService().calculateNextReview(
        currentEaseFactor: 2.5,
        currentIntervalDays: 30,
        currentRepetitions: 5,
        currentErrorCount: 3,
        qualityScore: 5,
      );

      expect(result.isPersistentError, isTrue);
      expect(result.intervalDays, 2);
    });

    test('a failed answer increments error count and resets repetition', () {
      final result = SrsService().calculateNextReview(
        currentEaseFactor: 2.5,
        currentIntervalDays: 15,
        currentRepetitions: 3,
        currentErrorCount: 1,
        qualityScore: 1,
      );

      expect(result.errorCount, 2);
      expect(result.repetitions, 0);
      expect(result.intervalDays, 1);
    });
  });
}
