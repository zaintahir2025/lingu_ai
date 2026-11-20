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

  // Never trust a Hive flag at startup. Entitlement must be refreshed from
  // the authenticated server after a session has been restored.
  PremiumStorageNotifier(this._box) : super(false);

  DateTime? get expiryDate {
    final expiryIso = _box.get(_premiumExpiryKey) as String?;
    return expiryIso == null ? null : DateTime.tryParse(expiryIso);
  }

  @Deprecated('Premium entitlement must be granted by a verified server response.')
  Future<void> setPremium(bool active) async {
    if (active) {
      throw StateError(
        'Premium access can only be granted by server-side subscription verification.',
      );
    }
    await applyVerifiedSubscription(active: false);
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

  /// Local cached entitlement is deliberately not restored as trusted state.
  void refresh() {
    state = false;
  }
}
