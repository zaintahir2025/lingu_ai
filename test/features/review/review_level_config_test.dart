import 'package:flutter_test/flutter_test.dart';
import 'package:lingu_ai/features/review/domain/review_level_config.dart';

void main() {
  test('review levels begin at 30 words and increase by 15', () {
    expect(reviewWordQuota(1), 30);
    expect(reviewWordQuota(2), 45);
    expect(reviewWordQuota(3), 60);
    expect(reviewWordQuota(5), 90);
  });

  test('invalid levels clamp to level one', () {
    expect(reviewWordQuota(0), 30);
    expect(reviewEligibleLessonCount(0), 2);
  });
}
