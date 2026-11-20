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

    test('ratings above the supported range are clamped to five', () {
      final result = SrsService().calculateNextReview(
        currentEaseFactor: 2.5,
        currentIntervalDays: 1,
        currentRepetitions: 1,
        currentErrorCount: 0,
        qualityScore: 10,
      );

      expect(result.repetitions, 2);
      expect(result.intervalDays, 6);
      expect(result.easeFactor, 2.6);
    });

    test('a corrupt zero-day interval never schedules an immediate review', () {
      final result = SrsService().calculateNextReview(
        currentEaseFactor: 2.5,
        currentIntervalDays: 0,
        currentRepetitions: 2,
        currentErrorCount: 0,
        qualityScore: 4,
      );

      expect(result.intervalDays, 1);
    });
  });
}
