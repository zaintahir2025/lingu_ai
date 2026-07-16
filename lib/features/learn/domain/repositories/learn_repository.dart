import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../../../../core/database/database.dart';

class LearnRepository {
  final AppDatabase _db;

  LearnRepository(this._db);

  Future<void> syncLessonsIfEmpty() async {
    final count = await _db.select(_db.lessons).get();
    if (count.isEmpty) {
      await _db.batch((batch) {
        batch.insertAll(_db.lessons, [
          LessonsCompanion.insert(id: const Value(1), topic: 'Greetings', cefrLevel: 'A1', orderIndex: 1, isLocked: const Value(false), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(2), topic: 'Introductions', cefrLevel: 'A1', orderIndex: 2, isLocked: const Value(true), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(3), topic: 'Food & Drink', cefrLevel: 'A1', orderIndex: 3, isLocked: const Value(true), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(4), topic: 'Travel', cefrLevel: 'A2', orderIndex: 4, isLocked: const Value(true), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(5), topic: 'Family', cefrLevel: 'A2', orderIndex: 5, isLocked: const Value(true), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(6), topic: 'Shopping', cefrLevel: 'B1', orderIndex: 6, isLocked: const Value(true), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(7), topic: 'Work & Office', cefrLevel: 'B1', orderIndex: 7, isLocked: const Value(true), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(8), topic: 'Health & Wellness', cefrLevel: 'B2', orderIndex: 8, isLocked: const Value(true), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(9), topic: 'Technology', cefrLevel: 'B2', orderIndex: 9, isLocked: const Value(true), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(10), topic: 'Global Issues', cefrLevel: 'C1', orderIndex: 10, isLocked: const Value(true), isCompleted: const Value(false)),
        ]);
        
        batch.insertAll(_db.vocabWords, [
          // Greetings (Lesson 1)
          VocabWordsCompanion.insert(id: const Value(1), lessonId: 1, word: 'Hola', translation: 'Hello'),
          VocabWordsCompanion.insert(id: const Value(2), lessonId: 1, word: 'Buenos días', translation: 'Good morning'),
          VocabWordsCompanion.insert(id: const Value(3), lessonId: 1, word: 'Adiós', translation: 'Goodbye'),
          VocabWordsCompanion.insert(id: const Value(4), lessonId: 1, word: 'Cómo estás', translation: 'How are you'),

          // Introductions (Lesson 2)
          VocabWordsCompanion.insert(id: const Value(5), lessonId: 2, word: 'Cómo te llamas', translation: 'What is your name'),
          VocabWordsCompanion.insert(id: const Value(6), lessonId: 2, word: 'Mucho gusto', translation: 'Nice to meet you'),
          VocabWordsCompanion.insert(id: const Value(7), lessonId: 2, word: 'De dónde eres', translation: 'Where are you from'),
          VocabWordsCompanion.insert(id: const Value(8), lessonId: 2, word: 'Me llamo', translation: 'My name is'),

          // Food & Drink (Lesson 3)
          VocabWordsCompanion.insert(id: const Value(9), lessonId: 3, word: 'Pan', translation: 'Bread'),
          VocabWordsCompanion.insert(id: const Value(10), lessonId: 3, word: 'Agua', translation: 'Water'),
          VocabWordsCompanion.insert(id: const Value(11), lessonId: 3, word: 'Manzana', translation: 'Apple'),
          VocabWordsCompanion.insert(id: const Value(12), lessonId: 3, word: 'Café', translation: 'Coffee'),

          // Travel (Lesson 4)
          VocabWordsCompanion.insert(id: const Value(13), lessonId: 4, word: 'Aeropuerto', translation: 'Airport'),
          VocabWordsCompanion.insert(id: const Value(14), lessonId: 4, word: 'Hotel', translation: 'Hotel'),
          VocabWordsCompanion.insert(id: const Value(15), lessonId: 4, word: 'Maleta', translation: 'Suitcase'),
          VocabWordsCompanion.insert(id: const Value(16), lessonId: 4, word: 'Viaje', translation: 'Trip'),

          // Family (Lesson 5)
          VocabWordsCompanion.insert(id: const Value(17), lessonId: 5, word: 'Madre', translation: 'Mother'),
          VocabWordsCompanion.insert(id: const Value(18), lessonId: 5, word: 'Padre', translation: 'Father'),
          VocabWordsCompanion.insert(id: const Value(19), lessonId: 5, word: 'Hermano', translation: 'Brother'),
          VocabWordsCompanion.insert(id: const Value(20), lessonId: 5, word: 'Hijo', translation: 'Son'),

          // Shopping (Lesson 6)
          VocabWordsCompanion.insert(id: const Value(21), lessonId: 6, word: 'Camisa', translation: 'Shirt'),
          VocabWordsCompanion.insert(id: const Value(22), lessonId: 6, word: 'Tienda', translation: 'Store'),
          VocabWordsCompanion.insert(id: const Value(23), lessonId: 6, word: 'Descuento', translation: 'Discount'),
          VocabWordsCompanion.insert(id: const Value(24), lessonId: 6, word: 'Cuesta', translation: 'Costs'),

          // Work (Lesson 7)
          VocabWordsCompanion.insert(id: const Value(25), lessonId: 7, word: 'Trabajo', translation: 'Work'),
          VocabWordsCompanion.insert(id: const Value(26), lessonId: 7, word: 'Estudiante', translation: 'Student'),
          VocabWordsCompanion.insert(id: const Value(27), lessonId: 7, word: 'Oficina', translation: 'Office'),
          VocabWordsCompanion.insert(id: const Value(28), lessonId: 7, word: 'Universidad', translation: 'University'),

          // Health (Lesson 8)
          VocabWordsCompanion.insert(id: const Value(29), lessonId: 8, word: 'Salud', translation: 'Health'),
          VocabWordsCompanion.insert(id: const Value(30), lessonId: 8, word: 'Médico', translation: 'Doctor'),
          VocabWordsCompanion.insert(id: const Value(31), lessonId: 8, word: 'Ejercicio', translation: 'Exercise'),
          VocabWordsCompanion.insert(id: const Value(32), lessonId: 8, word: 'Corazón', translation: 'Heart'),

          // Tech (Lesson 9)
          VocabWordsCompanion.insert(id: const Value(33), lessonId: 9, word: 'Computadora', translation: 'Computer'),
          VocabWordsCompanion.insert(id: const Value(34), lessonId: 9, word: 'Pantalla', translation: 'Screen'),
          VocabWordsCompanion.insert(id: const Value(35), lessonId: 9, word: 'Teléfono', translation: 'Phone'),
          VocabWordsCompanion.insert(id: const Value(36), lessonId: 9, word: 'Mensaje', translation: 'Message'),

          // Global Issues (Lesson 10)
          VocabWordsCompanion.insert(id: const Value(37), lessonId: 10, word: 'Globalización', translation: 'Globalization'),
          VocabWordsCompanion.insert(id: const Value(38), lessonId: 10, word: 'Ambiente', translation: 'Environment'),
          VocabWordsCompanion.insert(id: const Value(39), lessonId: 10, word: 'Cultura', translation: 'Culture'),
          VocabWordsCompanion.insert(id: const Value(40), lessonId: 10, word: 'Historia', translation: 'History'),
        ]);
      });
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

  Future<List<VocabWord>> getVocabForLesson(int lessonId) {
    return (_db.select(_db.vocabWords)..where((t) => t.lessonId.equals(lessonId))).get();
  }
}

final learnRepositoryProvider = Provider<LearnRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return LearnRepository(db);
});
