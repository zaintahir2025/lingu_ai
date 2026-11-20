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
    // Local cache is display-only. Server verification refreshes entitlement.
    refresh();
  }

  bool get isPremium {
    final flag = _box.get(_isPremiumKey, defaultValue: false) as bool? ?? false;
    if (!flag) return false;

    final expiryIso = _box.get(_premiumExpiryKey) as String?;
    final expiryDate = expiryIso == null ? null : DateTime.tryParse(expiryIso);
    if (expiryDate == null || !expiryDate.isAfter(DateTime.now())) {
      _box.put(_isPremiumKey, false);
      _box.delete(_premiumExpiryKey);
      return false;
    }
    return true;
  }

  /// Test/admin utility only. Production entitlement must come from the server.
  @Deprecated('Use applyVerifiedSubscription with a server-verified response.')
  Future<void> setPremium(bool active) async {
    if (!active) {
      await applyVerifiedSubscription(active: false);
      return;
    }
    throw StateError('Premium access can only be granted by server verification.');
  }

  DateTime? get expiryDate {
    final expiryIso = _box.get(_premiumExpiryKey) as String?;
    return expiryIso == null ? null : DateTime.tryParse(expiryIso);
  }

  Future<void> applyVerifiedSubscription({
    required bool active,
    DateTime? expiresAt,
  }) async {
    final valid = active &&
        expiresAt != null &&
        expiresAt.isAfter(DateTime.now());
    await _box.put(_isPremiumKey, valid);
    if (valid) {
      await _box.put(_premiumExpiryKey, expiresAt.toIso8601String());
    } else {
      await _box.delete(_premiumExpiryKey);
    }
    state = valid;
  }

  void refresh() {
    state = isPremium;
  }
}
