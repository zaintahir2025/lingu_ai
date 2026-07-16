import 'package:flutter_test/flutter_test.dart';
import 'package:lingu_ai/core/algorithms/sm2.dart';

void main() {
  group('SM2 Algorithm Tests', () {
    test('First Review (Good)', () {
      final result = calculateSM2(quality: 4, repetitions: 0, easinessFactor: 2.5, interval: 0);
      expect(result.repetitions, 1);
      expect(result.interval, 1);
      expect(result.easinessFactor, 2.5);
    });

    test('Second Review (Good)', () {
      final result = calculateSM2(quality: 4, repetitions: 1, easinessFactor: 2.5, interval: 1);
      expect(result.repetitions, 2);
      expect(result.interval, 6);
      expect(result.easinessFactor, 2.5);
    });

    test('Third Review (Good)', () {
      final result = calculateSM2(quality: 4, repetitions: 2, easinessFactor: 2.5, interval: 6);
      expect(result.repetitions, 3);
      expect(result.interval, 15);
      expect(result.easinessFactor, 2.5);
    });

    test('Hard Review', () {
      final result = calculateSM2(quality: 3, repetitions: 2, easinessFactor: 2.5, interval: 6);
      expect(result.repetitions, 3);
      expect(result.interval, 15); // It still increments but EF drops
      expect(result.easinessFactor, 2.36);
    });

    test('Complete Failure (Again)', () {
      final result = calculateSM2(quality: 0, repetitions: 3, easinessFactor: 2.5, interval: 15);
      expect(result.repetitions, 0);
      expect(result.interval, 1);
      expect(result.easinessFactor, 1.7);
    });

    test('EF Lower Bound Limit', () {
      final result = calculateSM2(quality: 0, repetitions: 0, easinessFactor: 1.3, interval: 1);
      expect(result.repetitions, 0);
      expect(result.interval, 1);
      expect(result.easinessFactor, 1.3); // Cannot drop below 1.3
    });
  });
}
