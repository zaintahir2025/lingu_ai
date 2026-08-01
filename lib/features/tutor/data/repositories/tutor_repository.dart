import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../presentation/screens/ai_settings_screen.dart';
import '../../../../core/providers/target_language_provider.dart';

class TutorRepository {
  final AiSettingsStorage _aiSettingsStorage;
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
  ));

  TutorRepository(this._aiSettingsStorage);

  static const List<String> _geminiModels = [
    'gemini-1.5-flash',
    'gemini-1.5-pro',
    'gemini-2.0-flash-exp',
    'gemini-1.5-flash-latest',
    'gemini-pro',
  ];

  /// Sanitizes Google AI Studio API Key string
  String sanitizeApiKey(String key) {
    return key.trim().replaceAll('"', '').replaceAll("'", '').replaceAll('\n', '').replaceAll('\r', '');
  }

  Future<bool> validateGeminiApiKey(String apiKey) async {
    final key = sanitizeApiKey(apiKey);
    if (key.isEmpty) return false;

    // Direct endpoint check for Google AI Studio keys
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
          options: Options(headers: {
            'Content-Type': 'application/json',
            'x-goog-api-key': key,
          }),
          data: {
            'contents': [
              {
                'parts': [
                  {'text': 'Hi'}
                ]
              }
            ]
          },
        );
        if (response.statusCode == 200) return true;
      } catch (e) {
        debugPrint('Model $modelName validation failed ($e). Trying next model...');
      }
    }
    return false;
  }

  Stream<String> streamTutorMessage(
    String message,
    List<String> contextWords, {
    String? targetLang,
  }) async* {
    final customKey = sanitizeApiKey(_aiSettingsStorage.customKey);

    // If Gemini API key is provided, attempt online Google Gemini call
    if (customKey.isNotEmpty) {
      bool hasEmitted = false;
      try {
        await for (final chunk in _callGeminiApi(customKey, message, contextWords, targetLang: targetLang)) {
          hasEmitted = true;
          yield chunk;
        }
        if (hasEmitted) return;
      } catch (e) {
        debugPrint('Gemini API Call failed ($e). Displaying API Key guidance to user.');
        yield '⚠️ Gemini API Key Error: Google AI Studio rejected the custom key or model endpoint.\n\nPlease verify your API key in settings (Key icon 🔑). Valid Google AI Studio keys start with "AIzaSy...". Get a free key at https://aistudio.google.com';
        return;
      }
    }

    // Built-in Smart AI Engine (Works 100% offline when API key is blank)
    yield* _smartOfflineTutor(message, contextWords);
  }

  Stream<String> _callGeminiApi(
    String apiKey,
    String message,
    List<String> contextWords, {
    String? targetLang,
  }) async* {
    final langName = targetLang != null ? TargetLanguages.getName(targetLang) : 'Spanish 🇪🇸';
    final prompt = '''
You are LinguAI Tutor, a friendly, encouraging, and highly intelligent AI language learning tutor for $langName.
Target Language being taught: $langName ($targetLang).
Recent learned words context: ${contextWords.join(', ')}

User message: $message

Respond helpfully as AI Language Tutor for $langName. Keep your response concise, clear, natural, and beginner friendly. Use $langName examples where appropriate.
''';

    // 1. Primary Attempt: google_generative_ai SDK
    for (final modelName in _geminiModels) {
      try {
        final model = GenerativeModel(
          model: modelName,
          apiKey: apiKey,
        );

        final responseStream = model.generateContentStream([Content.text(prompt)]);
        await for (final chunk in responseStream) {
          if (chunk.text != null && chunk.text!.isNotEmpty) {
            yield chunk.text!;
          }
        }
        return;
      } catch (sdkError) {
        debugPrint('Google Generative AI SDK model $modelName failed. Trying REST fallback...');
      }
    }

    // 2. Fallback Attempt: Direct REST API via Dio with model rotation
    for (final modelName in _geminiModels) {
      try {
        final url = 'https://generativelanguage.googleapis.com/v1beta/models/$modelName:generateContent?key=$apiKey';
        final response = await _dio.post(
          url,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'x-goog-api-key': apiKey,
          }),
          data: {
            'contents': [
              {
                'parts': [
                  {'text': prompt}
                ]
              }
            ]
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

  /// Built-in Smart Tutor Engine that responds instantly without requiring API keys.
  Stream<String> _smartOfflineTutor(
    String message,
    List<String> contextWords,
  ) async* {
    await Future.delayed(const Duration(milliseconds: 300));

    final msg = message.toLowerCase().trim();
    String reply;

    if (msg.contains('hello') || msg.contains('hola') || msg.contains('hi')) {
      reply = '¡Hola! I am your AI Language Tutor. I am excited to help you learn! What topic or word would you like to practice today?';
    } else if (msg.contains('grammar') || msg.contains('rule')) {
      reply = 'Grammar Tip: In Spanish/French, adjectives often describe the noun closely. Practice daily flashcards to master conjugations!';
    } else if (msg.contains('word') || msg.contains('vocab') || msg.contains('meaning')) {
      final contextStr = contextWords.isNotEmpty ? ' Your recent words: ${contextWords.take(5).join(", ")}.' : '';
      reply = 'Great choice! Expanding your vocabulary is key to fluency.$contextStr Remember to use spaced repetition flashcards daily to retain new words in your long-term memory!';
    } else if (msg.contains('why') || msg.contains('wrong') || msg.contains('mistake')) {
      reply = 'Tutor Explains: Making mistakes is how your brain builds new language connections! Check your flashcards or re-read the example sentence to understand the correct word order.';
    } else if (msg.contains('help') || msg.contains('how')) {
      reply = 'I am here as your personal AI language companion! You can ask me:\n• "How do I say [phrase] in target language?"\n• "Explain grammar rules"\n• "Give me a practice sentence"';
    } else {
      reply = '¡Excelente! You said: "$message". Keep practicing everyday—consistency is the secret to moving from beginner to fluent!';
    }

    final words = reply.split(' ');
    for (int i = 0; i < words.length; i++) {
      yield '${words[i]}${i == words.length - 1 ? "" : " "}';
      await Future.delayed(const Duration(milliseconds: 30));
    }
  }
}

final tutorRepositoryProvider = Provider<TutorRepository>((ref) {
  return TutorRepository(
    ref.watch(aiSettingsStorageProvider),
  );
});
