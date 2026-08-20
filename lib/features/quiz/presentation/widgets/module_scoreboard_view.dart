import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_constants.dart';
import '../../../../core/widgets/mascot/piko_mascot.dart';
import '../../../../core/widgets/shared/primary_button.dart';
import '../../../../core/audio/tts_service.dart';
import '../../../../core/ads/ad_service.dart';
import '../../../../core/audio/sound_service.dart';

class ModuleScoreboardView extends ConsumerStatefulWidget {
  final int lessonId;
  final double score;
  final VoidCallback onRetry;
  final VoidCallback onContinue;

  const ModuleScoreboardView({
    super.key,
    required this.lessonId,
    required this.score,
    required this.onRetry,
    required this.onContinue,
  });

  @override
  ConsumerState<ModuleScoreboardView> createState() =>
      _ModuleScoreboardViewState();
}

class _ModuleScoreboardViewState extends ConsumerState<ModuleScoreboardView> {
  bool _processedResult = false;

  @override
  void initState() {
    super.initState();
    _processResult();
  }

  Future<void> _processResult() async {
    if (_processedResult) return;
    _processedResult = true;

    final isPassed = widget.score >= 0.75;
    if (isPassed) {
      await SoundService.playAchievement();
      TtsService().speakTarget(
        '¡Felicidades! Great job scoring ${(widget.score * 100).toInt()}% and unlocking level ${widget.lessonId + 1}!',
        emotion: TtsEmotion.excited,
      );
    } else {
      await SoundService.playWrong();
      TtsService().speakTarget(
        'Score at least 75% to unlock the next level. Try again!',
        emotion: TtsEmotion.encouraging,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isPassed = widget.score >= 0.75;

    return Padding(
      padding: const EdgeInsets.all(AppConstants.space24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: widget.score),
              duration: const Duration(seconds: 2),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return SizedBox(
                  width: 200,
                  height: 200,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: value,
                        strokeWidth: 20,
                        backgroundColor: AppColors.divider,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isPassed
                              ? AppColors.primaryGreen
                              : AppColors.streakOrange,
                        ),
                        strokeCap: StrokeCap.round,
                      ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${(value * 100).toInt()}%',
                              style: Theme.of(context).textTheme.displayLarge
                                  ?.copyWith(
                                    color: isPassed
                                        ? AppColors.primaryGreen
                                        : AppColors.streakOrange,
                                  ),
                            ),
                            Text(
                              isPassed ? 'Level Unlocked! 🔓' : 'Locked (Needs 75%) 🔒',
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    color: isPassed
                                        ? AppColors.primaryGreen
                                        : AppColors.heartRed,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppConstants.space24),
          Text(
            isPassed
                ? '🎉 Great job! You scored 75%+ and passed the Mega Quiz!'
                : '🔒 You need at least 75% score on the Mega Quiz to unlock Level ${widget.lessonId + 1}.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: isPassed ? AppColors.primaryGreen : AppColors.heartRedDark,
            ),
          ),
          const SizedBox(height: AppConstants.space24),
          if (isPassed) ...[
            Text(
              '+ ${(widget.score * 50).toInt()} XP',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.xpGold,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConstants.space16),
          ],
          PikoMascot(
            pose: isPassed ? PikoPose.celebrating : PikoPose.sad,
            size: 100,
          ),
          const Spacer(),
          if (!isPassed)
            Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.space16),
              child: PrimaryButton(
                text: 'Retry Mega Quiz (75% Needed) 🎯',
                onPressed: widget.onRetry,
              ),
            ),
          PrimaryButton(
            text: isPassed ? 'Next Level 🚀' : 'Back to Lessons 🏠',
            onPressed: () async {
              await ref.read(adServiceProvider).showInterstitialAd();
              if (!context.mounted) return;
              widget.onContinue();
            },
          ),
        ],
      ),
    );
  }
}
