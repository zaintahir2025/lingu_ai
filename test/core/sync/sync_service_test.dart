import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:lingu_ai/core/database/database.dart';
import 'package:lingu_ai/core/sync/sync_service.dart';

void main() {
  late AppDatabase db;
  late SyncService syncService;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    syncService = SyncService(db, isTesting: true);
  });

  tearDown(() async {
    await db.close();
  });

  test('logReview online does not queue to database', () async {
    await syncService.logReview(1, 4, true); // true = online
    
    final logs = await db.select(db.offlineReviewLogs).get();
    expect(logs.isEmpty, true, reason: 'Online review should not queue.');
  });

  test('logReview offline queues to database', () async {
    await syncService.logReview(2, 3, false); // false = offline
    
    final logs = await db.select(db.offlineReviewLogs).get();
    expect(logs.length, 1);
    expect(logs.first.vocabWordId, 2);
    expect(logs.first.quality, 3);
  });

  test('syncData flushes offline queues', () async {
    // Queue items offline
    await syncService.logReview(10, 2, false);
    await syncService.logReview(11, 4, false);
    
    var logs = await db.select(db.offlineReviewLogs).get();
    expect(logs.length, 2);

    // Call syncData
    await syncService.syncData();
    
    // Check queues are flushed
    logs = await db.select(db.offlineReviewLogs).get();
    expect(logs.isEmpty, true, reason: 'Sync should clear the offline queue.');
  });
}
