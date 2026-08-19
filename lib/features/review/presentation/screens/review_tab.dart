import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_constants.dart';
import '../../../../core/widgets/shared/primary_button.dart';
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
    final quota = reviewWordQuota(_selectedLevel);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppLocalizations.of(context)!.dailyReview,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            'Review previous lecture words with spaced repetition advancement.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: AppConstants.space20),

          // Level Selector Chips
          const Text(
            'Select Review Level:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(5, (index) {
                final lvl = index + 1;
                final isSelected = lvl == _selectedLevel;
                final lvlQuota = reviewWordQuota(lvl);
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text('Level $lvl ($lvlQuota Words)'),
                    selected: isSelected,
                    selectedColor: AppColors.primaryGreen,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    onSelected: (val) {
                      if (val) {
                        setState(() {
                          _selectedLevel = lvl;
                        });
                      }
                    },
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: AppConstants.space20),

          // Level Details Card
          Container(
            padding: const EdgeInsets.all(AppConstants.space24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppConstants.radius16),
              border: Border.all(color: AppColors.primaryGreen, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGreen.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.stars_rounded,
                      color: AppColors.streakOrange,
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Review Level $_selectedLevel',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '🎯 Goal: $quota Words (Previous Lectures Advancement)',
                    style: const TextStyle(
                      color: AppColors.primaryGreenDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.space16),
                Text(
                  '$_dueCount Words Due Today',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppConstants.space24),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: 'Start Level $_selectedLevel Review ($quota Words)',
                    onPressed: () {
                      SoundService.playTap();
                      context.go('/review/session?level=$_selectedLevel');
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.space16),

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
    );
  }
}
