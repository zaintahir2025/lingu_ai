import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../local_storage/local_storage_provider.dart';

final premiumStorageProvider =
    StateNotifierProvider<PremiumStorageNotifier, bool>((ref) {
      final box = ref.watch(localStorageProvider);
      return PremiumStorageNotifier(box);
    });

class PremiumStorageNotifier extends StateNotifier<bool> {
  final Box _box;
  static const String _isPremiumKey = 'verified_premium_member_v2';
  static const String _premiumExpiryKey = 'verified_premium_expiry_date_v2';

  PremiumStorageNotifier(this._box) : super(false) {
    state = isPremium;
  }

  /// Returns true if the user is a Premium Member AND their subscription has not expired.
  bool get isPremium {
    final flag =
        (_box.get(_isPremiumKey, defaultValue: false) as bool?) ?? false;
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
    return null;
  }

  /// Applies subscription state that has already been verified by the backend.
  Future<void> applyVerifiedSubscription({
    required bool active,
    DateTime? expiresAt,
  }) async {
    final valid =
        active && expiresAt != null && expiresAt.isAfter(DateTime.now());
    await _box.put(_isPremiumKey, valid);
    if (valid) {
      await _box.put(_premiumExpiryKey, expiresAt.toIso8601String());
    } else {
      await _box.delete(_premiumExpiryKey);
    }
    state = valid;
  }

  /// Refreshes state from Hive
  void refresh() {
    state = isPremium;
  }
}
