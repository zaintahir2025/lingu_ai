import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import '../../core/database/database.dart';
import '../network/connectivity_provider.dart';

class SyncService {
  final AppDatabase _db;
  bool _isSyncing = false;

  SyncService(this._db);

  Future<void> syncData() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      debugPrint('SyncService: Starting Sync Sequence...');

      // 1. PUSH Phase: Flush local queues to backend
      await _pushLocalData();

      // 2. PULL Phase: Fetch baseline state from backend
      await _pullServerData();

      // 3. RECONCILE Phase: Apply last-write-wins (handled implicitly by pushing first)
      
      // 4. NOTIFY Phase: Let UI know we are caught up
      debugPrint('SyncService: All caught up!');
      _notifyUser();
    } catch (e) {
      debugPrint('SyncService: Sync failed: $e');
    } finally {
      _isSyncing = false;
    }
  }

  void _notifyUser() {
    final context = rootScaffoldMessengerKey.currentContext;
    if (context != null) {
      rootScaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.cloud_done, color: Colors.white),
              SizedBox(width: 8),
              Text('All caught up!'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _pushLocalData() async {
    // Sync SM-2 Logs
    final logs = await _db.select(_db.offlineReviewLogs).get();
    if (logs.isNotEmpty) {
      debugPrint('SyncService: Pushing ${logs.length} SM-2 review logs...');
      for (final log in logs) {
        await _sendToApi(log.vocabWordId, log.quality);
        await (_db.delete(_db.offlineReviewLogs)..where((t) => t.id.equals(log.id))).go();
      }
    }
    
    // Sync XP Logs
    final xpLogs = await _db.select(_db.offlineXpLogs).get();
    if (xpLogs.isNotEmpty) {
      debugPrint('SyncService: Pushing ${xpLogs.length} XP logs...');
      for (final log in xpLogs) {
        await _sendXpToApi(log.xpAmount, log.reason);
        await (_db.delete(_db.offlineXpLogs)..where((t) => t.id.equals(log.id))).go();
      }
    }
  }

  Future<void> _pullServerData() async {
    // Mock fetching fresh data from server
    await Future.delayed(const Duration(milliseconds: 300));
    debugPrint('SyncService: Pulled fresh server data.');
  }

  Future<void> logReview(int vocabWordId, int quality, bool isOnline) async {
    if (isOnline) {
      try {
        await _sendToApi(vocabWordId, quality);
      } catch (e) {
        debugPrint('Direct sync failed, queuing offline: $e');
        await _queueOfflineReview(vocabWordId, quality);
      }
    } else {
      await _queueOfflineReview(vocabWordId, quality);
    }
  }

  Future<void> logXp(int amount, String reason, bool isOnline) async {
    if (isOnline) {
      try {
        await _sendXpToApi(amount, reason);
      } catch (e) {
        debugPrint('Direct XP sync failed, queuing offline: $e');
        await _queueOfflineXp(amount, reason);
      }
    } else {
      await _queueOfflineXp(amount, reason);
    }
  }

  Future<void> _queueOfflineReview(int vocabWordId, int quality) async {
    await _db.into(_db.offlineReviewLogs).insert(
      OfflineReviewLogsCompanion.insert(
        vocabWordId: vocabWordId,
        quality: quality,
        timestamp: DateTime.now(),
      ),
    );
  }

  Future<void> _queueOfflineXp(int amount, String reason) async {
    await _db.into(_db.offlineXpLogs).insert(
      OfflineXpLogsCompanion.insert(
        xpAmount: amount,
        reason: reason,
        timestamp: DateTime.now(),
      ),
    );
  }

  Future<void> _sendToApi(int vocabWordId, int quality) async {
    // Mock network request
    await Future.delayed(const Duration(milliseconds: 200));
  }

  Future<void> _sendXpToApi(int amount, String reason) async {
    // Mock network request
    await Future.delayed(const Duration(milliseconds: 200));
  }
}

final syncServiceProvider = Provider<SyncService>((ref) {
  final db = ref.read(databaseProvider);
  final service = SyncService(db);
  
  ref.listen(connectivityProvider, (previous, next) {
    // Trigger sync when transitioning from offline/unknown to online
    if (next.value == true && (previous?.value == false || previous == null)) {
      service.syncData();
    }
  });

  return service;
});
