import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import 'package:dio/dio.dart';

class TutorRepository {
  final Dio _dio;

  TutorRepository(this._dio);

  Stream<String> streamTutorMessage(String message, List<String> contextWords) async* {
    try {
      final response = await _dio.post('/api/ai/tutor', data: {
        'prompt': message,
        'contextWords': contextWords,
      });

      final String fullText = response.data['response'];
      final tokens = fullText.split(RegExp(r'(?<= )'));

      for (final token in tokens) {
        await Future.delayed(const Duration(milliseconds: 50)); 
        yield token;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 403 && e.response?.data['premiumRequired'] == true) {
        throw Exception('PREMIUM_REQUIRED');
      }
      throw Exception(e.response?.data['error'] ?? 'AI Error');
    }
  }
}

final tutorRepositoryProvider = Provider<TutorRepository>((ref) {
  return TutorRepository(ref.watch(dioProvider));
});
