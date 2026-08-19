int reviewWordQuota(int level) => 30 + (level.clamp(1, 99) - 1) * 15;

int reviewEligibleLessonCount(int level) => level.clamp(1, 99) + 1;
