import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/lesson_path_view.dart';
import '../../../../core/widgets/shared/streak_flame.dart';
import '../../../../core/widgets/shared/xp_badge.dart';
import '../../../../core/widgets/shared/duolingo_streak_widget.dart';
import 'package:lingu_ai/l10n/app_localizations.dart';
import '../../../progress/presentation/providers/progress_controller.dart';
import '../../domain/repositories/learn_repository.dart';
import '../../../../core/ads/ad_service.dart';
import '../../../../core/widgets/mascot/piko_mascot.dart';
import '../../../../core/audio/sound_service.dart';

import 'package:flutter_animate/flutter_animate.dart';

class LearnTab extends ConsumerWidget {
  const LearnTab({super.key});

  void _openDailyChest(BuildContext context, WidgetRef ref) {
    SoundService.playLevelUp();
    ref.read(progressControllerProvider.notifier).addXp(50);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.surface,
        title: const Text(
          '🎁 Daily Mystery Chest! 🎁',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.card_giftcard_rounded,
              size: 80,
              color: AppColors.streakOrange,
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.15, 1.15),
                  duration: 600.ms,
                ),
            const SizedBox(height: 16),
            const Text(
              '🎉 +50 XP Bonus & 1 Day Streak Shield Awarded!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Come back tomorrow to keep your streak burning!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 12,
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'AWESOME! 🚀',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _buildMainContent(context, ref)),
              Container(width: 1, color: AppColors.divider),
              Expanded(flex: 1, child: _buildSidebar(context, ref)),
            ],
          );
        }
        return _buildMainContent(context, ref);
      },
    );
  }

  Widget _buildMainContent(BuildContext context, WidgetRef ref) {
    final completedCount = ref.watch(completedLessonsCountProvider).value ?? 0;

    return StreamBuilder(
      stream: ref.watch(learnRepositoryProvider).watchLessons(),
      builder: (context, snapshot) {
        int highestUnlockedId = 1;
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final unlocked = snapshot.data!.where((l) => !l.isLocked).toList();
          if (unlocked.isNotEmpty) {
            unlocked.sort((a, b) => b.orderIndex.compareTo(a.orderIndex));
            highestUnlockedId = unlocked.first.id;
          }
        }

        final isNewUser = completedCount == 0 && highestUnlockedId == 1;

        final bannerTitle = isNewUser
            ? 'Welcome to LinguAI! 👋'
            : 'Continue Learning 🚀';
        final bannerSubtitle = isNewUser
            ? 'Let\'s get started with your very first lecture!'
            : 'Pick up right where you left off: Lesson $highestUnlockedId';
        final loc = AppLocalizations.of(context);
        final buttonText = isNewUser
            ? (loc?.getStartedButton ?? 'Get Started')
            : (loc?.continueButton ?? 'Continue');

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
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const PikoMascot(size: 76, pose: PikoPose.celebrating),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bannerTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            bannerSubtitle,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.card_giftcard_rounded,
                        color: Colors.white,
                        size: 30,
                      )
                          .animate(onPlay: (c) => c.repeat(reverse: true))
                          .scale(
                            begin: const Offset(1, 1),
                            end: const Offset(1.2, 1.2),
                            duration: 800.ms,
                          ),
                      tooltip: 'Claim Daily Bonus Chest! 🎁',
                      onPressed: () => _openDailyChest(context, ref),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        SoundService.playTap();
                        context.push('/module/$highestUnlockedId');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primaryGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        buttonText,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ref
                  .read(adServiceProvider)
                  .buildBannerAdContainer(context),
            ),
            const Expanded(child: LessonPathView()),
          ],
        );
      },
    );
  }

  Widget _buildSidebar(BuildContext context, WidgetRef ref) {
    final progressState = ref.watch(progressControllerProvider);
    final totalXp = progressState.value?.progress.totalXp ?? 0;
    final streakDays = progressState.value?.progress.currentStreak ?? 0;
    final completedCount = ref.watch(completedLessonsCountProvider).value ?? 0;

    final loc = AppLocalizations.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DuolingoStreakWidget(streakCount: streakDays, hasStreakFreeze: true),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StreakFlame(streakDays: streakDays),
              XpBadge(amount: totalXp),
            ],
          ),
          const SizedBox(height: 24),
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
                  loc?.dailyQuests ?? 'Daily Quests',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildQuestItem(
                  loc?.earn50Xp ?? 'Earn 50 XP',
                  (totalXp % 50) / 50.0,
                ),
                const SizedBox(height: 12),
                _buildQuestItem(
                  loc?.complete2Lessons ?? 'Complete 2 Lessons',
                  (completedCount / 2.0).clamp(0.0, 1.0),
                ),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.list_alt),
            label: Text(
              loc?.vocabularyList ?? 'Vocabulary List',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              context.push('/learn/vocabulary');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuestItem(String title, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress.clamp(0.0, 1.0),
          backgroundColor: AppColors.divider,
          valueColor: const AlwaysStoppedAnimation(AppColors.primaryGreen),
          minHeight: 12,
          borderRadius: BorderRadius.circular(6),
        ),
      ],
    );
  }
}
