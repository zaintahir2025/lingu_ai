import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../database/database.dart';

class GameState {
  final int hearts;
  final int xp;
  final int streak;

  const GameState({
    this.hearts = 5,
    this.xp = 0,
    this.streak = 0,
  });

  GameState copyWith({
    int? hearts,
    int? xp,
    int? streak,
  }) {
    return GameState(
      hearts: hearts ?? this.hearts,
      xp: xp ?? this.xp,
      streak: streak ?? this.streak,
    );
  }
}

class GameStateNotifier extends StateNotifier<GameState> {
  final Ref _ref;

  GameStateNotifier(this._ref) : super(const GameState()) {
    _loadState();
  }

  Future<void> _loadState() async {
    try {
      final db = _ref.read(databaseProvider);
      final rows = await db.select(db.userProgress).get();
      int xp = 0;
      int streak = 0;
      int savedHearts = 5;
      if (rows.isNotEmpty) {
        xp = rows.first.totalXp;
        streak = rows.first.currentStreak;
        savedHearts = rows.first.hearts;
      }

      state = GameState(
        hearts: savedHearts,
        xp: xp,
        streak: streak,
      );
    } catch (_) {
      // Keep default values if storage is not initialized
    }
  }

  void reduceHeart() {
    if (state.hearts > 0) {
      final newHearts = state.hearts - 1;
      state = state.copyWith(hearts: newHearts);
      _persistHearts(newHearts);
    }
  }

  void refillHearts() {
    state = state.copyWith(hearts: 5);
    _persistHearts(5);
  }

  void addXp(int amount) {
    state = state.copyWith(xp: state.xp + amount);
  }

  void incrementStreak() {
    state = state.copyWith(streak: state.streak + 1);
  }

  /// Sync the in-memory state from ProgressController (called after XP/streak updates)
  void syncFromProgress(int totalXp, int streak) {
    state = state.copyWith(xp: totalXp, streak: streak);
  }

  /// Persist hearts to DB
  Future<void> _persistHearts(int hearts) async {
    try {
      final db = _ref.read(databaseProvider);
      final rows = await db.select(db.userProgress).get();
      if (rows.isNotEmpty) {
        final progress = rows.first;
        await db.update(db.userProgress).replace(
          progress.copyWith(hearts: hearts),
        );
      } else {
        // Create an entry if it doesn't exist
        await db.into(db.userProgress).insert(
          UserProgressCompanion.insert(
            hearts: Value(hearts),
          ),
        );
      }
    } catch (_) {}
  }
}

final gameStateProvider = StateNotifierProvider<GameStateNotifier, GameState>((ref) {
  return GameStateNotifier(ref);
});
