import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../user/presentation/controllers/user_controller.dart';
import '../../../../core/storage/onboarding_storage.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/shared/app_card.dart';

class ExperienceChoiceScreen extends ConsumerWidget {
  const ExperienceChoiceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userControllerProvider);

    void submitBeginner() {
      final targetLanguage = ref.read(onboardingStorageProvider).targetLanguage ?? 'es';
      ref.read(userControllerProvider.notifier).submitSurvey(
        knowledgeLevel: 'beginner',
        fluencyScore: 10,
        targetLanguage: targetLanguage,
      ).then((_) {
        // Need to refetch user or let auth controller handle it
        if (context.mounted) {
          context.go('/');
        }
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'How much of this language do you know?',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                AppCard(
                  child: Column(
                    children: [
                      _buildOption(
                        context,
                        title: 'I am a beginner',
                        subtitle: 'Start from scratch',
                        icon: Icons.egg_alt,
                        onTap: userState.isLoading ? null : submitBeginner,
                      ),
                      const Divider(height: 32),
                      _buildOption(
                        context,
                        title: 'I know some words',
                        subtitle: 'Take a short survey',
                        icon: Icons.school,
                        onTap: userState.isLoading ? null : () => context.go('/survey'),
                      ),
                    ],
                  ),
                ),
                if (userState.error != null) ...[
                  const SizedBox(height: 16),
                  Text(userState.error!, style: const TextStyle(color: AppColors.softErrorText)),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, {required String title, required String subtitle, required IconData icon, required VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primaryGreen, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: AppColors.textSecondary, size: 16),
          ],
        ),
      ),
    );
  }
}
