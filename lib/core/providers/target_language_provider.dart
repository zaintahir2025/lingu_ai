import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../storage/onboarding_storage.dart';
import '../../features/user/presentation/controllers/user_controller.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../database/database.dart';
import '../audio/tts_service.dart';
import '../../features/progress/presentation/providers/progress_controller.dart';
import '../../features/learn/data/vocab_data.dart';
import '../../features/learn/domain/repositories/learn_repository.dart';

class TargetLanguages {
  static const Map<String, String> languages = {
    'es': 'Spanish 🇪🇸',
    'fr': 'French 🇫🇷',
    'ja': 'Japanese 🇯🇵',
    'de': 'German 🇩🇪',
  };

  static const Map<String, String> flags = {
    'es': '🇪🇸',
    'fr': '🇫🇷',
    'ja': '🇯🇵',
    'de': '🇩🇪',
  };

  static String getName(String code) => languages[code] ?? 'Spanish 🇪🇸';
  static String getFlag(String code) => flags[code] ?? '🇪🇸';
}

final targetLanguageProvider =
    StateNotifierProvider<TargetLanguageNotifier, String>((ref) {
      final onboardingStorage = ref.watch(onboardingStorageProvider);
      final initialLang = onboardingStorage.targetLanguage ?? 'es';
      return TargetLanguageNotifier(ref, onboardingStorage, initialLang);
    });

class TargetLanguageNotifier extends StateNotifier<String> {
  final Ref _ref;
  final OnboardingStorage _storage;

  TargetLanguageNotifier(this._ref, this._storage, String initial)
    : super(initial);

  Future<void> switchLanguage(
    String newLangCode, {
    bool forceReset = false,
  }) async {
    final bool isLanguageChanged = newLangCode != state;
    final bool shouldReset = isLanguageChanged || forceReset;

    await _storage.setTargetLanguage(newLangCode);
    state = newLangCode;

    // Update AuthState user targetLanguage so route redirects work correctly
    try {
      final currentUser = _ref.read(authControllerProvider).user;
      if (currentUser != null) {
        final updated = currentUser.copyWith(targetLanguage: newLangCode);
        _ref.read(authControllerProvider.notifier).updateUser(updated);
      }
    } catch (_) {}

    // Sync to user profile backend/state
    try {
      await _ref
          .read(userControllerProvider.notifier)
          .updateProfile(targetLanguage: newLangCode);
    } catch (_) {
      // Clear error state if backend sync failed (e.g. standalone/offline mode)
      _ref.read(userControllerProvider.notifier).state = const UserState();
    }

    // Re-initialize TTS language
    try {
      await _ref.read(ttsServiceProvider).initLanguage(newLangCode);
    } catch (_) {}

    if (shouldReset) {
      try {
        final db = _ref.read(databaseProvider);

        // 1. Reset lessons 1..5 to unlocked & uncompleted
        await (db.update(db.lessons)
              ..where((t) => t.id.isSmallerThanOrEqualValue(5)))
            .write(
          const LessonsCompanion(
            isCompleted: Value(false),
            isLocked: Value(false),
          ),
        );

        // 2. Reset lessons 6..15 to locked & uncompleted
        await (db.update(db.lessons)
              ..where((t) => t.id.isBiggerThanValue(5)))
            .write(
          const LessonsCompanion(
            isCompleted: Value(false),
            isLocked: Value(true),
          ),
        );

        // 3. Re-seed original base words to fix any corrupted translated records
        await db.batch((batch) {
          batch.insertAllOnConflictUpdate(db.vocabWords, seedVocabWords);
        });

        // 4. Reset review SRS memory strength stats
        await db.update(db.vocabWords).write(
          const VocabWordsCompanion(
            repetitions: Value(0),
            interval: Value(1),
            easinessFactor: Value(2.5),
            nextReviewDate: Value(null),
            status: Value('learning'),
          ),
        );

        // 5. Reset XP, streak, levels, and daily activity in Drift database
        await db.delete(db.userProgress).go();
        await db.delete(db.dailyXp).go();
        await db.into(db.userProgress).insert(
          UserProgressCompanion.insert(
            totalXp: const Value(0),
            level: const Value(1),
            currentStreak: const Value(0),
            streakFreezes: const Value(0),
          ),
        );
      } catch (e) {
        // Log reset error if any
      }
    }

    // Invalidate dependent providers to force UI refresh safely
    Future.microtask(() {
      _ref.invalidate(progressControllerProvider);
      _ref.invalidate(learnRepositoryProvider);
    });
  }
}
