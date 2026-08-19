import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final localStorageProvider = Provider<Box>((ref) {
  throw UnimplementedError('localStorageProvider must be overridden');
});

class LocalStorageService {
  LocalStorageService._();

  static Future<Box> init() async {
    await Hive.initFlutter();
    final box = await Hive.openBox('lingu_ai_box');
    const cleanupMarker = 'removed_legacy_local_records_v1';
    if (box.get(cleanupMarker) != true) {
      await box.deleteAll(const [
        'user_registry_accounts_v1',
        'support_contact_tickets_v1',
        'premium_member',
        'premium_expiry_date',
        'is_premium_member',
        'admin_ads_enabled',
        'admin_banner_ad_id',
        'admin_interstitial_ad_id',
        'admin_bank_name',
        'admin_acc_holder',
        'admin_iban',
        'admin_swift',
        'admin_payout_status',
      ]);
      await box.put(cleanupMarker, true);
    }
    return box;
  }
}
