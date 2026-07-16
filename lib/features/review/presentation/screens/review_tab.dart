import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_constants.dart';
import '../../../../core/widgets/shared/primary_button.dart';
import '../../../../core/database/database.dart';
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

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final db = ref.read(databaseProvider);
    final now = DateTime.now();
    // Fetch items due today or earlier
    final dueItems = await (db.select(db.vocabWords)
          ..where((t) => t.nextReviewDate.isNull() | t.nextReviewDate.isSmallerOrEqualValue(now)))
        .get();
    
    // Items with interval > 21 days are considered mastered
    final masteredItems = await (db.select(db.vocabWords)
          ..where((t) => t.interval.isBiggerThanValue(21)))
        .get();

    if (mounted) {
      setState(() {
        _dueCount = dueItems.length;
        _masteredCount = masteredItems.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppLocalizations.of(context)!.dailyReview,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppConstants.space24),
          
          // Due Count Card
          Container(
            padding: const EdgeInsets.all(AppConstants.space24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppConstants.radius16),
              border: Border.all(color: AppColors.divider, width: 2),
            ),
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.wordsDueToday,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppConstants.space16),
                Text(
                  '$_dueCount',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: _dueCount > 0 ? AppColors.streakOrange : AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: AppConstants.space24),
                if (_dueCount > 0)
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      text: AppLocalizations.of(context)!.startReview,
                      onPressed: () {
                        context.go('/review/session');
                      },
                    ),
                  )
                else
                  Text(
                    AppLocalizations.of(context)!.allCaughtUp,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          
          const SizedBox(height: AppConstants.space32),
          
          // Heatmap Placeholder
          Text(
            AppLocalizations.of(context)!.activityHeatmap,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppConstants.space16),
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppConstants.radius16),
              border: Border.all(color: AppColors.divider, width: 2),
            ),
            alignment: Alignment.center,
            child: Text(AppLocalizations.of(context)!.heatmapComingSoon),
          ),

          const SizedBox(height: AppConstants.space32),

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
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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
