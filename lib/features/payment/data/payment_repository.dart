import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_config.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/storage/premium_storage.dart';

class VerifiedSubscription {
  final bool active;
  final DateTime? expiresAt;
  final String? provider;

  const VerifiedSubscription({
    required this.active,
    this.expiresAt,
    this.provider,
  });
}

class PaymentRepository {
  final Dio _dio;
  final PremiumStorageNotifier _premiumStorage;

  PaymentRepository(this._dio, this._premiumStorage);

  String get _baseUrl {
    final base = ApiConfig.baseUrl.replaceFirst(RegExp(r'/+
    final response = await _dio.post(path);
    final rawUrl = response.data is Map ? response.data['url'] : null;
    final url = rawUrl is String ? Uri.tryParse(rawUrl) : null;

    // Only accept HTTPS checkout URLs from the authenticated server.
    if (url == null ||
        url.scheme != 'https' ||
        url.host.isEmpty ||
        !(url.host == 'checkout.stripe.com' ||
            url.host.endsWith('.stripe.com'))) {
      throw const FormatException('The server returned an invalid checkout URL.');
    }
    return url;
  }

  Future<Uri> createCheckoutSession() =>
      _checkoutUrl('$_baseUrl/checkout-session');

  Future<Uri> createPortalSession() =>
      _checkoutUrl('$_baseUrl/portal-session');

  Future<VerifiedSubscription> refreshSubscription() async {
    try {
      final response = await _dio.get('$_baseUrl/subscription');
      if (response.data is! Map) {
        throw const FormatException('Invalid subscription response.');
      }
      final data = Map<String, dynamic>.from(response.data as Map);
      final expiresAt = data['expiresAt'] is String
          ? DateTime.tryParse(data['expiresAt'] as String)
          : null;

      // A subscription is active only when the server says so and supplies a
      // future expiry. Network/parse failures must never grant local premium.
      final active = data['active'] == true &&
          expiresAt != null &&
          expiresAt.isAfter(DateTime.now());

      await _premiumStorage.applyVerifiedSubscription(
        active: active,
        expiresAt: expiresAt,
      );
      return VerifiedSubscription(
        active: active,
        expiresAt: expiresAt,
        provider: data['provider'] as String?,
      );
    } catch (_) {
      await _premiumStorage.applyVerifiedSubscription(active: false);
      rethrow;
    }
  }
}

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepository(
    ref.watch(dioProvider),
    ref.read(premiumStorageProvider.notifier),
  );
});
), '');
    return '$base/payments';
  }

  Future<Uri> _checkoutUrl(String path) async {
    final response = await _dio.post(path);
    final rawUrl = response.data is Map ? response.data['url'] : null;
    final url = rawUrl is String ? Uri.tryParse(rawUrl) : null;

    // Only accept HTTPS checkout URLs from the authenticated server.
    if (url == null ||
        url.scheme != 'https' ||
        url.host.isEmpty ||
        !(url.host == 'checkout.stripe.com' ||
            url.host.endsWith('.stripe.com'))) {
      throw const FormatException('The server returned an invalid checkout URL.');
    }
    return url;
  }

  Future<Uri> createCheckoutSession() =>
      _checkoutUrl('/payments/checkout-session');

  Future<Uri> createPortalSession() =>
      _checkoutUrl('/payments/portal-session');

  Future<VerifiedSubscription> refreshSubscription() async {
    try {
      final response = await _dio.get('/payments/subscription');
      if (response.data is! Map) {
        throw const FormatException('Invalid subscription response.');
      }
      final data = Map<String, dynamic>.from(response.data as Map);
      final expiresAt = data['expiresAt'] is String
          ? DateTime.tryParse(data['expiresAt'] as String)
          : null;

      // A subscription is active only when the server says so and supplies a
      // future expiry. Network/parse failures must never grant local premium.
      final active = data['active'] == true &&
          expiresAt != null &&
          expiresAt.isAfter(DateTime.now());

      await _premiumStorage.applyVerifiedSubscription(
        active: active,
        expiresAt: expiresAt,
      );
      return VerifiedSubscription(
        active: active,
        expiresAt: expiresAt,
        provider: data['provider'] as String?,
      );
    } catch (_) {
      await _premiumStorage.applyVerifiedSubscription(active: false);
      rethrow;
    }
  }
}

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepository(
    ref.watch(dioProvider),
    ref.read(premiumStorageProvider.notifier),
  );
});
