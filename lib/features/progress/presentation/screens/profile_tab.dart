import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_constants.dart';
import '../../../../core/storage/onboarding_storage.dart';
import '../providers/progress_controller.dart';
import '../../../../core/notifications/notification_service.dart';
import '../providers/settings_provider.dart';
import 'package:lingu_ai/l10n/app_localizations.dart';
import '../../../../main.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import 'contact_us_screen.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  static const Map<String, String> _languages = {
    'es': 'Spanish 🇪🇸',
    'fr': 'French 🇫🇷',
    'ja': 'Japanese 🇯🇵',
    'de': 'German 🇩🇪',
    'ur': 'Urdu 🇵🇰',
    'en': 'English 🇬🇧',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressState = ref.watch(progressControllerProvider);
    final authState = ref.watch(authControllerProvider);
    final onboardingStorage = ref.watch(onboardingStorageProvider);

    final username = authState.user?.username ?? authState.user?.name ?? 'Learner';
    final email = authState.user?.email ?? 'learner@linguai.com';
    final targetLangCode = onboardingStorage.targetLanguage ?? 'es';
    final targetLangName = _languages[targetLangCode] ?? 'Spanish 🇪🇸';

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
              // User Profile Header Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.divider),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.2),
                      child: Text(
                        username.isNotEmpty ? username[0].toUpperCase() : 'U',
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            username,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email,
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.stars_rounded, size: 14, color: AppColors.primaryGreen),
                              const SizedBox(width: 4),
                              Text(
                                'Level: ${authState.user?.knowledgeLevel?.toUpperCase() ?? "A1 (Beginner)"}',
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.space24),

              // Language Enrolment Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.language_rounded, color: AppColors.primaryGreen),
                        SizedBox(width: 8),
                        Text(
                          'Enrolled Language Course',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          targetLangName,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryGreenDark),
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.swap_horiz_rounded, color: AppColors.primaryGreen),
                          tooltip: 'Switch or Enroll in New Language',
                          onSelected: (String langCode) async {
                            await onboardingStorage.setTargetLanguage(langCode);
                            ref.invalidate(progressControllerProvider);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Enrolled in ${_languages[langCode]}!')),
                            );
                          },
                          itemBuilder: (context) {
                            return _languages.entries.map((entry) {
                              return PopupMenuItem(
                                value: entry.key,
                                child: Text(entry.value),
                              );
                            }).toList();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red[700],
                        side: BorderSide(color: Colors.red.withValues(alpha: 0.5)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.remove_circle_outline_rounded, size: 18),
                      label: const Text('Unenroll Course'),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Unenroll Course'),
                            content: Text('Are you sure you want to unenroll from $targetLangName? You can re-enroll anytime.'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Unenroll', style: TextStyle(color: Colors.red))),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await onboardingStorage.setTargetLanguage('es');
                          ref.invalidate(progressControllerProvider);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.space24),

              // Level Progress Bar
              Text(
                AppLocalizations.of(context)!.levelProgress(level, level + 1),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppConstants.space8),
              LinearProgressIndicator(
                value: (xp / nextThreshold).clamp(0.0, 1.0),
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

              // Settings & Contact Us
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
              const SizedBox(height: AppConstants.space16),
              
              // Contact Us Button
              Container(
                padding: const EdgeInsets.all(AppConstants.space16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppConstants.radius16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.headset_mic_rounded, color: AppColors.primaryGreen),
                        SizedBox(width: 12),
                        Text(
                          'Contact Us & Support',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ContactUsScreen()),
                        );
                      },
                      child: const Text('Contact'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.space32),

              // Logout Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final shouldLogout = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(AppLocalizations.of(context)!.logOut),
                        content: const Text('Are you sure you want to log out?'),
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
                  'App Interface Language',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Switch between English and Urdu UI',
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
