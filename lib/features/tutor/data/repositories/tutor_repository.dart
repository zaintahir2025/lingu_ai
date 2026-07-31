import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../presentation/screens/ai_settings_screen.dart';

class TutorRepository {
  final AiSettingsStorage _aiSettingsStorage;
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
  ));

  TutorRepository(this._aiSettingsStorage);

  Future<bool> validateGeminiApiKey(String apiKey) async {
    final key = apiKey.trim();
    if (key.isEmpty) return false;
    try {
      final response = await _dio.post(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$key',
        options: Options(headers: {'Content-Type': 'application/json'}),
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
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Gemini key validation failed: $e');
      return false;
    }
  }

  Stream<String> streamTutorMessage(
    String message,
    List<String> contextWords,
  ) async* {
    final customKey = _aiSettingsStorage.customKey.trim();

    // If Gemini API key is provided, attempt online Google Gemini call
    if (customKey.isNotEmpty) {
      bool hasEmitted = false;
      try {
        await for (final chunk in _callGeminiApi(customKey, message, contextWords)) {
          hasEmitted = true;
          yield chunk;
        }
        if (hasEmitted) return;
      } catch (e) {
        debugPrint('Gemini API Call failed ($e). Displaying API Key guidance to user.');
        yield '⚠️ Gemini API Key Error: The custom API key provided was rejected by Google AI Studio ($e).\n\nPlease verify your API key in settings (Key icon 🔑). Valid Google AI Studio Gemini API keys start with "AIzaSy...". Get a free key at https://aistudio.google.com';
        return;
      }
    }

    // Built-in Smart AI Engine (Works 100% offline when API key is blank)
    yield* _smartOfflineTutor(message, contextWords);
  }

  Stream<String> _callGeminiApi(
    String apiKey,
    String message,
    List<String> contextWords,
  ) async* {
    final prompt = '''
You are LinguAI Tutor, a friendly, encouraging, and highly intelligent AI language learning tutor.
Recent learned words context: ${contextWords.join(', ')}

User message: $message

Respond helpfully as AI Language Tutor. Keep your response concise, clear, natural, and beginner friendly.
''';

    // 1. Primary Attempt: google_generative_ai SDK
    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
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
      debugPrint('Google Generative AI SDK error: $sdkError. Trying direct REST API fallback...');
    }

    // 2. Fallback Attempt: Direct REST API via Dio
    final url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey';
    final response = await _dio.post(
      url,
      options: Options(headers: {'Content-Type': 'application/json'}),
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

    throw Exception('API response error code ${response.statusCode}');
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
      reply = 'Grammar Tip: In Spanish, adjectives usually come AFTER the noun (e.g. "casa grande" = big house). Also, subject pronouns like "yo" or "tú" can often be omitted because the verb ending already shows who is speaking!';
    } else if (msg.contains('word') || msg.contains('vocab') || msg.contains('meaning')) {
      final contextStr = contextWords.isNotEmpty ? ' Your recent words: ${contextWords.take(5).join(", ")}.' : '';
      reply = 'Great choice! Expanding your vocabulary is key to fluency.$contextStr Remember to use spaced repetition flashcards daily to retain new words in your long-term memory!';
    } else if (msg.contains('why') || msg.contains('wrong') || msg.contains('mistake')) {
      reply = 'Tutor Explains: Making mistakes is how your brain builds new language connections! Check your flashcards or re-read the example sentence to understand the correct word order or verb conjugation.';
    } else if (msg.contains('help') || msg.contains('how')) {
      reply = 'I am here as your personal AI language companion! You can ask me:\n• "How do I say [phrase] in Spanish?"\n• "Explain the difference between ser and estar"\n• "Give me a practice sentence"';
    } else {
      reply = '¡Excelente! You said: "$message". Keep practicing everyday—consistency is the secret to moving from beginner to fluent!';
    }

    // Simulate natural typing stream
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


