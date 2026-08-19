import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../storage/onboarding_storage.dart';
import '../local_storage/local_storage_provider.dart';

enum TtsEmotion { normal, excited, encouraging, calm, expressive }

final ttsSpeechRateProvider = StateNotifierProvider<TtsRateNotifier, double>((
  ref,
) {
  final box = ref.watch(localStorageProvider);
  return TtsRateNotifier(box);
});

class TtsRateNotifier extends StateNotifier<double> {
  final dynamic _box;
  static const String _key = 'tts_speech_rate';

  TtsRateNotifier(this._box)
    : super((_box.get(_key, defaultValue: 0.45) as double?) ?? 0.45);

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
  List<dynamic> _availableVoices = [];
  final Map<String, Map<String, String>> _voiceCache = {};

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
      await _flutterTts.awaitSpeakCompletion(true);

      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
        try {
          await _flutterTts.setEngine('com.google.android.tts');
        } catch (_) {
          // The device default remains available when Google Speech Services
          // is not installed.
        }
      }

      // Attempt to load and select best neural/natural voice
      _availableVoices = await _flutterTts.getVoices;
      await _selectBestVoice(_currentLanguage);
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing TtsService: $e');
    }
  }

  Future<void> _selectBestVoice(String langTag) async {
    if (_availableVoices.isEmpty) return;
    try {
      final normalizedTag = langTag.toLowerCase().replaceAll('_', '-');
      final cached = _voiceCache[normalizedTag];
      if (cached != null) {
        await _flutterTts.setVoice(cached);
        return;
      }

      final langPrefix = normalizedTag.split('-')[0];
      Map<String, String>? bestVoice;
      var bestScore = -1000;
      for (final voice in _availableVoices) {
        if (voice is Map) {
          final name = (voice['name'] ?? '').toString().toLowerCase();
          final localeValue = voice['locale'] ?? voice['language'] ?? '';
          final locale = localeValue.toString().toLowerCase().replaceAll(
            '_',
            '-',
          );
          if (!locale.startsWith(langPrefix)) continue;

          var score = locale == normalizedTag ? 100 : 45;
          const naturalMarkers = [
            'neural',
            'natural',
            'enhanced',
            'premium',
            'wavenet',
            'studio',
            'online',
            'siri',
            'google',
            'microsoft',
          ];
          const roboticMarkers = [
            'compact',
            'espeak',
            'robot',
            'synth',
            'basic',
          ];
          for (final marker in naturalMarkers) {
            if (name.contains(marker)) score += 18;
          }
          for (final marker in roboticMarkers) {
            if (name.contains(marker)) score -= 30;
          }
          if (score <= bestScore) continue;
          bestScore = score;
          bestVoice = {
            'name': voice['name'].toString(),
            'locale': localeValue.toString(),
          };
        }
      }
      if (bestVoice != null) {
        _voiceCache[normalizedTag] = bestVoice;
        await _flutterTts.setVoice(bestVoice);
      }
    } catch (e) {
      debugPrint('Voice selection warning: $e');
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
    if (!_isInitialized) await _initTts();
    await _selectBestVoice(_currentLanguage);
  }

  String cleanTextForSpeech(String text) {
    String cleaned = text;
    cleaned = cleaned.replaceAll(
      RegExp(r'^Audio:\s*"?', caseSensitive: false),
      '',
    );
    cleaned = cleaned.replaceAll(RegExp(r'"$'), '');
    cleaned = cleaned.replaceAll(RegExp(r'\*+|\_+|\`+|~+'), '');
    cleaned = cleaned.replaceAll(RegExp(r'\[.*?\]|\(.*?\)'), '');
    return cleaned.trim();
  }

  Future<void> speakEnglish(
    String text, {
    double? rate,
    TtsEmotion emotion = TtsEmotion.normal,
  }) async {
    await speak(
      text,
      targetLanguage: 'en-US',
      rate: rate,
      forceEnglish: true,
      emotion: emotion,
    );
  }

  Future<void> speakTarget(
    String text, {
    String? targetLanguage,
    double? rate,
    TtsEmotion emotion = TtsEmotion.normal,
  }) async {
    await speak(
      text,
      targetLanguage: targetLanguage ?? _currentLanguage,
      rate: rate,
      forceEnglish: false,
      emotion: emotion,
    );
  }

  Future<void> speak(
    String text, {
    String? targetLanguage,
    double? rate,
    bool forceEnglish = false,
    TtsEmotion emotion = TtsEmotion.normal,
  }) async {
    if (text.trim().isEmpty) return;
    final sanitized = cleanTextForSpeech(text);
    if (sanitized.isEmpty) return;

    try {
      if (!_isInitialized) await _initTts();
      String langTag;
      if (forceEnglish) {
        langTag = 'en-US';
      } else if (targetLanguage != null) {
        langTag = getBcp47LanguageTag(targetLanguage);
      } else {
        langTag = _currentLanguage;
      }

      // Subtle prosody changes keep high-quality voices expressive without
      // distorting native pronunciation.
      double pitch = 1.0;
      double baseRate = rate ?? _speechRate;

      if (kIsWeb) {
        // Web Speech uses 1.0 as normal while native engines generally use a
        // 0–1 scale. Preserve the learner's slider instead of overriding it.
        baseRate = (0.72 + baseRate * 0.62).clamp(0.72, 1.22);
      }

      switch (emotion) {
        case TtsEmotion.excited:
          pitch = 1.04;
          baseRate = (baseRate * 1.04).clamp(0.1, kIsWeb ? 1.25 : 1.0);
          break;
        case TtsEmotion.encouraging:
          pitch = 1.02;
          baseRate = (baseRate * 0.96).clamp(0.1, kIsWeb ? 1.25 : 1.0);
          break;
        case TtsEmotion.calm:
          pitch = 0.98;
          baseRate = (baseRate * 0.9).clamp(0.1, kIsWeb ? 1.25 : 1.0);
          break;
        case TtsEmotion.expressive:
          pitch = 1.03;
          break;
        case TtsEmotion.normal:
          pitch = 1.0;
          break;
      }

      // Fast non-blocking voice & configuration apply
      await _flutterTts.stop();
      await _flutterTts.setLanguage(langTag);
      await _flutterTts.setSpeechRate(baseRate);
      await _flutterTts.setPitch(pitch);
      await _flutterTts.setVolume(1.0);
      await _selectBestVoice(langTag);

      final spokenText = switch (emotion) {
        TtsEmotion.excited when !RegExp(r'[.!?]$').hasMatch(sanitized) =>
          '$sanitized!',
        TtsEmotion.encouraging when !RegExp(r'[.!?]$').hasMatch(sanitized) =>
          '$sanitized.',
        _ => sanitized,
      };
      await _flutterTts.speak(spokenText);
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
