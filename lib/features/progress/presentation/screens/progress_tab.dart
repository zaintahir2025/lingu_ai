import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_constants.dart';
import '../providers/progress_controller.dart';
import '../widgets/leaderboard_list.dart';
import 'package:lingu_ai/l10n/app_localizations.dart';

class ProgressTab extends ConsumerWidget {
  const ProgressTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressState = ref.watch(progressControllerProvider);

    return progressState.when(
      data: (state) {
        final xp = state.progress.totalXp;
        final level = state.progress.level;
        final streak = state.progress.currentStreak;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.yourProgress,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: AppConstants.space24),
              
              // Weekly XP Chart
              _buildWeeklyXpChart(context, ref),
              const SizedBox(height: AppConstants.space32),

              // CEFR Progress
              _buildCefrProgress(context, level),
              const SizedBox(height: AppConstants.space32),

              // Extended Stat Grid
              Text(
                AppLocalizations.of(context)!.statistics,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppConstants.space16),
              LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                  
                  final masteredWords = ref.watch(masteredWordsCountProvider).value ?? 0;
                  final completedLessons = ref.watch(completedLessonsCountProvider).value ?? 0;
                  final minutesSpent = ref.watch(minutesSpentProvider).value ?? 0;

                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: AppConstants.space16,
                    mainAxisSpacing: AppConstants.space16,
                    childAspectRatio: 1.2,
                    children: [
                      _buildStatCard(context, AppLocalizations.of(context)!.totalXp, xp.toString(), Icons.star, AppColors.xpGold),
                      _buildStatCard(context, AppLocalizations.of(context)!.levelTitle, level.toString(), Icons.military_tech, AppColors.primaryGreen),
                      _buildStatCard(context, AppLocalizations.of(context)!.dayStreak, streak.toString(), Icons.local_fire_department, AppColors.streakOrange),
                      _buildStatCard(context, AppLocalizations.of(context)!.masteredWords, masteredWords.toString(), Icons.school, Colors.blue),
                      _buildStatCard(context, AppLocalizations.of(context)!.completedLessons, completedLessons.toString(), Icons.menu_book, Colors.purple),
                      _buildStatCard(context, AppLocalizations.of(context)!.minutesSpent, minutesSpent.toString(), Icons.timer, Colors.teal),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppConstants.space32),

              // Leaderboard
              Text(
                AppLocalizations.of(context)!.leaderboardTab,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppConstants.space16),
              LeaderboardList(currentXp: xp),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error loading progress: $e')),
    );
  }

  Widget _buildWeeklyXpChart(BuildContext context, WidgetRef ref) {
    final weeklyXpState = ref.watch(weeklyXpProvider);
    final List<double> weeklyXp = weeklyXpState.value ?? List.filled(7, 0.0);
    double maxY = 120;
    for (final xp in weeklyXp) {
      if (xp > maxY) maxY = xp + 20;
    }
    
    return Container(
      height: 200,
      padding: const EdgeInsets.all(AppConstants.space16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radius16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.weeklyXp,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppConstants.space16),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const style = TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12);
                        Widget text;
                        switch (value.toInt()) {
                          case 0: text = const Text('M', style: style); break;
                          case 1: text = const Text('T', style: style); break;
                          case 2: text = const Text('W', style: style); break;
                          case 3: text = const Text('T', style: style); break;
                          case 4: text = const Text('F', style: style); break;
                          case 5: text = const Text('S', style: style); break;
                          case 6: text = const Text('S', style: style); break;
                          default: text = const Text('', style: style); break;
                        }
                        return SideTitleWidget(meta: meta, child: text);
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: weeklyXp.asMap().entries.map((e) {
                  return BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: e.value,
                        color: AppColors.xpGold,
                        width: 16,
                        borderRadius: BorderRadius.circular(4),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: maxY,
                          color: AppColors.surface.withValues(alpha: 0.5),
                        ),
                      )
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCefrProgress(BuildContext context, int level) {
    String currentCefr = 'A1';
    double progress = level / 10.0;
    if (level > 10) {
      currentCefr = 'A2';
      progress = (level - 10) / 10.0;
    }

    return Container(
      padding: const EdgeInsets.all(AppConstants.space16),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withAlpha(25),
        borderRadius: BorderRadius.circular(AppConstants.radius16),
        border: Border.all(color: AppColors.primaryGreen.withAlpha(50)),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: AppColors.primaryGreen,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              currentCefr,
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: AppConstants.space16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CEFR Progress ($currentCefr)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: AppConstants.space8),
                LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  minHeight: 8,
                  backgroundColor: Colors.white,
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(AppConstants.radius16),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.space16),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(AppConstants.radius16),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: AppConstants.space8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
