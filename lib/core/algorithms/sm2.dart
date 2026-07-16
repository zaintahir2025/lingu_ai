

class SM2Result {
  final int repetitions;
  final double easinessFactor;
  final int interval; // in days

  const SM2Result({
    required this.repetitions,
    required this.easinessFactor,
    required this.interval,
  });
}

/// Calculates the next spaced repetition interval using the SM-2 algorithm.
/// 
/// [quality] - User rating from 0 (forgot) to 5 (perfect memory).
/// [repetitions] - Number of times the item has been consecutively successfully recalled.
/// [easinessFactor] - The current easiness factor (starts at 2.5).
/// [interval] - The current interval in days.
SM2Result calculateSM2({
  required int quality,
  required int repetitions,
  required double easinessFactor,
  required int interval,
}) {
  int nextRepetitions;
  double nextEasinessFactor;
  int nextInterval;

  if (quality >= 3) {
    if (repetitions == 0) {
      nextInterval = 1;
    } else if (repetitions == 1) {
      nextInterval = 6;
    } else {
      nextInterval = (interval * easinessFactor).round();
    }
    nextRepetitions = repetitions + 1;
  } else {
    nextRepetitions = 0;
    nextInterval = 1;
  }

  nextEasinessFactor = easinessFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
  
  // EF should never fall below 1.3
  if (nextEasinessFactor < 1.3) {
    nextEasinessFactor = 1.3;
  }
  
  // To avoid precision issues over time, we can round EF to 2 decimal places (optional but common in simple implementations)
  nextEasinessFactor = double.parse(nextEasinessFactor.toStringAsFixed(2));

  return SM2Result(
    repetitions: nextRepetitions,
    easinessFactor: nextEasinessFactor,
    interval: nextInterval,
  );
}
