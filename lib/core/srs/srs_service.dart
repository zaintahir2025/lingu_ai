import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SrsResult {
  final double easeFactor;
  final int intervalDays;
  final int repetitions;
  final DateTime nextReviewDate;
  final int errorCount;
  final bool isPersistentError;

  const SrsResult({
    required this.easeFactor,
    required this.intervalDays,
    required this.repetitions,
    required this.nextReviewDate,
    required this.errorCount,
    required this.isPersistentError,
  });
}

final srsServiceProvider = Provider<SrsService>((ref) => SrsService());

class SrsService {
  /// Calculates next SM-2 interval and ease factor based on user rating q (0 to 5)
  SrsResult calculateNextReview({
    required double currentEaseFactor,
    required int currentIntervalDays,
    required int currentRepetitions,
    required int currentErrorCount,
    required int qualityScore, // 0 = complete blackout, 3 = pass, 5 = perfect
  }) {
    final q = qualityScore.clamp(0, 5);
    double newEaseFactor = currentEaseFactor;
    int newIntervalDays = currentIntervalDays;
    int newRepetitions = currentRepetitions;
    int newErrorCount = currentErrorCount;

    if (q < 3) {
      newRepetitions = 0;
      newIntervalDays = 1;
      newErrorCount += 1;
    } else {
      if (newRepetitions == 0) {
        newIntervalDays = 1;
      } else if (newRepetitions == 1) {
        newIntervalDays = 6;
      } else {
        newIntervalDays = (currentIntervalDays * currentEaseFactor).round();
      }
      newRepetitions += 1;
    }

    // SM-2 Ease Factor calculation
    newEaseFactor =
        currentEaseFactor + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02));
    if (newEaseFactor < 1.3) {
      newEaseFactor = 1.3;
    }

    // PERSISTENT_ERROR override per REQ-SRS-007 (errorCount >= 3)
    final isPersistentError = newErrorCount >= 3;
    if (isPersistentError) {
      newIntervalDays = min(newIntervalDays, 2);
    }

    final nextReviewDate = DateTime.now().add(Duration(days: newIntervalDays));

    return SrsResult(
      easeFactor: newEaseFactor,
      intervalDays: newIntervalDays,
      repetitions: newRepetitions,
      nextReviewDate: nextReviewDate,
      errorCount: newErrorCount,
      isPersistentError: isPersistentError,
    );
  }
}
