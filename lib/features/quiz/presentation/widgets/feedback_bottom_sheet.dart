import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/audio/sound_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_constants.dart';
import '../../../../../core/widgets/mascot/lingu_mascot.dart';
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
      barrierColor: Colors.transparent, // Allow interaction below? No, it's a bottom sheet.
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
    final bgColor = widget.isCorrect ? AppColors.softSuccess : AppColors.softError;
    final textColor = widget.isCorrect ? AppColors.softSuccessText : AppColors.softErrorText;

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
                LinguMascot(
                  pose: widget.isCorrect ? MascotPose.celebrating : MascotPose.encouraging,
                  size: 60,
                ),
                const SizedBox(width: AppConstants.space16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isCorrect ? 'Excellent!' : 'Good try!',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: textColor,
                            ),
                      ),
                      if (!widget.isCorrect) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Correct answer: ${widget.correctAnswer}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.explanation,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: textColor,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.space24),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: 'Continue',
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onContinue();
                },
              ),
            ),
            if (widget.onAskTutor != null && !widget.isCorrect) ...[
              const SizedBox(height: AppConstants.space12),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text('Ask Tutor Why'),
                  style: TextButton.styleFrom(
                    foregroundColor: textColor,
                  ),
                  onPressed: widget.onAskTutor,
                ),
              ),
            ],
          ],
        ),
      ),
    );

    if (!widget.isCorrect) {
      content = AnimatedBuilder(
        animation: _shakeController,
        builder: (context, child) {
          final sineValue =
              (1 - _shakeController.value) * 10 * (1 - _shakeController.value); // Decaying shake
          return Transform.translate(
            offset: Offset(sineValue * (1 - _shakeController.value % 0.2 < 0.1 ? 1 : -1), 0),
            child: child,
          );
        },
        child: content,
      );
    }

    return content;
  }
}
