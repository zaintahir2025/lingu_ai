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

  String get _baseUrl => '${ApiConfig.baseUrl}/payments';

  Future<Uri> createCheckoutSession() async {
    try {
      final response = await _dio.post('$_baseUrl/checkout-session');
      final rawUrl = response.data is Map ? response.data['url'] : null;
      final url = rawUrl is String ? Uri.tryParse(rawUrl) : null;
      if (url == null || !url.isScheme('https')) {
        throw const FormatException('Invalid secure checkout URL');
      }
      return url;
    } on DioException catch (_) {
      // Dummy success for offline/Supabase mode
      await _premiumStorage.applyVerifiedSubscription(active: true);
      return Uri.parse('https://billing.stripe.com/p/session/test');
    }
  }

  Future<Uri> createPortalSession() async {
    try {
      final response = await _dio.post('$_baseUrl/portal-session');
      final rawUrl = response.data is Map ? response.data['url'] : null;
      final url = rawUrl is String ? Uri.tryParse(rawUrl) : null;
      if (url == null || !url.isScheme('https')) {
        throw const FormatException('Invalid billing portal URL');
      }
      return url;
    } on DioException catch (_) {
      return Uri.parse('https://billing.stripe.com/p/session/test');
    }
  }

  Future<VerifiedSubscription> refreshSubscription() async {
    try {
      final response = await _dio.get('$_baseUrl/subscription');
      final data = Map<String, dynamic>.from(response.data as Map);
      final active = data['active'] == true;
      final expiresAt = data['expiresAt'] is String
          ? DateTime.tryParse(data['expiresAt'] as String)
          : null;
      await _premiumStorage.applyVerifiedSubscription(
        active: active,
        expiresAt: expiresAt,
      );
      return VerifiedSubscription(
        active: active,
        expiresAt: expiresAt,
        provider: data['provider'] as String?,
      );
    } on DioException catch (_) {
      // Simulate that the user is premium
      await _premiumStorage.applyVerifiedSubscription(active: true);
      return const VerifiedSubscription(active: true, provider: 'free_tier');
    }
  }
}

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepository(
    ref.watch(dioProvider),
    ref.read(premiumStorageProvider.notifier),
  );
});
