import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../audio/tts_service.dart';
import '../../audio/sound_service.dart';

/// Duolingo-style dual audio button control (Normal 🔊 + Turtle Slow 🐢)
class DuolingoAudioButtons extends StatelessWidget {
  final String text;
  final String? targetLanguage;
  final double size;

  const DuolingoAudioButtons({
    super.key,
    required this.text,
    this.targetLanguage,
    this.size = 52,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Normal Speed Audio Button
        InkWell(
          onTap: () {
            SoundService.playTap();
            TtsService().speakTarget(text, targetLanguage: targetLanguage);
          },
          borderRadius: BorderRadius.circular(size / 2),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: AppColors.gemBlue,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.gemBlue.withValues(alpha: 0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(
              Icons.volume_up_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
        const SizedBox(width: 14),

        // Turtle Slow Speed Audio Button
        InkWell(
          onTap: () {
            SoundService.playTap();
            TtsService().speakSlowTarget(text, targetLanguage: targetLanguage);
          },
          borderRadius: BorderRadius.circular((size - 8) / 2),
          child: Container(
            width: size - 8,
            height: size - 8,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGreen.withValues(alpha: 0.35),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Center(
              child: Text(
                '🐢',
                style: TextStyle(fontSize: 22),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
