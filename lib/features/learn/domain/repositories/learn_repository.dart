import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../../../../core/database/database.dart';
import '../../../../core/storage/onboarding_storage.dart';
import '../../data/vocab_data.dart';
import '../../data/vocab_translator.dart';

class LearnRepository {
  final AppDatabase _db;
  final OnboardingStorage? _onboardingStorage;

  LearnRepository(this._db, [this._onboardingStorage]);

  Future<void> syncLessonsIfEmpty() async {
    final count = await _db.select(_db.lessons).get();
    if (count.isEmpty) {
      await _db.batch((batch) {
        batch.insertAll(_db.lessons, [
          LessonsCompanion.insert(id: const Value(1), topic: 'Greetings & Salutations', cefrLevel: 'A1', orderIndex: 1, isLocked: const Value(false), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(2), topic: 'Introductions & Names', cefrLevel: 'A1', orderIndex: 2, isLocked: const Value(false), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(3), topic: 'Numbers & Counting', cefrLevel: 'A1', orderIndex: 3, isLocked: const Value(false), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(4), topic: 'Food & Dining', cefrLevel: 'A1', orderIndex: 4, isLocked: const Value(false), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(5), topic: 'Family & Relations', cefrLevel: 'A1', orderIndex: 5, isLocked: const Value(false), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(6), topic: 'Travel & Directions', cefrLevel: 'A2', orderIndex: 6, isLocked: const Value(true), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(7), topic: 'Shopping & Prices', cefrLevel: 'A2', orderIndex: 7, isLocked: const Value(true), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(8), topic: 'Daily Routine', cefrLevel: 'A2', orderIndex: 8, isLocked: const Value(true), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(9), topic: 'Weather & Seasons', cefrLevel: 'A2', orderIndex: 9, isLocked: const Value(true), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(10), topic: 'Home & Living', cefrLevel: 'A2', orderIndex: 10, isLocked: const Value(true), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(11), topic: 'Work & Office', cefrLevel: 'B1', orderIndex: 11, isLocked: const Value(true), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(12), topic: 'Health & Wellness', cefrLevel: 'B1', orderIndex: 12, isLocked: const Value(true), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(13), topic: 'Technology & Media', cefrLevel: 'B2', orderIndex: 13, isLocked: const Value(true), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(14), topic: 'Culture & Arts', cefrLevel: 'B2', orderIndex: 14, isLocked: const Value(true), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(15), topic: 'Emergency & Safety', cefrLevel: 'B2', orderIndex: 15, isLocked: const Value(true), isCompleted: const Value(false)),
        ]);
        
        batch.insertAllOnConflictUpdate(_db.vocabWords, seedVocabWords);
      });
    } else {
      final existingVocabCount = await _db.select(_db.vocabWords).get();
      if (existingVocabCount.length < seedVocabWords.length) {
        await _db.batch((batch) {
          batch.insertAllOnConflictUpdate(_db.vocabWords, seedVocabWords);
        });
      }
    }
  }

  Future<void> completeLesson(int lessonId) async {
    await (_db.update(_db.lessons)
          ..where((t) => t.id.equals(lessonId)))
        .write(const LessonsCompanion(isCompleted: Value(true)));

    await (_db.update(_db.lessons)
          ..where((t) => t.id.equals(lessonId + 1)))
        .write(const LessonsCompanion(isLocked: Value(false)));
  }

  Stream<List<Lesson>> watchLessons() {
    return (_db.select(_db.lessons)..orderBy([(t) => OrderingTerm(expression: t.orderIndex)])).watch();
  }

  /// Gets the highest unlocked lesson ID (e.g. if lessons 1, 2, 3 are unlocked, returns 3)
  Future<int> getHighestUnlockedLessonId() async {
    final unlockedLessons = await (_db.select(_db.lessons)
          ..where((t) => t.isLocked.equals(false))
          ..orderBy([(t) => OrderingTerm(expression: t.orderIndex, mode: OrderingMode.desc)]))
        .get();
    
    if (unlockedLessons.isNotEmpty) {
      return unlockedLessons.first.id;
    }
    return 1;
  }

  Future<List<VocabWord>> getVocabForLesson(int lessonId, {String? targetLang, String? uiLocale}) async {
    final defaultWords = await (_db.select(_db.vocabWords)..where((t) => t.lessonId.equals(lessonId))).get();
    final langCode = targetLang ?? _onboardingStorage?.targetLanguage?.toLowerCase() ?? 'es';
    final uiCode = uiLocale ?? 'en';

    return VocabTranslator.translateList(defaultWords, langCode, uiCode);
  }
}

final learnRepositoryProvider = Provider<LearnRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final onboardingStorage = ref.watch(onboardingStorageProvider);
  return LearnRepository(db, onboardingStorage);
});
