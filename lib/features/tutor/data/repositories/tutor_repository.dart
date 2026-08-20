import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../presentation/screens/ai_settings_screen.dart';
import '../../../../core/providers/target_language_provider.dart';
import '../../../../core/network/dio_client.dart';

class TutorRepository {
  final AiSettingsStorage _aiSettingsStorage;
  final Dio _backendDio;
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  TutorRepository(this._aiSettingsStorage, this._backendDio);

  static const List<String> _geminiModels = [
    'gemini-2.5-flash',
    'gemini-2.0-flash',
    'gemini-1.5-flash',
    'gemini-1.5-pro',
    'gemini-1.5-flash-latest',
  ];

  String sanitizeApiKey(String key) {
    return key
        .trim()
        .replaceAll('"', '')
        .replaceAll("'", '')
        .replaceAll('\n', '')
        .replaceAll('\r', '');
  }

  Future<bool> validateGeminiApiKey(String apiKey, {String? provider}) async {
    final key = sanitizeApiKey(apiKey);
    if (key.isEmpty) return false;

    final selectedProvider = provider ?? _aiSettingsStorage.provider;

    if (selectedProvider.contains('Groq')) {
      try {
        final res = await _dio.post(
          'https://api.groq.com/openai/v1/chat/completions',
          options: Options(
            headers: {
              'Authorization': 'Bearer $key',
              'Content-Type': 'application/json',
            },
          ),
          data: {
            'model': 'llama-3.3-70b-versatile',
            'messages': [
              {'role': 'user', 'content': 'hi'},
            ],
            'max_tokens': 5,
          },
        );
        return res.statusCode == 200;
      } catch (_) {
        return false;
      }
    } else {
      // Default: Google Gemini
      try {
        final response = await _dio.get(
          'https://generativelanguage.googleapis.com/v1beta/models?key=$key',
        );
        if (response.statusCode == 200) return true;
      } catch (_) {}

      for (final modelName in _geminiModels) {
        try {
          final response = await _dio.post(
            'https://generativelanguage.googleapis.com/v1beta/models/$modelName:generateContent?key=$key',
            options: Options(
              headers: {
                'Content-Type': 'application/json',
                'x-goog-api-key': key,
              },
            ),
            data: {
              'contents': [
                {
                  'parts': [
                    {'text': 'Hi'},
                  ],
                },
              ],
            },
          );
          if (response.statusCode == 200) return true;
        } catch (_) {}
      }
      return false;
    }
  }

  Stream<String> streamTutorMessage(
    String message,
    List<String> contextWords, {
    String? targetLang,
  }) async* {
    final customKey = sanitizeApiKey(await _aiSettingsStorage.getApiKey());
    final provider = _aiSettingsStorage.provider;

    if (customKey.isNotEmpty) {
      bool hasEmitted = false;
      try {
        if (provider.contains('Groq')) {
          await for (final chunk in _callOpenAiCompatibleApi(
            'https://api.groq.com/openai/v1/chat/completions',
            'llama-3.3-70b-versatile',
            customKey,
            message,
            contextWords,
            targetLang: targetLang,
          )) {
            hasEmitted = true;
            yield chunk;
          }
        } else {
          await for (final chunk in _callGeminiApi(
            customKey,
            message,
            contextWords,
            targetLang: targetLang,
          )) {
            hasEmitted = true;
            yield chunk;
          }
        }
        if (hasEmitted) return;
      } catch (e) {
        debugPrint('AI Provider ($provider) call failed: $e');
        yield '⚠️ $provider Key Error: The AI service rejected your API key or model request.\n\nPlease check your key in settings (🔑 icon).';
        return;
      }
    }

    try {
      final response = await _backendDio.post(
        '/ai/tutor',
        data: {
          'prompt': message,
          'contextWords': contextWords,
          'targetLanguage': targetLang,
        },
      );
      final text = response.data is Map ? response.data['response'] : null;
      if (text is! String || text.trim().isEmpty) {
        throw Exception('The AI service returned an empty response.');
      }
      yield text;
    } on DioException catch (error) {
      if (error.response?.statusCode == 403 &&
          error.response?.data is Map &&
          error.response?.data['premiumRequired'] == true) {
        throw Exception('PREMIUM_REQUIRED');
      }
      final data = error.response?.data;
      final errorMessage = data is Map && data['error'] is String
          ? data['error'] as String
          : 'The built-in AI Tutor is unavailable. Add your own key or try again later.';
      throw Exception(errorMessage);
    }
  }

