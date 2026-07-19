import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../main.dart';
import '../../core/database/database.dart';
import '../network/connectivity_provider.dart';
import '../network/api_config.dart';

class SyncService {
  final AppDatabase _db;
  final Dio _dio;
  final FlutterSecureStorage _storage;
  bool _isSyncing = false;
  bool isTesting;

  static String get baseUrl => '${ApiConfig.baseUrl}/sync';

  SyncService(this._db, {this.isTesting = false})
    : _dio = Dio(),
      _storage = const FlutterSecureStorage();

  Future<void> syncData() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      debugPrint('SyncService: Starting Sync Sequence...');

      await _pushLocalData();
      await _pullServerData();
      
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

  Future<String?> _getToken() async {
    return await _storage.read(key: 'jwt');
  }

  Future<void> _pushLocalData() async {
    final token = await _getToken();
    if (token == null) return; // not logged in

    // Sync SM-2 Logs
    final logs = await _db.select(_db.offlineReviewLogs).get();
    if (logs.isNotEmpty) {
      debugPrint('SyncService: Pushing ${logs.length} SM-2 review logs...');
      try {
        await _dio.post('$baseUrl/reviews', 
          data: {
            'logs': logs.map((l) => {'vocabWordId': l.vocabWordId, 'quality': l.quality}).toList(),
          },
          options: Options(headers: {'Authorization': 'Bearer $token'})
        );
        for (final log in logs) {
          await (_db.delete(_db.offlineReviewLogs)..where((t) => t.id.equals(log.id))).go();
        }
      } catch (e) {
        debugPrint('Failed to sync reviews: $e');
      }
    }
    
    // Sync XP Logs
    final xpLogs = await _db.select(_db.offlineXpLogs).get();
    if (xpLogs.isNotEmpty) {
      debugPrint('SyncService: Pushing ${xpLogs.length} XP logs...');
      try {
        await _dio.post('$baseUrl/xp', 
          data: {
            'logs': xpLogs.map((l) => {'amount': l.xpAmount, 'reason': l.reason}).toList(),
          },
          options: Options(headers: {'Authorization': 'Bearer $token'})
        );
        for (final log in xpLogs) {
          await (_db.delete(_db.offlineXpLogs)..where((t) => t.id.equals(log.id))).go();
        }
      } catch (e) {
        debugPrint('Failed to sync XP: $e');
      }
    }
  }

  Future<void> _pullServerData() async {
    // Implement fetch latest stats/vocab from server here if needed.
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> logReview(int vocabWordId, int quality, bool isOnline) async {
    await _queueOfflineReview(vocabWordId, quality);
    if (isOnline) {
      await syncData();
    }
  }

  Future<void> logXp(int amount, String reason, bool isOnline) async {
    await _queueOfflineXp(amount, reason);
    if (isOnline) {
      await syncData();
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
}

final syncServiceProvider = Provider<SyncService>((ref) {
  final db = ref.read(databaseProvider);
  final service = SyncService(db);
  
  ref.listen(connectivityProvider, (previous, next) {
    if (next.value == true && (previous?.value == false || previous == null)) {
      service.syncData();
    }
  });

  return service;
});
