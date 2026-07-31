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
  String _activeLanguageTag = '';
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

      // Disable awaitSpeakCompletion to prevent UI main thread lag/freezing
      await _flutterTts.awaitSpeakCompletion(false);

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

  /// Configures default target language for the learning session
  Future<void> initLanguage(String langCode) async {
    _currentLanguage = getBcp47LanguageTag(langCode);
  }

  /// Sanitizes text for TTS so formatting symbols (like **, *, _, "Audio: ")
  /// are stripped and the text is spoken fluently.
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

  /// Returns true if [text] is predominantly English text
  bool isEnglishText(String text) {
    if (text.isEmpty) return false;
    final clean = cleanTextForSpeech(text);
    // If it contains non-Latin scripts (Japanese/Urdu/Arabic/Hindi/Chinese), it's not English
    final nonLatinRegex = RegExp(r'[\u3040-\u30ff\u3400-\u4dbf\u4e00-\u9fff\u0600-\u06ff\u0900-\u097f\uac00-\ud7af]');
    if (nonLatinRegex.hasMatch(clean)) return false;

    // Check if common English words are present or plain ASCII
    final englishWords = RegExp(r'\b(the|is|you|are|hello|good|what|where|how|this|that|yes|no|please|thank|goodbye|morning|night|see|water|bread|friend|house|time|food|book)\b', caseSensitive: false);
    return englishWords.hasMatch(clean);
  }

  /// Explicitly speaks English text using English voice engine
  Future<void> speakEnglish(String text, {double? rate}) async {
    await speak(text, targetLanguage: 'en-US', rate: rate, forceEnglish: true);
  }

  /// Explicitly speaks Target Language text (Spanish, French, Japanese, etc.)
  Future<void> speakTarget(String text, {String? targetLanguage, double? rate}) async {
    await speak(text, targetLanguage: targetLanguage ?? _currentLanguage, rate: rate, forceEnglish: false);
  }

  /// Speaks the given [text] fluently using the configured TTS voiceover engine.
  /// Automatically handles language selection based on text context and caller instructions.
  Future<void> speak(String text, {String? targetLanguage, double? rate, bool forceEnglish = false}) async {
    if (text.trim().isEmpty) return;

    final sanitized = cleanTextForSpeech(text);
    if (sanitized.isEmpty) return;

    try {
      String langTag;
      if (forceEnglish) {
        langTag = 'en-US';
      } else if (targetLanguage != null) {
        langTag = getBcp47LanguageTag(targetLanguage);
      } else if (isEnglishText(sanitized)) {
        langTag = 'en-US';
      } else {
        langTag = _currentLanguage;
      }

      // Fast non-blocking speech stop & parameter application
      await _flutterTts.stop();

      if (_activeLanguageTag != langTag) {
        await _flutterTts.setLanguage(langTag);
        _activeLanguageTag = langTag;
      }

      await _flutterTts.setSpeechRate(rate ?? _speechRate);
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setVolume(1.0);

      // Unawaited speak to avoid blocking UI thread lag
      _flutterTts.speak(sanitized);
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
