import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../../../../core/database/database.dart';
import '../../../../core/network/connectivity_provider.dart';
import '../../../../core/sync/sync_service.dart';

class ProgressState {
  final UserProgressEntry progress;
  final bool hasLevelUp;
  final int addedXp;

  ProgressState(this.progress, {this.hasLevelUp = false, this.addedXp = 0});
}

class ProgressController extends AutoDisposeAsyncNotifier<ProgressState> {
  DateTime Function() _clock = DateTime.now;

  // Allows mocking time in tests
  void setClock(DateTime Function() clock) {
    _clock = clock;
  }

  @override
  Future<ProgressState> build() async {
    return _fetchOrCreateProgress();
  }

  Future<ProgressState> _fetchOrCreateProgress() async {
    final db = ref.read(databaseProvider);
    final list = await db.select(db.userProgress).get();
    if (list.isEmpty) {
      final entry = await db.into(db.userProgress).insertReturning(
        UserProgressCompanion.insert(
          totalXp: const Value(0),
          level: const Value(1),
          currentStreak: const Value(0),
          streakFreezes: const Value(0),
        ),
      );
      return ProgressState(entry);
    }
    return ProgressState(list.first);
  }

  int calculateLevel(int totalXp) {
    if (totalXp < 50) return 1;
    if (totalXp < 150) return 2;
    if (totalXp < 300) return 3;
    if (totalXp < 500) return 4;
    
    int level = 4;
    int threshold = 500;
    while (totalXp >= threshold) {
      level++;
      threshold += (level * 100);
    }
    return level;
  }

  int getThresholdForNextLevel(int currentLevel) {
     if (currentLevel == 1) return 50;
     if (currentLevel == 2) return 150;
     if (currentLevel == 3) return 300;
     if (currentLevel == 4) return 500;

     int threshold = 500;
     for (int i = 5; i <= currentLevel; i++) {
        threshold += (i * 100);
     }
     return threshold;
  }

  Future<void> addXp(int amount) async {
    final currentState = state.value;
    if (currentState == null) return;
    
    final db = ref.read(databaseProvider);
    final now = _clock();
    
    int newTotalXp = currentState.progress.totalXp + amount;
    int newLevel = calculateLevel(newTotalXp);
    bool leveledUp = newLevel > currentState.progress.level;

    // Streak logic
    int newStreak = currentState.progress.currentStreak;
    int freezes = currentState.progress.streakFreezes;
    DateTime? lastActivity = currentState.progress.lastActivityDate;
    
    bool appliedDailyBonus = false;

    if (lastActivity != null) {
      final lastDate = DateTime(lastActivity.year, lastActivity.month, lastActivity.day);
      final currentDate = DateTime(now.year, now.month, now.day);
      final daysBetween = currentDate.difference(lastDate).inDays;

      if (daysBetween == 1) {
        newStreak += 1;
        appliedDailyBonus = true;
      } else if (daysBetween > 1) {
        // Skipped at least one day
        if (freezes > 0) {
          freezes -= 1; // Consume freeze
          newStreak += 1;
          appliedDailyBonus = true;
        } else {
          newStreak = 1; // Reset
          appliedDailyBonus = true;
        }
      }
      // If daysBetween == 0, it's the same day, no streak change
    } else {
      // First activity ever
      newStreak = 1;
      appliedDailyBonus = true;
    }

    if (appliedDailyBonus) {
      amount += 5;
    }

    // Apply streak multiplier (cap at x3, which is +200% bonus)
    if (newStreak > 1) {
      double multiplier = 1.0 + (newStreak * 0.1);
      if (multiplier > 3.0) multiplier = 3.0; // max 3x
      amount = (amount * multiplier).round();
    }

    newTotalXp += amount;
    newLevel = calculateLevel(newTotalXp);
    leveledUp = newLevel > currentState.progress.level;

    // Update DB
    final updated = currentState.progress.copyWith(
      totalXp: newTotalXp,
      level: newLevel,
      currentStreak: newStreak,
      streakFreezes: freezes,
      lastActivityDate: Value(now),
    );

    await db.update(db.userProgress).replace(updated);
    
    // Insert into DailyXp
    final dailyDate = DateTime(now.year, now.month, now.day);
    // Find if daily entry exists
    final dailyEntry = await (db.select(db.dailyXp)..where((t) => t.date.equals(dailyDate))).getSingleOrNull();
    if (dailyEntry != null) {
      await db.update(db.dailyXp).replace(dailyEntry.copyWith(xpEarned: dailyEntry.xpEarned + amount));
    } else {
      await db.into(db.dailyXp).insert(DailyXpCompanion.insert(
        date: dailyDate,
        xpEarned: Value(amount),
      ));
    }

    // Sync XP
    final isOnline = ref.read(connectivityProvider).value ?? false;
    await ref.read(syncServiceProvider).logXp(amount, 'activity', isOnline);

    state = AsyncData(ProgressState(updated, hasLevelUp: leveledUp, addedXp: amount));
  }

  void clearFlags() {
    if (state.value != null) {
      state = AsyncData(ProgressState(state.value!.progress, hasLevelUp: false, addedXp: 0));
    }
  }

  Future<List<double>> getWeeklyXp() async {
    final db = ref.read(databaseProvider);
    final now = _clock();
    final today = DateTime(now.year, now.month, now.day);
    
    // We want the last 7 days including today.
    // Index 6 = today, Index 5 = yesterday, ..., Index 0 = 6 days ago.
    final List<double> weeklyXp = List.filled(7, 0.0);
    
    for (int i = 0; i < 7; i++) {
      final targetDate = today.subtract(Duration(days: 6 - i));
      final entry = await (db.select(db.dailyXp)..where((t) => t.date.equals(targetDate))).getSingleOrNull();
      if (entry != null) {
        weeklyXp[i] = entry.xpEarned.toDouble();
      }
    }
    
    return weeklyXp;
  }

  Future<int> getMasteredWordsCount() async {
    final db = ref.read(databaseProvider);
    final countExp = db.vocabWords.id.count();
    final query = db.selectOnly(db.vocabWords)..addColumns([countExp])..where(db.vocabWords.status.equals('mastered'));
    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }

  Future<int> getCompletedLessonsCount() async {
    final db = ref.read(databaseProvider);
    final countExp = db.lessons.id.count();
    final query = db.selectOnly(db.lessons)..addColumns([countExp])..where(db.lessons.isCompleted.equals(true));
    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }

  Future<int> getMinutesSpent() async {
    // Estimating 1 minute per 10 XP earned total
    final currentState = state.value;
    if (currentState == null) return 0;
    return (currentState.progress.totalXp / 10).floor();
  }
}

final progressControllerProvider = AsyncNotifierProvider.autoDispose<ProgressController, ProgressState>(() {
  return ProgressController();
});

final weeklyXpProvider = FutureProvider.autoDispose<List<double>>((ref) async {
  final controller = ref.read(progressControllerProvider.notifier);
  return await controller.getWeeklyXp();
});

final masteredWordsCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final controller = ref.read(progressControllerProvider.notifier);
  return await controller.getMasteredWordsCount();
});

final completedLessonsCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final controller = ref.read(progressControllerProvider.notifier);
  return await controller.getCompletedLessonsCount();
});

final minutesSpentProvider = FutureProvider.autoDispose<int>((ref) async {
  final controller = ref.read(progressControllerProvider.notifier);
  return await controller.getMinutesSpent();
});
