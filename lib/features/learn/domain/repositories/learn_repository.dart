import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../../../../core/database/database.dart';

class LearnRepository {
  final AppDatabase _db;

  LearnRepository(this._db);

  Future<void> syncLessonsIfEmpty() async {
    final count = await _db.select(_db.lessons).get();
    if (count.isEmpty) {
      // Mock data payload
      await _db.batch((batch) {
        batch.insertAll(_db.lessons, [
          LessonsCompanion.insert(id: const Value(1), topic: 'Greetings', cefrLevel: 'A1', orderIndex: 1, isLocked: const Value(false), isCompleted: const Value(true)),
          LessonsCompanion.insert(id: const Value(2), topic: 'Introductions', cefrLevel: 'A1', orderIndex: 2, isLocked: const Value(false), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(3), topic: 'Food & Drink', cefrLevel: 'A1', orderIndex: 3, isLocked: const Value(true), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(4), topic: 'Travel', cefrLevel: 'A2', orderIndex: 4, isLocked: const Value(true), isCompleted: const Value(false)),
        ]);
        
        batch.insertAll(_db.vocabWords, [
          VocabWordsCompanion.insert(id: const Value(1), lessonId: 2, word: 'Hola', translation: 'Hello', audioUrl: const Value('https://actions.google.com/sounds/v1/speech/voices/en-US_standard_a_female_saying_hello.ogg')), 
          VocabWordsCompanion.insert(id: const Value(2), lessonId: 2, word: 'Adiós', translation: 'Goodbye', audioUrl: const Value('https://actions.google.com/sounds/v1/speech/voices/en-US_standard_a_female_saying_goodbye.ogg')),
          VocabWordsCompanion.insert(id: const Value(3), lessonId: 2, word: 'Por favor', translation: 'Please', audioUrl: const Value('https://actions.google.com/sounds/v1/speech/voices/en-US_standard_a_female_saying_please.ogg')),
        ]);
      });
    }
  }

  Stream<List<Lesson>> watchLessons() {
    return (_db.select(_db.lessons)..orderBy([(t) => OrderingTerm(expression: t.orderIndex)])).watch();
  }

  Future<List<VocabWord>> getVocabForLesson(int lessonId) {
    return (_db.select(_db.vocabWords)..where((t) => t.lessonId.equals(lessonId))).get();
  }
}

final learnRepositoryProvider = Provider<LearnRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return LearnRepository(db);
});
