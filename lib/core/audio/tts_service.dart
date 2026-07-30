import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../storage/onboarding_storage.dart';

final ttsServiceProvider = Provider<TtsService>((ref) {
  final onboardingStorage = ref.watch(onboardingStorageProvider);
  final targetLang = onboardingStorage.targetLanguage ?? 'es';
  final service = TtsService();
  service.initLanguage(targetLang);
  return service;
});

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;

  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;
  String _currentLanguage = 'es-ES';
  double _speechRate = 0.45; // Tuned for clear, fluent language learning speech

  bool get isInitialized => _isInitialized;
  void setSpeechRate(double rate) => _speechRate = rate;

  TtsService._internal() {
    _initTts();
  }

  Future<void> _initTts() async {
    try {
      await _flutterTts.setSpeechRate(_speechRate);
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setVolume(1.0);

      // Platform specific audio session setup
      if (!kIsWeb) {
        await _flutterTts.awaitSpeakCompletion(true);
      }
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing TtsService: $e');
    }
  }

  /// Maps short language codes (e.g. 'es', 'fr', 'ja') to proper BCP-47 language tags.
  static String getBcp47LanguageTag(String langCode) {
    final code = langCode.toLowerCase().trim();
    switch (code) {
      case 'es':
      case 'spanish':
        return 'es-ES';
      case 'fr':
      case 'french':
        return 'fr-FR';
      case 'ja':
      case 'japanese':
        return 'ja-JP';
      case 'it':
      case 'italian':
        return 'it-IT';
      case 'de':
      case 'german':
        return 'de-DE';
      case 'en':
      case 'english':
        return 'en-US';
      case 'zh':
      case 'chinese':
        return 'zh-CN';
      case 'ar':
      case 'arabic':
        return 'ar-SA';
      case 'ko':
      case 'korean':
        return 'ko-KR';
      case 'pt':
      case 'portuguese':
        return 'pt-PT';
      case 'ru':
      case 'russian':
        return 'ru-RU';
      case 'ur':
      case 'urdu':
        return 'ur-PK';
      case 'hi':
      case 'hindi':
        return 'hi-IN';
      default:
        if (code.contains('-')) return code;
        return 'es-ES';
    }
  }

  /// Configures default language for the session
  Future<void> initLanguage(String langCode) async {
    _currentLanguage = getBcp47LanguageTag(langCode);
    try {
      await _flutterTts.setLanguage(_currentLanguage);
    } catch (e) {
      debugPrint('Error setting TTS language $_currentLanguage: $e');
    }
  }

  /// Sanitizes text for TTS so formatting symbols (like **, *, _, "Audio: ")
  /// are stripped and the text is spoken fluently according to language grammar.
  String cleanTextForSpeech(String text) {
    String cleaned = text;

    // Remove "Audio: " or "Audio:" prompt prefixes
    cleaned = cleaned.replaceAll(RegExp(r'^Audio:\s*"?', caseSensitive: false), '');
    cleaned = cleaned.replaceAll(RegExp(r'"$'), '');

    // Strip markdown formatting (*, **, _, `, #, ~)
    cleaned = cleaned.replaceAll(RegExp(r'\*+|\_+|\`+|~+'), '');

    // Strip code blocks or brackets
    cleaned = cleaned.replaceAll(RegExp(r'\[.*?\]|\(.*?\)', caseSensitive: false), '');

    return cleaned.trim();
  }

  /// Speaks the given [text] fluently using the configured TTS voiceover engine.
  Future<void> speak(String text, {String? targetLanguage, double? rate}) async {
    if (text.trim().isEmpty) return;

    final sanitized = cleanTextForSpeech(text);
    if (sanitized.isEmpty) return;

    try {
      final langTag = targetLanguage != null
          ? getBcp47LanguageTag(targetLanguage)
          : _currentLanguage;

      await _flutterTts.setLanguage(langTag);
      await _flutterTts.setSpeechRate(rate ?? _speechRate);
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setVolume(1.0);

      await _flutterTts.stop();
      await _flutterTts.speak(sanitized);
    } catch (e) {
      debugPrint('Error in TtsService speak: $e');
    }
  }

  /// Stops current speech output.
  Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (e) {
      debugPrint('Error stopping TTS: $e');
    }
  }
}
