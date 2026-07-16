import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/mascot/lingu_mascot.dart';
import '../../../../core/widgets/shared/primary_button.dart';
import 'package:lingu_ai/l10n/app_localizations.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const LinguMascot(pose: MascotPose.celebrating, size: 150)
                .animate()
                .scale(duration: 500.ms, curve: Curves.easeOutBack),
              const SizedBox(height: 32),
              Text(
                AppLocalizations.of(context)!.resultsPlacedAt,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              TweenAnimationBuilder<int>(
                tween: IntTween(begin: 0, end: 2), // e.g. A1, A2, B1
                duration: const Duration(seconds: 2),
                builder: (context, value, child) {
                  final levels = ['A1', 'A2', 'B1'];
                  return Text(
                    levels[value],
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 64,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.resultsIntermediateB1,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 20),
              ).animate(delay: 2000.ms).fadeIn(),
              const SizedBox(height: 48),
              PrimaryButton(
                text: AppLocalizations.of(context)!.continueButton,
                onPressed: () => context.push('/onboarding/tour'),
              ).animate(delay: 2500.ms).fadeIn().slideY(begin: 1, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}
