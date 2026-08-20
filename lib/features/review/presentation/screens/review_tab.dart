import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_constants.dart';
import '../../../../core/widgets/shared/primary_button.dart';
import '../../../../core/widgets/shared/view_pager_cards.dart';
import '../../../../core/audio/sound_service.dart';
import '../../../../core/database/database.dart';
import '../../../../core/ads/ad_service.dart';
import '../../domain/review_level_config.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:lingu_ai/l10n/app_localizations.dart';

class ReviewTab extends ConsumerStatefulWidget {
  const ReviewTab({super.key});

  @override
  ConsumerState<ReviewTab> createState() => _ReviewTabState();
}

class _ReviewTabState extends ConsumerState<ReviewTab> {
  int _dueCount = 0;
  int _masteredCount = 0;
  int _selectedLevel = 1;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final db = ref.read(databaseProvider);
    final now = DateTime.now();
    final dueItems =
        await (db.select(db.vocabWords)..where(
              (t) =>
                  t.nextReviewDate.isNull() |
                  t.nextReviewDate.isSmallerOrEqualValue(now),
            ))
            .get();

    final masteredItems = await (db.select(
      db.vocabWords,
    )..where((t) => t.interval.isBiggerThanValue(21))).get();

    if (mounted) {
      setState(() {
        _dueCount = dueItems.length;
        _masteredCount = masteredItems.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final levelTitles = [
      'Foundation SRS',
      'Audio & Listening',
      'Sentence Master',
      'Speed Review',
      'Mastery Challenge',
    ];

    final levelIcons = [
      Icons.auto_awesome_rounded,
      Icons.graphic_eq_rounded,
      Icons.psychology_rounded,
      Icons.bolt_rounded,
      Icons.workspace_premium_rounded,
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.space24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.dailyReview,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Swipe cards below to select your review level powered by Spaced Repetition.',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.space20),

          // Rubens Sousa ViewPagerCards 3D Transformer Slider
          ViewPagerCards(
            itemCount: 5,
            initialPage: _selectedLevel - 1,
            height: 310,
            onPageChanged: (index) {
              setState(() {
                _selectedLevel = index + 1;
              });
            },
            itemBuilder: (context, index, isSelected) {
              final lvl = index + 1;
              final quota = reviewWordQuota(lvl);
              final title = levelTitles[index];
              final icon = levelIcons[index];

              return Padding(
                padding: const EdgeInsets.all(AppConstants.space20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryGreen
                                : AppColors.primaryGreen.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Level $lvl',
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.primaryGreenDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Icon(
                          icon,
                          color: isSelected
                              ? AppColors.streakOrange
                              : AppColors.textSecondary,
                          size: 28,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Text(
                        '🎯 Goal: $quota Words',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        text: 'Start Level $lvl ($quota Words)',
                        onPressed: () {
                          SoundService.playTap();
                          context.go('/review/session?level=$lvl');
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: AppConstants.space16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.space24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Google Ad Placement #3 (Review Tab)
                ref.read(adServiceProvider).buildReviewAdBanner(context),

                const SizedBox(height: AppConstants.space16),

                // Mastered Words Counter
                Container(
                  padding: const EdgeInsets.all(AppConstants.space24),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppConstants.radius16),
                    border: Border.all(color: AppColors.primaryGreen, width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.wordsMastered,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.primaryGreenDark,
                        ),
                      ),
                      TweenAnimationBuilder<int>(
                        tween: IntTween(begin: 0, end: _masteredCount),
                        duration: const Duration(seconds: 2),
                        builder: (context, value, child) {
                          return Text(
                            '$value',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: AppColors.primaryGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
