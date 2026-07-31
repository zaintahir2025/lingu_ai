import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../presentation/screens/ai_settings_screen.dart';
import '../../domain/models/character_model.dart';

class TutorRepository {
  final AiSettingsStorage _aiSettingsStorage;
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
  ));

  TutorRepository(this._aiSettingsStorage);

  Stream<String> streamTutorMessage(
    String message,
    List<String> contextWords, {
    CharacterModel? character,
  }) async* {
    final activeChar = character ?? CharacterModel.allCharacters.first;
    final customKey = _aiSettingsStorage.customKey.trim();
    final provider = _aiSettingsStorage.provider;

    // If key is provided, attempt online multi-provider API call
    if (customKey.isNotEmpty) {
      try {
        if (provider.contains('Groq')) {
          yield* _callGroqApi(customKey, message, contextWords, activeChar);
          return;
        } else if (provider.contains('OpenAI')) {
          yield* _callOpenAiApi(customKey, message, contextWords, activeChar);
          return;
        } else if (provider.contains('Claude') || provider.contains('Anthropic')) {
          yield* _callClaudeApi(customKey, message, contextWords, activeChar);
          return;
        } else {
          // Default: Gemini
          yield* _callGeminiApi(customKey, message, contextWords, activeChar);
          return;
        }
      } catch (e) {
        debugPrint('Online AI API Call failed ($e). Falling back to built-in smart AI tutor engine.');
        // Fallthrough to built-in Smart AI engine below
      }
    }

    // Built-in Smart AI Engine (Works 100% offline & when API key is blank)
    yield* _smartOfflineTutor(message, contextWords, activeChar);
  }

  Stream<String> _callGeminiApi(
    String apiKey,
    String message,
    List<String> contextWords,
    CharacterModel character,
  ) async* {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );

    final prompt = '''
${character.systemPrompt}
Recent learned words context: ${contextWords.join(', ')}

User message: $message

Respond helpfully as ${character.name}. Keep response concise and beginner friendly.
''';

    final responseStream = model.generateContentStream([Content.text(prompt)]);
    await for (final chunk in responseStream) {
      if (chunk.text != null) {
        yield chunk.text!;
      }
    }
  }

  Stream<String> _callGroqApi(
    String apiKey,
    String message,
    List<String> contextWords,
    CharacterModel character,
  ) async* {
    final response = await _dio.post(
      'https://api.groq.com/openai/v1/chat/completions',
      options: Options(headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      }),
      data: {
        'model': 'llama-3.3-70b-versatile',
        'messages': [
          {'role': 'system', 'content': '${character.systemPrompt}\nContext words: ${contextWords.join(', ')}'},
          {'role': 'user', 'content': message},
        ],
        'temperature': 0.7,
      },
    );

    if (response.statusCode == 200 && response.data != null) {
      final content = response.data['choices'][0]['message']['content'] as String;
      yield content;
    } else {
      throw Exception('Groq API Error: ${response.statusCode}');
    }
  }

  Stream<String> _callOpenAiApi(
    String apiKey,
    String message,
    List<String> contextWords,
    CharacterModel character,
  ) async* {
    final response = await _dio.post(
      'https://api.openai.com/v1/chat/completions',
      options: Options(headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      }),
      data: {
        'model': 'gpt-4o-mini',
        'messages': [
          {'role': 'system', 'content': '${character.systemPrompt}\nContext words: ${contextWords.join(', ')}'},
          {'role': 'user', 'content': message},
        ],
        'temperature': 0.7,
      },
    );

    if (response.statusCode == 200 && response.data != null) {
      final content = response.data['choices'][0]['message']['content'] as String;
      yield content;
    } else {
      throw Exception('OpenAI API Error: ${response.statusCode}');
    }
  }

  Stream<String> _callClaudeApi(
    String apiKey,
    String message,
    List<String> contextWords,
    CharacterModel character,
  ) async* {
    final response = await _dio.post(
      'https://api.anthropic.com/v1/messages',
      options: Options(headers: {
        'x-api-key': apiKey,
        'anthropic-version': '2023-06-01',
        'Content-Type': 'application/json',
      }),
      data: {
        'model': 'claude-3-5-sonnet-20241022',
        'max_tokens': 1000,
        'system': '${character.systemPrompt}\nContext words: ${contextWords.join(', ')}',
        'messages': [
          {'role': 'user', 'content': message},
        ],
      },
    );

    if (response.statusCode == 200 && response.data != null) {
      final content = response.data['content'][0]['text'] as String;
      yield content;
    } else {
      throw Exception('Claude API Error: ${response.statusCode}');
    }
  }

  /// Built-in Smart Tutor Engine that responds instantly without requiring API keys.
  Stream<String> _smartOfflineTutor(
    String message,
    List<String> contextWords,
    CharacterModel character,
  ) async* {
    await Future.delayed(const Duration(milliseconds: 300));

    final msg = message.toLowerCase().trim();

    String reply;

    if (msg.contains('hello') || msg.contains('hola') || msg.contains('hi')) {
      reply = '¡Hola! I am ${character.name}. I am excited to help you learn! What topic or word would you like to practice today?';
    } else if (msg.contains('grammar') || msg.contains('rule')) {
      reply = '${character.name} Grammar Tip: In Spanish, adjectives usually come AFTER the noun (e.g. "casa grande" = big house). Also, subject pronouns like "yo" or "tú" can often be omitted because the verb ending already shows who is speaking!';
    } else if (msg.contains('word') || msg.contains('vocab') || msg.contains('meaning')) {
      final contextStr = contextWords.isNotEmpty ? ' Your recent words: ${contextWords.take(5).join(", ")}.' : '';
      reply = 'Great choice! Expanding your vocabulary is key to fluency.$contextStr Remember to use spaced repetition flashcards daily to retain new words in your long-term memory!';
    } else if (msg.contains('why') || msg.contains('wrong') || msg.contains('mistake')) {
      reply = '${character.name} Explains: Making mistakes is how your brain builds new language connections! Check your flashcards or re-read the example sentence to understand the correct word order or verb conjugation.';
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
