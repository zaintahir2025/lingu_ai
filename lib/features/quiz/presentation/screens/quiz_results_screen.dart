import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/quiz_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_constants.dart';
import '../../../../core/widgets/mascot/lingu_mascot.dart';
import '../../../../core/widgets/shared/primary_button.dart';

class QuizResultsScreen extends ConsumerWidget {
  final int lessonId;
  const QuizResultsScreen({super.key, required this.lessonId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quizControllerProvider(lessonId));
    final bool isPassed = state.score >= 0.6; // 60% threshold

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.space24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Center(
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: state.score),
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
                    onPressed: () {
                      ref.read(quizControllerProvider(lessonId).notifier).restartQuiz();
                      context.go('/quiz/$lessonId');
                    },
                  ),
                ),
              PrimaryButton(
                text: 'Continue',
                onPressed: () {
                  context.go('/');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
