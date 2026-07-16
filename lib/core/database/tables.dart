import 'package:drift/drift.dart';

@DataClassName('Lesson')
class Lessons extends Table {
  IntColumn get id => integer()();
  TextColumn get topic => text()();
  TextColumn get cefrLevel => text()();
  IntColumn get orderIndex => integer()();
  BoolColumn get isLocked => boolean().withDefault(const Constant(true))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('VocabWord')
class VocabWords extends Table {
  IntColumn get id => integer()();
  IntColumn get lessonId => integer().references(Lessons, #id)();
  TextColumn get word => text()();
  TextColumn get translation => text()();
  TextColumn get audioUrl => text().nullable()();
  
  // Basic SRS state
  TextColumn get status => text().withDefault(const Constant('new'))(); // new, learning, review, mastered
  DateTimeColumn get nextReviewDate => dateTime().nullable()();

  // SM-2 specific fields
  IntColumn get repetitions => integer().withDefault(const Constant(0))();
  RealColumn get easinessFactor => real().withDefault(const Constant(2.5))();
  IntColumn get interval => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('OfflineReviewLog')
class OfflineReviewLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get vocabWordId => integer().references(VocabWords, #id)();
  IntColumn get quality => integer()();
  DateTimeColumn get timestamp => dateTime()();
}

@DataClassName('UserProgressEntry')
class UserProgress extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get totalXp => integer().withDefault(const Constant(0))();
  IntColumn get level => integer().withDefault(const Constant(1))();
  IntColumn get currentStreak => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastActivityDate => dateTime().nullable()();
  IntColumn get streakFreezes => integer().withDefault(const Constant(0))();
}

@DataClassName('DailyXpEntry')
class DailyXp extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  IntColumn get xpEarned => integer().withDefault(const Constant(0))();
}

@DataClassName('OfflineXpLog')
class OfflineXpLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get xpAmount => integer()();
  TextColumn get reason => text()(); // e.g., 'quiz', 'lesson', 'review'
  DateTimeColumn get timestamp => dateTime()();
}
