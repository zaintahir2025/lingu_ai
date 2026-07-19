import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/shared/app_card.dart';
import 'package:lingu_ai/l10n/app_localizations.dart';
import '../../../../core/storage/onboarding_storage.dart';
import '../../../user/presentation/controllers/user_controller.dart';

class LangPickerScreen extends ConsumerWidget {
  const LangPickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: AppCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context)!.whatLanguageLearn,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildLangOption(context, ref, AppLocalizations.of(context)!.langSpanish, '🇪🇸', 'es', userState.isLoading),
                  const SizedBox(height: 16),
                  _buildLangOption(context, ref, AppLocalizations.of(context)!.langFrench, '🇫🇷', 'fr', userState.isLoading),
                  const SizedBox(height: 16),
                  _buildLangOption(context, ref, AppLocalizations.of(context)!.langJapanese, '🇯🇵', 'ja', userState.isLoading),
                  if (userState.isLoading) ...[
                    const SizedBox(height: 16),
                    const CircularProgressIndicator(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLangOption(BuildContext context, WidgetRef ref, String name, String flag, String code, bool isLoading) {
    return InkWell(
      onTap: isLoading ? null : () async {
        // Save locally
        await ref.read(onboardingStorageProvider).setTargetLanguage(code);
        // Sync to server
        try {
          await ref.read(userControllerProvider.notifier).updateProfile(targetLanguage: code);
        } catch (_) {
          // Continue even if server sync fails — the survey step will also send it
        }
        if (context.mounted) {
          context.go('/experience-choice');
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.divider, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 16),
            Text(
              name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
