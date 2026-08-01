import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../local_storage/local_storage_provider.dart';

final premiumStorageProvider = StateNotifierProvider<PremiumStorageNotifier, bool>((ref) {
  final box = ref.watch(localStorageProvider);
  return PremiumStorageNotifier(box);
});

class PremiumStorageNotifier extends StateNotifier<bool> {
  final Box _box;
  static const String _isPremiumKey = 'is_premium_member';
  static const String _premiumExpiryKey = 'premium_expiry_date';

  PremiumStorageNotifier(this._box) : super(true) {
    // Ensure default test account gets active 1-Month Premium
    final hasSet = _box.containsKey(_isPremiumKey);
    if (!hasSet) {
      grantOneMonthPremium();
    } else {
      state = isPremium;
    }
  }

  /// Returns true if the user is a Premium Member AND their subscription has not expired.
  bool get isPremium {
    final flag = (_box.get(_isPremiumKey, defaultValue: true) as bool?) ?? true;
    if (!flag) return false;

    final expiryIso = _box.get(_premiumExpiryKey) as String?;
    if (expiryIso != null) {
      final expiryDate = DateTime.tryParse(expiryIso);
      if (expiryDate != null && DateTime.now().isAfter(expiryDate)) {
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
    // Default 30 days from now if not explicitly set
    return DateTime.now().add(const Duration(days: 30));
  }

  /// Grants 1-Month (30-day) Premium status to the member
  Future<void> grantOneMonthPremium() async {
    final thirtyDaysLater = DateTime.now().add(const Duration(days: 30));
    await _box.put(_isPremiumKey, true);
    await _box.put(_premiumExpiryKey, thirtyDaysLater.toIso8601String());
    state = true;
  }

  /// Revokes Premium status
  Future<void> revokePremium() async {
    await _box.put(_isPremiumKey, false);
    await _box.delete(_premiumExpiryKey);
    state = false;
  }

  /// Refreshes state from Hive
  void refresh() {
    state = isPremium;
  }
}
