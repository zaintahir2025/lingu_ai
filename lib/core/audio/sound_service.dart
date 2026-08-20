import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class SoundService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playCorrect() async {
    try {
      await _player.stop();
      await _player.play(AssetSource('sounds/correct.wav'));
    } catch (e) {
      debugPrint('Error playing correct sound: $e');
    }
  }

  static Future<void> playWrong() async {
    try {
      await _player.stop();
      await _player.play(AssetSource('sounds/incorrect.wav'));
    } catch (e) {
      debugPrint('Error playing wrong sound: $e');
    }
  }

  static Future<void> playFinish() async {
    try {
      await _player.stop();
      await _player.play(AssetSource('sounds/finish.mp3'));
    } catch (e) {
      debugPrint('Error playing finish sound: $e');
    }
  }

  static Future<void> playTap() async {
    try {
      await SystemSound.play(SystemSoundType.click);
      await HapticFeedback.selectionClick();
    } catch (e) {
      debugPrint('Error playing tap feedback: $e');
    }
  }

  static Future<void> playAchievement() async {
    await playFinish();
    try {
      await HapticFeedback.mediumImpact();
    } catch (e) {
      debugPrint('Error playing achievement haptic: $e');
    }
  }

  static Future<void> playLevelUp() async {
    await playAchievement();
  }
}
