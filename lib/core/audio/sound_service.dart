import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class SoundService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playCorrect() async {
    try {
      await _player.stop();
      await _player.play(AssetSource('sounds/correct.mp3'));
    } catch (e) {
      debugPrint('Error playing correct sound: $e');
    }
  }

  static Future<void> playWrong() async {
    try {
      await _player.stop();
      await _player.play(AssetSource('sounds/wrong.mp3'));
    } catch (e) {
      debugPrint('Error playing wrong sound: $e');
    }
  }
}
