import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';

class TutorRepository {
  final Dio _dio;

  TutorRepository(this._dio);

  /// Real implementation for SSE (Server-Sent Events) stream.
  Stream<String> streamTutorMessage(String message, List<String> contextWords) async* {
    try {
      final response = await _dio.post<ResponseBody>(
        '/tutor/chat',
        data: {'message': message, 'context': contextWords},
        options: Options(
          responseType: ResponseType.stream,
          receiveTimeout: const Duration(minutes: 5),
        ),
      );

      final stream = response.data!.stream
          .map((bytes) => utf8.decode(bytes))
          .transform(const LineSplitter());

      await for (final line in stream) {
        if (line.startsWith('data: ')) {
          final data = line.substring(6);
          if (data == '[DONE]') return;
          
          // Assuming the data payload is a JSON object like {"token": "hello"}
          try {
            final json = jsonDecode(data);
            if (json['token'] != null) {
              yield json['token'] as String;
            }
          } catch (_) {
            // If it's just raw text tokens
            yield data;
          }
        }
      }
    } catch (e) {
      throw Exception('Failed to stream tutor message: $e');
    }
  }

  /// Mock implementation for testing the UI token-by-token streaming
  Stream<String> mockStreamTutorMessage(String message, List<String> contextWords) async* {
    // Determine a dynamic response based on context
    String responseText = "I see you've been struggling with ${contextWords.isNotEmpty ? contextWords.join(', ') : 'some words'}. Let's break them down and practice together!";
    
    if (message.toLowerCase().contains('hello')) {
      responseText = "Hi there! I am your AI language tutor. Let's practice some vocabulary. I noticed you had trouble with ${contextWords.join(', ')}.";
    }

    final tokens = responseText.split(RegExp(r'(?<= )')); // split by space but keep spaces

    for (final token in tokens) {
      await Future.delayed(const Duration(milliseconds: 100)); // Simulate network latency per token
      yield token;
    }
  }
}

final tutorRepositoryProvider = Provider<TutorRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return TutorRepository(dio);
});
