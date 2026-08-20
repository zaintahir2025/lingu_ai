import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/audio/sound_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_constants.dart';
import '../../../../../core/widgets/mascot/piko_mascot.dart';
import '../../../../../core/widgets/shared/primary_button.dart';

class FeedbackBottomSheet extends StatefulWidget {
  final bool isCorrect;
  final String correctAnswer;
  final String explanation;
  final VoidCallback onContinue;
  final VoidCallback? onAskTutor;

  const FeedbackBottomSheet({
    super.key,
    required this.isCorrect,
    required this.correctAnswer,
    required this.explanation,
    required this.onContinue,
    this.onAskTutor,
  });

  static Future<void> show({
    required BuildContext context,
    required bool isCorrect,
    required String correctAnswer,
    required String explanation,
    required VoidCallback onContinue,
    VoidCallback? onAskTutor,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      barrierColor: Colors
          .transparent, // Allow interaction below? No, it's a bottom sheet.
      builder: (context) => FeedbackBottomSheet(
        isCorrect: isCorrect,
        correctAnswer: correctAnswer,
        explanation: explanation,
        onContinue: onContinue,
        onAskTutor: onAskTutor,
      ),
    );
  }

  @override
  State<FeedbackBottomSheet> createState() => _FeedbackBottomSheetState();
}

class _FeedbackBottomSheetState extends State<FeedbackBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    if (widget.isCorrect) {
      HapticFeedback.lightImpact();
      SoundService.playCorrect();
    } else {
      HapticFeedback.heavyImpact();
      _shakeController.forward();
      SoundService.playWrong();
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isCorrect
        ? AppColors.softSuccess
        : AppColors.softError;
    final textColor = widget.isCorrect
        ? AppColors.softSuccessText
        : AppColors.softErrorText;

    Widget content = Container(
      padding: const EdgeInsets.all(AppConstants.space24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppConstants.radius24),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                PikoMascot(
                  pose: widget.isCorrect
                      ? PikoPose.celebrating
                      : PikoPose.sad,
                  size: 64,
                ),
                const SizedBox(width: AppConstants.space16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isCorrect
                            ? 'Awesome! Perfect Answer! 🎉'
                            : 'Don\'t worry, mistakes help you learn! 💪',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (!widget.isCorrect) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.heartRed.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Correct Answer: ${widget.correctAnswer}',
                                style: const TextStyle(
                                  color: AppColors.heartRedDark,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              if (widget.explanation.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  widget.explanation,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 13,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.space20),
            if (widget.onAskTutor != null && !widget.isCorrect) ...[
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 2,
                ),
                icon: const Icon(Icons.auto_awesome_rounded, size: 20),
                label: const Text(
                  '🤖 Ask AI Tutor to Explain (Gemini AI)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                onPressed: widget.onAskTutor,
              ),
              const SizedBox(height: AppConstants.space12),
            ],
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: 'Continue 🚀',
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onContinue();
                },
              ),
            ),
          ],
        ),
      ),
    );

    if (!widget.isCorrect) {
      content = AnimatedBuilder(
        animation: _shakeController,
        builder: (context, child) {
          final sineValue =
              (1 - _shakeController.value) *
              10 *
              (1 - _shakeController.value); // Decaying shake
          return Transform.translate(
            offset: Offset(
              sineValue * (1 - _shakeController.value % 0.2 < 0.1 ? 1 : -1),
              0,
            ),
            child: child,
          );
        },
        child: content,
      );
    }

    return content;
  }
}
