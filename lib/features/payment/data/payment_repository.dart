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

  String _error(DioException exception) {
    final data = exception.response?.data;
    if (data is Map && data['error'] is String) return data['error'] as String;
    return 'The billing service is unavailable. Please try again later.';
  }

  Future<Uri> createCheckoutSession() async {
    try {
      final response = await _dio.post('$_baseUrl/checkout-session');
      final rawUrl = response.data is Map ? response.data['url'] : null;
      final url = rawUrl is String ? Uri.tryParse(rawUrl) : null;
      if (url == null || !url.isScheme('https')) {
        throw const FormatException('Invalid secure checkout URL');
      }
      return url;
    } on DioException catch (exception) {
      throw Exception(_error(exception));
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
    } on DioException catch (exception) {
      throw Exception(_error(exception));
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
    } on DioException catch (exception) {
      throw Exception(_error(exception));
    }
  }
}

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepository(
    ref.watch(dioProvider),
    ref.read(premiumStorageProvider.notifier),
  );
});
