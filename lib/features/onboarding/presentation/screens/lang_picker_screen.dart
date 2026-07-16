import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/shared/app_card.dart';
import 'package:lingu_ai/l10n/app_localizations.dart';

class LangPickerScreen extends StatelessWidget {
  const LangPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  _buildLangOption(context, AppLocalizations.of(context)!.langSpanish, '🇪🇸'),
                  const SizedBox(height: 16),
                  _buildLangOption(context, AppLocalizations.of(context)!.langFrench, '🇫🇷'),
                  const SizedBox(height: 16),
                  _buildLangOption(context, AppLocalizations.of(context)!.langJapanese, '🇯🇵'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLangOption(BuildContext context, String name, String flag) {
    return InkWell(
      onTap: () {
        // Just proceed to placement for now
        context.push('/onboarding/placement');
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
