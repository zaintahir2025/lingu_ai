import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/lesson_path_view.dart';
import '../../../../core/widgets/shared/streak_flame.dart';
import '../../../../core/widgets/shared/xp_badge.dart';
import 'package:lingu_ai/l10n/app_localizations.dart';

class LearnTab extends ConsumerWidget {
  const LearnTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check constraints to show sidebar on wide screens
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _buildMainContent(context),
              ),
              Container(width: 1, color: AppColors.divider),
              Expanded(
                flex: 1,
                child: _buildSidebar(context),
              ),
            ],
          );
        }
        return _buildMainContent(context);
      },
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryGreen, AppColors.streakOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGreen.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, color: Colors.white, size: 40),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AI Recommended Practice',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Targeting your persistent errors in verb conjugations.',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.push('/review/session');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Start', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
        const Expanded(child: LessonPathView()),
      ],
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              StreakFlame(streakDays: 12),
              XpBadge(amount: 450),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.divider, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.dailyQuests,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildQuestItem(AppLocalizations.of(context)!.earn50Xp, 0.8),
                const SizedBox(height: 12),
                _buildQuestItem(AppLocalizations.of(context)!.complete2Lessons, 0.5),
              ],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: AppColors.surface,
              foregroundColor: AppColors.primaryGreen,
              side: const BorderSide(color: AppColors.primaryGreen, width: 2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.list_alt),
            label: Text(AppLocalizations.of(context)!.vocabularyList, style: const TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              context.push('/learn/vocabulary');
            },
          )
        ],
      ),
    );
  }

  Widget _buildQuestItem(String title, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.divider,
          valueColor: const AlwaysStoppedAnimation(AppColors.primaryGreen),
          minHeight: 12,
          borderRadius: BorderRadius.circular(6),
        ),
      ],
    );
  }
}
