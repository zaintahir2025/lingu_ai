import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Lessons,
    VocabWords,
    OfflineReviewLogs,
    UserProgress,
    DailyXp,
    OfflineXpLogs,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase()
    : super(
        driftDatabase(
          name: 'linguai_db',
        ),
      );

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) => m.createAll(),
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.addColumn(vocabWords, vocabWords.exampleSentence);
        await m.addColumn(vocabWords, vocabWords.exampleTranslation);
        await m.addColumn(userProgress, userProgress.hearts);
      }
    },
  );

  Future<List<VocabWord>> getRecentMistakes({int limit = 5}) async {
    return (select(vocabWords)
          ..where(
            (t) => t.easinessFactor.isSmallerThanValue(2.5),
          ) // threshold for difficult
          ..orderBy([
            (t) => OrderingTerm(
              expression: t.easinessFactor,
              mode: OrderingMode.asc,
            ),
          ])
          ..limit(limit))
        .get();
  }
}

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});
