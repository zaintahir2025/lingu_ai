import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_client.dart';

class SupportRepository {
  SupportRepository(this._dio);

  final Dio _dio;

  Future<void> createTicket({
    required String category,
    required String subject,
    required String message,
  }) async {
    try {
      await _dio.post(
        '/support',
        data: {'category': category, 'subject': subject, 'message': message},
      );
    } on DioException catch (exception) {
      final data = exception.response?.data;
      final message = data is Map && data['error'] is String
          ? data['error'] as String
          : 'Support is unavailable right now. Please try again later.';
      throw Exception(message);
    }
  }
}

final supportRepositoryProvider = Provider<SupportRepository>((ref) {
  return SupportRepository(ref.watch(dioProvider));
});
