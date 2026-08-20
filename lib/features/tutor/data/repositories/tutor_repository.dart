import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../presentation/screens/ai_settings_screen.dart';
import '../../../../core/providers/target_language_provider.dart';
import '../../../../core/network/dio_client.dart';

class KeyValidationResult {
  final bool isValid;
  final String? errorMessage;

  const KeyValidationResult({
    required this.isValid,
    this.errorMessage,
  });
}

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
    'gemini-1.5-flash',
    'gemini-2.0-flash',
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

  Future<KeyValidationResult> validateApiKey(String apiKey) async {
    final key = sanitizeApiKey(apiKey);
    if (key.isEmpty) {
      return const KeyValidationResult(
        isValid: false,
        errorMessage: 'Key is empty.',
      );
    }

    // Google Gemini Validation across active models
    for (final modelName in _geminiModels) {
      // 1. Official Google Generative AI SDK
      try {
        final model = GenerativeModel(model: modelName, apiKey: key);
        final res = await model.generateContent([Content.text('Hi')]);
        if (res.text != null && res.text!.isNotEmpty) {
          return const KeyValidationResult(isValid: true);
        }
      } catch (_) {}

      // 2. Standard REST API Key Query & Header
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
        if (response.statusCode == 200 && response.data != null) {
          return const KeyValidationResult(isValid: true);
        }
      } catch (_) {}

      // 3. GCP Bearer Token Header (for GCP/OAuth tokens)
      try {
        final response = await _dio.post(
          'https://generativelanguage.googleapis.com/v1beta/models/$modelName:generateContent',
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $key',
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
        if (response.statusCode == 200 && response.data != null) {
          return const KeyValidationResult(isValid: true);
        }
      } catch (_) {}
    }

    return const KeyValidationResult(
      isValid: false,
      errorMessage:
          'Google Gemini rejected this key. Please make sure you copied the full key from https://aistudio.google.com.',
    );
  }

  Stream<String> streamTutorMessage(
    String message,
    List<String> contextWords, {
    String? targetLang,
  }) async* {
    final customKey = sanitizeApiKey(await _aiSettingsStorage.getApiKey());

    if (customKey.isNotEmpty) {
      bool hasEmitted = false;
      try {
        await for (final chunk in _callGeminiApi(
          customKey,
          message,
          contextWords,
          targetLang: targetLang,
        )) {
          hasEmitted = true;
          yield chunk;
        }
        if (hasEmitted) return;
      } catch (e) {
        debugPrint('Gemini API call failed: $e');
        yield '⚠️ Google Gemini API Error: The AI service rejected your API key.\n\nPlease check your key in settings (🔑 icon) at https://aistudio.google.com.';
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
          : 'The built-in AI Tutor is unavailable. Add your Gemini key in settings or try again later.';
      throw Exception(errorMessage);
    }
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
          'Google Generative AI SDK model $modelName failed. Trying REST fallbacks...',
        );
      }
    }

    for (final modelName in _geminiModels) {
      // REST Standard Mode
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
      } catch (_) {}

      // REST Bearer Mode
      try {
        final url =
            'https://generativelanguage.googleapis.com/v1beta/models/$modelName:generateContent';
        final response = await _dio.post(
          url,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $apiKey',
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
      } catch (_) {}
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
