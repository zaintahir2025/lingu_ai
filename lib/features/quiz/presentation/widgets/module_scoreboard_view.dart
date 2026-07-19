import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_constants.dart';
import '../../../../core/widgets/mascot/lingu_mascot.dart';
import '../../../../core/widgets/shared/primary_button.dart';
import '../../../progress/presentation/providers/progress_controller.dart';
import '../../../learn/domain/repositories/learn_repository.dart';

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
  ConsumerState<ModuleScoreboardView> createState() => _ModuleScoreboardViewState();
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

    final isPassed = widget.score >= 0.8;
    if (isPassed) {
      // Mark lesson as completed and unlock next
      await ref.read(learnRepositoryProvider).completeLesson(widget.lessonId);
      
      // Award XP
      final xpEarned = (widget.score * 50).toInt(); // up to 50 XP
      ref.read(progressControllerProvider.notifier).addXp(xpEarned);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isPassed = widget.score >= 0.8; // 80% threshold

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
                          isPassed ? AppColors.primaryGreen : AppColors.streakOrange,
                        ),
                        strokeCap: StrokeCap.round,
                      ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${(value * 100).toInt()}%',
                              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                    color: isPassed ? AppColors.primaryGreen : AppColors.streakOrange,
                                  ),
                            ),
                            Text(
                              isPassed ? 'Passed!' : 'Try Again',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColors.textSecondary,
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
          const SizedBox(height: AppConstants.space48),
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
          LinguMascot(
            pose: isPassed ? MascotPose.celebrating : MascotPose.encouraging,
            size: 100,
          ),
          const Spacer(),
          if (!isPassed)
            Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.space16),
              child: PrimaryButton(
                text: 'Retry',
                isSecondary: true,
                onPressed: widget.onRetry,
              ),
            ),
          PrimaryButton(
            text: isPassed ? 'Next Level' : 'Finish',
            onPressed: widget.onContinue,
          ),
        ],
      ),
    );
  }
}
