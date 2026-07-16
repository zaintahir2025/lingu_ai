import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_constants.dart';
import '../providers/progress_controller.dart';

import '../../../../core/notifications/notification_service.dart';
import 'package:lingu_ai/l10n/app_localizations.dart';
import '../../../../main.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressState = ref.watch(progressControllerProvider);

    return progressState.when(
      data: (state) {
        final xp = state.progress.totalXp;
        final level = state.progress.level;
        final streak = state.progress.currentStreak;
        final controller = ref.read(progressControllerProvider.notifier);
        final nextThreshold = controller.getThresholdForNextLevel(level);

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
              
              // 1. Weekly XP Chart
              _buildWeeklyXpChart(context),
              const SizedBox(height: AppConstants.space32),

              // 2. CEFR Progress
              _buildCefrProgress(context, level),
              const SizedBox(height: AppConstants.space32),

              // 3. Extended Stat Grid
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
                      _buildStatCard(context, AppLocalizations.of(context)!.masteredWords, '12', Icons.school, Colors.blue),
                      _buildStatCard(context, AppLocalizations.of(context)!.completedLessons, '4', Icons.menu_book, Colors.purple),
                      _buildStatCard(context, AppLocalizations.of(context)!.minutesSpent, '120', Icons.timer, Colors.teal),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppConstants.space32),

              // 4. Level Progress Bar
              Text(
                AppLocalizations.of(context)!.levelProgress(level, level + 1),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppConstants.space8),
              LinearProgressIndicator(
                value: xp / nextThreshold,
                minHeight: 12,
                backgroundColor: AppColors.surface,
                color: AppColors.xpGold,
                borderRadius: BorderRadius.circular(AppConstants.radius16),
              ),
              const SizedBox(height: AppConstants.space8),
              Text(
                AppLocalizations.of(context)!.xpProgress(xp, nextThreshold),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: AppConstants.space32),

              // 5. Leaderboard
              Text(
                AppLocalizations.of(context)!.leaderboardTab,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppConstants.space32),

              // 6. Settings
              Text(
                AppLocalizations.of(context)!.settingsTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppConstants.space16),
              _buildNotificationSettings(context, ref),
              const SizedBox(height: AppConstants.space16),
              _buildLanguageSettings(context, ref),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error loading progress: $e')),
    );
  }

  Widget _buildWeeklyXpChart(BuildContext context) {
    // Mock daily XP data for the last 7 days
    final List<double> weeklyXp = [20, 50, 10, 0, 100, 45, 80];
    
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
                maxY: 120,
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
                          toY: 120,
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
    // Mock CEFR calculation (e.g. A1 up to level 10, A2 up to level 20, etc.)
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

  Widget _buildNotificationSettings(BuildContext context, WidgetRef ref) {
    final isDesktop = Theme.of(context).platform == TargetPlatform.windows || 
                      Theme.of(context).platform == TargetPlatform.macOS || 
                      Theme.of(context).platform == TargetPlatform.linux;
    
    final label = isDesktop ? AppLocalizations.of(context)!.receiveRemindersDesktop : AppLocalizations.of(context)!.pushNotifications;
    
    return Container(
      padding: const EdgeInsets.all(AppConstants.space16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radius16),
        border: Border.all(color: AppColors.surface),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context)!.getStreakReminders,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              // Read local storage for notification preference
              // We'll mock it temporarily with a simple boolean state
              return Switch(
                value: true,
                onChanged: (val) async {
                  if (val) {
                    // ignore: avoid_dynamic_calls
                    final granted = await ref.read(notificationServiceProvider).requestPermission();
                    if (!context.mounted) return; // ignore: use_build_context_synchronously
                    if (granted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Notifications enabled!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Permission denied.')),
                      );
                    }
                  }
                },
                activeThumbColor: AppColors.primaryGreen,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSettings(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    
    return Container(
      padding: const EdgeInsets.all(AppConstants.space16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radius16),
        border: Border.all(color: AppColors.surface),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Language',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Switch between English and Urdu',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          DropdownButton<String>(
            value: currentLocale.languageCode,
            onChanged: (String? newValue) {
              if (newValue != null) {
                ref.read(localeProvider.notifier).state = Locale(newValue);
              }
            },
            items: const [
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'ur', child: Text('Urdu')),
            ],
          ),
        ],
      ),
    );
  }
}