  Stream<String> _callOpenAiCompatibleApi(
    String endpoint,
    String model,
    String apiKey,
    String message,
    List<String> contextWords, {
    String? targetLang,
  }) async* {
    final langName = targetLang != null
        ? TargetLanguages.getName(targetLang)
        : 'Spanish 🇪🇸';
    final systemPrompt =
        'You are LinguAI Tutor, a friendly, encouraging, and expert language learning tutor for $langName. Context learned words: ${contextWords.join(", ")}. Keep responses concise, clear, and beginner-friendly.';

    final response = await _dio.post(
      endpoint,
      options: Options(
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
      ),
      data: {
        'model': model,
        'messages': [
          {'role': 'system', 'content': systemPrompt},
          {'role': 'user', 'content': message},
        ],
        'temperature': 0.7,
      },
    );

    if (response.statusCode == 200 && response.data != null) {
      final choices = response.data['choices'] as List?;
      if (choices != null && choices.isNotEmpty) {
        final text = choices[0]['message']['content'] as String?;
        if (text != null) {
          yield text;
          return;
        }
      }
    }
    throw Exception('Failed to query $model API endpoint.');
  }

  Stream<String> _callGeminiApi(
    String apiKey,
    String message,
    List<String> contextWords, {
    String? targetLang,
  }) async* {
    final langName = targetLang != null
        ? TargetLanguages.getName(targetLang)
        : 'Spanish 🇪🇸';
    final prompt =
        '''
You are LinguAI Tutor, a friendly, encouraging, and highly intelligent AI language learning tutor for $langName.
Target Language being taught: $langName ($targetLang).
Recent learned words context: ${contextWords.join(', ')}

User message: $message

Respond helpfully as AI Language Tutor for $langName. Keep your response concise, clear, natural, and beginner friendly. Use $langName examples where appropriate.
''';

    for (final modelName in _geminiModels) {
      try {
        final model = GenerativeModel(model: modelName, apiKey: apiKey);

        final responseStream = model.generateContentStream([
          Content.text(prompt),
        ]);
        await for (final chunk in responseStream) {
          if (chunk.text != null && chunk.text!.isNotEmpty) {
            yield chunk.text!;
          }
        }
        return;
      } catch (sdkError) {
        debugPrint(
          'Google Generative AI SDK model $modelName failed. Trying REST fallback...',
        );
      }
    }

    for (final modelName in _geminiModels) {
      try {
        final url =
            'https://generativelanguage.googleapis.com/v1beta/models/$modelName:generateContent?key=$apiKey';
        final response = await _dio.post(
          url,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'x-goog-api-key': apiKey,
            },
          ),
          data: {
            'contents': [
              {
                'parts': [
                  {'text': prompt},
                ],
              },
            ],
          },
        );

        if (response.statusCode == 200 && response.data != null) {
          final candidates = response.data['candidates'] as List?;
          if (candidates != null && candidates.isNotEmpty) {
            final content = candidates[0]['content'];
            final parts = content['parts'] as List?;
            if (parts != null && parts.isNotEmpty) {
              final text = parts[0]['text'] as String?;
              if (text != null) {
                yield text;
                return;
              }
            }
          }
        }
      } catch (dioError) {
        debugPrint('Dio REST model $modelName failed: $dioError');
      }
    }

    throw Exception('All Gemini model endpoints failed for custom key.');
  }
}

final tutorRepositoryProvider = Provider<TutorRepository>((ref) {
  return TutorRepository(
    ref.watch(aiSettingsStorageProvider),
    ref.watch(dioProvider),
  );
});
