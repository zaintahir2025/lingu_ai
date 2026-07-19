import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../user/presentation/controllers/user_controller.dart';
import '../../../../core/storage/onboarding_storage.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/shared/primary_button.dart';
import '../../../../core/widgets/shared/app_card.dart';

class SurveyScreen extends ConsumerStatefulWidget {
  const SurveyScreen({super.key});

  @override
  ConsumerState<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends ConsumerState<SurveyScreen> {
  int _fluencyScore = 50;
  String _knowledgeLevel = 'intermediate';

  Future<void> _submit() async {
    final targetLanguage = ref.read(onboardingStorageProvider).targetLanguage ?? 'es';
    await ref.read(userControllerProvider.notifier).submitSurvey(
      knowledgeLevel: _knowledgeLevel,
      fluencyScore: _fluencyScore,
      targetLanguage: targetLanguage,
    );
    if (!mounted) return;
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Placement Survey'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Let\'s tailor your learning',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Answer a few questions to help us place you at the right level.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              ),
              const SizedBox(height: 32),
              
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('How would you describe your level?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 16),
                    _buildRadio('intermediate', 'I know basic words and phrases'),
                    _buildRadio('advanced', 'I can hold a conversation'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('How confident are you? ($_fluencyScore%)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 16),
                    Slider(
                      value: _fluencyScore.toDouble(),
                      min: 10,
                      max: 100,
                      divisions: 9,
                      activeColor: AppColors.primaryGreen,
                      onChanged: (val) => setState(() => _fluencyScore = val.toInt()),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              if (userState.error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(userState.error!, style: const TextStyle(color: AppColors.softErrorText)),
                ),
              PrimaryButton(
                text: 'Complete Setup',
                onPressed: userState.isLoading ? null : _submit,
                isLoading: userState.isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadio(String value, String label) {
    final isSelected = _knowledgeLevel == value;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: AppCard(
        onTap: () {
          setState(() => _knowledgeLevel = value);
        },
        color: isSelected ? AppColors.primaryGreen.withValues(alpha: 0.1) : AppColors.surface,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primaryGreen : AppColors.divider,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
