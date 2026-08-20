import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
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
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isInitialized = false;
  String _currentLanguage = 'es-ES';
  double _speechRate = 0.45;
  List<dynamic> _availableVoices = [];
  final Map<String, Map<String, String>> _voiceCache = {};

  bool get isInitialized => _isInitialized;
  double get currentSpeechRate => _speechRate;

  void setSpeechRate(double rate) {
    _speechRate = rate.clamp(0.1, 1.0);
    try {
      _flutterTts.setSpeechRate(_speechRate);
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
      await _flutterTts.awaitSpeakCompletion(!kIsWeb);

      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
        try {
          await _flutterTts.setEngine('com.google.android.tts');
        } catch (_) {}
      }

      try {
        _availableVoices = await _flutterTts.getVoices;
      } catch (_) {
        _availableVoices = [];
      }

      await _selectBestVoice(_currentLanguage);
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing TtsService: $e');
      _isInitialized = true;
    }
  }

  Future<void> _selectBestVoice(String langTag) async {
    if (_availableVoices.isEmpty) return;
    try {
      final normalizedTag = langTag.toLowerCase().replaceAll('_', '-');
      final cached = _voiceCache[normalizedTag];
      if (cached != null) {
        try {
          await _flutterTts.setVoice(cached);
        } catch (_) {}
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
        try {
          await _flutterTts.setVoice(bestVoice);
        } catch (_) {}
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
      await stop();

      final fullTag = forceEnglish
          ? 'en-US'
          : (targetLanguage != null
              ? getBcp47LanguageTag(targetLanguage)
              : _currentLanguage);
      final shortLang = fullTag.split('-')[0];

      // Primary: High-Quality Google Neural Human Voice Stream
      if (sanitized.length <= 200) {
        try {
          final audioUrl =
              'https://translate.google.com/translate_tts?ie=UTF-8&tl=$shortLang&client=tw-ob&q=${Uri.encodeComponent(sanitized)}';
          await _audioPlayer.play(UrlSource(audioUrl));
          return;
        } catch (e) {
          debugPrint('Google Neural Audio Stream fallback to FlutterTts: $e');
        }
      }

      // Secondary: FlutterTts with preferred neural voice selection
      if (!_isInitialized) await _initTts();

      double pitch = 1.0;
      double baseRate = rate ?? _speechRate;

      switch (emotion) {
        case TtsEmotion.excited:
          pitch = 1.05;
          baseRate = (baseRate * 1.05).clamp(0.1, 1.0);
          break;
        case TtsEmotion.encouraging:
          pitch = 1.02;
          baseRate = (baseRate * 0.95).clamp(0.1, 1.0);
          break;
        case TtsEmotion.calm:
          pitch = 0.98;
          baseRate = (baseRate * 0.90).clamp(0.1, 1.0);
          break;
        case TtsEmotion.expressive:
          pitch = 1.03;
          break;
        case TtsEmotion.normal:
          pitch = 1.0;
          break;
      }

      try {
        final result = await _flutterTts.setLanguage(fullTag);
        if (result == 0) {
          await _flutterTts.setLanguage(shortLang);
        }
      } catch (_) {
        try {
          await _flutterTts.setLanguage(shortLang);
        } catch (_) {}
      }

      try {
        await _flutterTts.setSpeechRate(baseRate);
        await _flutterTts.setPitch(pitch);
        await _flutterTts.setVolume(1.0);
      } catch (_) {}

      try {
        await _selectBestVoice(fullTag);
      } catch (_) {}

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
      await _audioPlayer.stop();
      await _flutterTts.stop();
    } catch (e) {
      debugPrint('Error stopping TTS: $e');
    }
  }
}
