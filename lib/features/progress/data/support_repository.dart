import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_client.dart';
import '../../../core/supabase/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

abstract class SupportRepository {
  Future<void> createTicket({
    required String category,
    required String subject,
    required String message,
  });
}

class SupabaseSupportRepository implements SupportRepository {
  final supabase = supa.Supabase.instance.client;

  @override
  Future<void> createTicket({
    required String category,
    required String subject,
    required String message,
  }) async {
    final session = supabase.auth.currentSession;
    if (session == null) throw Exception('Not logged in');

    await supabase.from('support_tickets').insert({
      'user_id': session.user.id,
      'user_email': session.user.email,
      'category': category,
      'subject': subject,
      'message': message,
      'priority': 'standard',
      'status': 'open',
    });
  }
}

class DioSupportRepository implements SupportRepository {
  DioSupportRepository(this._dio);

  final Dio _dio;

  @override
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
  if (SupabaseConfig.isConfigured) {
    return SupabaseSupportRepository();
  }
  return DioSupportRepository(ref.watch(dioProvider));
});
