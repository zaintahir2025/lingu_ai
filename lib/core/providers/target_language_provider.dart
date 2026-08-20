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
    bool resetProgress = true,
  }) async {
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
    } catch (_) {}

    // Re-initialize TTS language
    try {
      await _ref.read(ttsServiceProvider).initLanguage(newLangCode);
    } catch (_) {}

    if (resetProgress) {
      try {
        final db = _ref.read(databaseProvider);
        await (db.update(
          db.lessons,
        )..where((t) => t.id.isBiggerThanValue(1))).write(
          const LessonsCompanion(
            isCompleted: Value(false),
            isLocked: Value(true),
          ),
        );
        await (db.update(db.lessons)..where((t) => t.id.equals(1))).write(
          const LessonsCompanion(
            isCompleted: Value(false),
            isLocked: Value(false),
          ),
        );

        // Re-seed original base words to fix any corrupted translated records
        await db.batch((batch) {
          batch.insertAllOnConflictUpdate(db.vocabWords, seedVocabWords);
        });

        await db
            .update(db.vocabWords)
            .write(
              const VocabWordsCompanion(
                repetitions: Value(0),
                interval: Value(1),
                easinessFactor: Value(2.5),
                nextReviewDate: Value(null),
                status: Value('learning'),
              ),
            );
      } catch (_) {}
    }

    // Invalidate dependent providers to force UI refresh safely
    Future.microtask(() {
      _ref.invalidate(progressControllerProvider);
      _ref.invalidate(learnRepositoryProvider);
    });
  }
}
