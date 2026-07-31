import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../local_storage/local_storage_provider.dart';

final premiumStorageProvider = Provider<PremiumStorage>((ref) {
  final box = ref.watch(localStorageProvider);
  return PremiumStorage(box);
});

class PremiumStorage {
  final Box _box;
  static const String _isPremiumKey = 'is_premium_member';
  static const String _premiumExpiryKey = 'premium_expiry_date';

  PremiumStorage(this._box);

  /// Returns true if the user is a Premium Member AND their subscription has not expired.
  /// Automatically revokes access if 30 days have passed.
  bool get isPremium {
    final flag = (_box.get(_isPremiumKey, defaultValue: false) as bool?) ?? false;
    if (!flag) return false;

    final expiryIso = _box.get(_premiumExpiryKey) as String?;
    if (expiryIso != null) {
      final expiryDate = DateTime.tryParse(expiryIso);
      if (expiryDate != null && DateTime.now().isAfter(expiryDate)) {
        // Automatically expire 1-month subscription
        _box.put(_isPremiumKey, false);
        return false;
      }
    }
    return true;
  }

  /// Returns the DateTime when the current 1-month premium pass expires, if active.
  DateTime? get expiryDate {
    final expiryIso = _box.get(_premiumExpiryKey) as String?;
    if (expiryIso != null) {
      return DateTime.tryParse(expiryIso);
    }
    return null;
  }

  /// Grants 1-Month (30-day) Premium status to the member
  Future<void> grantOneMonthPremium() async {
    final thirtyDaysLater = DateTime.now().add(const Duration(days: 30));
    await _box.put(_isPremiumKey, true);
    await _box.put(_premiumExpiryKey, thirtyDaysLater.toIso8601String());
  }

  /// Revokes Premium status
  Future<void> revokePremium() async {
    await _box.put(_isPremiumKey, false);
    await _box.delete(_premiumExpiryKey);
  }
}
