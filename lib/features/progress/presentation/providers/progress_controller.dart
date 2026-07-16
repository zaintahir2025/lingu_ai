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
      newTotalXp += 5;
      newLevel = calculateLevel(newTotalXp);
      leveledUp = newLevel > currentState.progress.level;
    }

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
}

final progressControllerProvider = AsyncNotifierProvider.autoDispose<ProgressController, ProgressState>(() {
  return ProgressController();
});
