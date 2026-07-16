import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Lessons, VocabWords, OfflineReviewLogs, UserProgress, DailyXp, OfflineXpLogs])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'linguai_db', web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
  )));

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  Future<List<VocabWord>> getRecentMistakes({int limit = 5}) async {
    return (select(vocabWords)
          ..where((t) => t.easinessFactor.isSmallerThanValue(2.5)) // threshold for difficult
          ..orderBy([(t) => OrderingTerm(expression: t.easinessFactor, mode: OrderingMode.asc)])
          ..limit(limit))
        .get();
  }
}

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});
