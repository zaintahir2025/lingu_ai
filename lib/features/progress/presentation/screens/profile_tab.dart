import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_constants.dart';
import '../providers/progress_controller.dart';
import '../../../../core/notifications/notification_service.dart';
import '../providers/settings_provider.dart';
import 'package:lingu_ai/l10n/app_localizations.dart';
import '../../../../main.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressState = ref.watch(progressControllerProvider);

    return progressState.when(
      data: (state) {
        final xp = state.progress.totalXp;
        final level = state.progress.level;
        final controller = ref.read(progressControllerProvider.notifier);
        final nextThreshold = controller.getThresholdForNextLevel(level);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.profileTab,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: AppConstants.space24),
              
              // Level Progress Bar
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
              const SizedBox(height: AppConstants.space48),

              // Settings
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
              const SizedBox(height: AppConstants.space48),
              
              // Logout Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    // Show confirmation dialog
                    final shouldLogout = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(AppLocalizations.of(context)!.logOut),
                        content: Text('Are you sure you want to log out?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: TextButton.styleFrom(foregroundColor: Colors.red),
                            child: const Text('Log Out'),
                          ),
                        ],
                      ),
                    );

                    if (shouldLogout == true && context.mounted) {
                      await ref.read(authControllerProvider.notifier).logout();
                    }
                  },
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: Text(
                    AppLocalizations.of(context)!.logOut,
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppConstants.space16),
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radius16)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error loading progress: $e')),
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
              final settings = ref.watch(settingsProvider);
              return Switch(
                value: settings.notificationsEnabled,
                onChanged: (val) async {
                  if (val) {
                    final granted = await ref.read(notificationServiceProvider).requestPermission();
                    if (!context.mounted) return;
                    if (granted) {
                      ref.read(settingsProvider.notifier).toggleNotifications(true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Notifications enabled!')),
                      );
                    } else {
                      ref.read(settingsProvider.notifier).toggleNotifications(false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Permission denied.')),
                      );
                    }
                  } else {
                    ref.read(settingsProvider.notifier).toggleNotifications(false);
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
