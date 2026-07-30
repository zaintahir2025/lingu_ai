import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';
import '../local_storage/local_storage_provider.dart';

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
  static const String _heartsKey = 'user_hearts';

  GameStateNotifier(this._ref) : super(const GameState()) {
    _loadState();
  }

  /// Load persisted values from Hive (hearts) and Drift DB (XP, streak) on init
  Future<void> _loadState() async {
    try {
      final box = _ref.read(localStorageProvider);
      final savedHearts = box.get(_heartsKey, defaultValue: 5) as int;

      final db = _ref.read(databaseProvider);
      final rows = await db.select(db.userProgress).get();
      int xp = 0;
      int streak = 0;
      if (rows.isNotEmpty) {
        xp = rows.first.totalXp;
        streak = rows.first.currentStreak;
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

  /// Persist hearts to Hive storage
  Future<void> _persistHearts(int hearts) async {
    try {
      final box = _ref.read(localStorageProvider);
      await box.put(_heartsKey, hearts);
    } catch (_) {}
  }
}

final gameStateProvider = StateNotifierProvider<GameStateNotifier, GameState>((ref) {
  return GameStateNotifier(ref);
});
