import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../storage/onboarding_storage.dart';
import '../local_storage/local_storage_provider.dart';

final ttsSpeechRateProvider = StateNotifierProvider<TtsRateNotifier, double>((ref) {
  final box = ref.watch(localStorageProvider);
  return TtsRateNotifier(box);
});

class TtsRateNotifier extends StateNotifier<double> {
  final dynamic _box;
  static const String _key = 'tts_speech_rate';

  TtsRateNotifier(this._box) : super((_box.get(_key, defaultValue: 0.45) as double?) ?? 0.45);

  Future<void> setRate(double newRate) async {
    state = newRate;
    await _box.put(_key, newRate);
    TtsService().setSpeechRate(newRate);
  }
}

final ttsServiceProvider = Provider<TtsService>((ref) {
  final onboardingStorage = ref.watch(onboardingStorageProvider);
  final targetLang = onboardingStorage.targetLanguage ?? 'es';
  final rate = ref.watch(ttsSpeechRateProvider);
  final service = TtsService();
  service.initLanguage(targetLang);
  service.setSpeechRate(rate);
  return service;
});

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;

  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;
  String _currentLanguage = 'es-ES';
  double _speechRate = 0.45;

  bool get isInitialized => _isInitialized;
  double get currentSpeechRate => _speechRate;

  void setSpeechRate(double rate) {
    _speechRate = rate;
    try {
      _flutterTts.setSpeechRate(rate);
    } catch (_) {}
  }

  TtsService._internal() {
    _initTts();
  }

  Future<void> _initTts() async {
    try {
      await _flutterTts.setSpeechRate(_speechRate);
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.awaitSpeakCompletion(false);
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing TtsService: $e');
    }
  }

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
      case 'de':
      case 'german':
        return 'de-DE';
      case 'ur':
      case 'urdu':
        return 'ur-PK';
      case 'en':
      case 'english':
        return 'en-US';
      default:
        if (code.contains('-')) return code;
        return 'es-ES';
    }
  }

  Future<void> initLanguage(String langCode) async {
    _currentLanguage = getBcp47LanguageTag(langCode);
  }

  String cleanTextForSpeech(String text) {
    String cleaned = text;
    cleaned = cleaned.replaceAll(RegExp(r'^Audio:\s*"?', caseSensitive: false), '');
    cleaned = cleaned.replaceAll(RegExp(r'"$'), '');
    cleaned = cleaned.replaceAll(RegExp(r'\*+|\_+|\`+|~+'), '');
    return cleaned.trim();
  }

  Future<void> speakEnglish(String text, {double? rate}) async {
    await speak(text, targetLanguage: 'en-US', rate: rate, forceEnglish: true);
  }

  Future<void> speakTarget(String text, {String? targetLanguage, double? rate}) async {
    await speak(text, targetLanguage: targetLanguage ?? _currentLanguage, rate: rate, forceEnglish: false);
  }

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
      } else {
        langTag = _currentLanguage;
      }

      _flutterTts.stop();
      _flutterTts.setLanguage(langTag);
      _flutterTts.setSpeechRate(rate ?? _speechRate);
      _flutterTts.setPitch(1.0);
      _flutterTts.setVolume(1.0);

      _flutterTts.speak(sanitized);
    } catch (e) {
      debugPrint('Error in TtsService speak ($targetLanguage): $e');
    }
  }

  Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (e) {
      debugPrint('Error stopping TTS: $e');
    }
  }
}
