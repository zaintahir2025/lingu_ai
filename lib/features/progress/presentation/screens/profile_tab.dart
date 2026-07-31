import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_constants.dart';
import '../../../../core/storage/onboarding_storage.dart';
import '../../../../core/database/database.dart';
import '../../../learn/domain/repositories/learn_repository.dart';
import '../../../admin/presentation/screens/admin_panel_screen.dart';
import '../../../user/presentation/controllers/user_controller.dart';
import '../providers/progress_controller.dart';
import '../../../../core/notifications/notification_service.dart';
import '../providers/settings_provider.dart';
import 'package:lingu_ai/l10n/app_localizations.dart';
import '../../../../main.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import 'contact_us_screen.dart';
import '../../../../core/storage/study_goal_storage.dart';
import '../../../../core/game_state/heart_settings_storage.dart';

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
                    IconButton(
                      icon: const Icon(Icons.edit_rounded, color: AppColors.primaryGreen),
                      tooltip: 'Edit Profile Info',
                      onPressed: () => _showEditProfileDialog(context, ref, username),
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
                          onSelected: (String langCode) {
                            _switchCourseWithReset(context, ref, langCode, _languages[langCode] ?? langCode);
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
                      onPressed: () => _switchCourseWithReset(context, ref, 'es', 'Spanish 🇪🇸'),
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

              // Settings & Admin Panel
              Text(
                AppLocalizations.of(context)!.settingsTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppConstants.space16),
              
              // Admin Panel Navigation Card
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AdminPanelScreen()),
                  );
                },
                borderRadius: BorderRadius.circular(AppConstants.radius16),
                child: Container(
                  padding: const EdgeInsets.all(AppConstants.space16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppConstants.radius16),
                    border: Border.all(color: AppColors.primaryGreen),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.admin_panel_settings_rounded, color: AppColors.primaryGreen, size: 28),
                      SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Admin Panel • Ads & Banking Setup ⚙️',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primaryGreenDark),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Manage Google AdMob Unit IDs, Ad toggles & Payout banking accounts',
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, color: AppColors.primaryGreen),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.space16),

              _buildNotificationSettings(context, ref),
              const SizedBox(height: AppConstants.space16),
              _buildLanguageSettings(context, ref),
              const SizedBox(height: AppConstants.space16),
              _buildStudyGoalsSettings(context, ref),
              const SizedBox(height: AppConstants.space16),
              _buildHeartsModeSettings(context, ref),
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

  Widget _buildStudyGoalsSettings(BuildContext context, WidgetRef ref) {
    final goalStorage = ref.watch(studyGoalStorageProvider);
    final daily = goalStorage.dailyGoalMinutes;
    final weekly = goalStorage.weeklyGoalHours;
    final monthly = goalStorage.monthlyGoalHours;

    return Container(
      padding: const EdgeInsets.all(AppConstants.space16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radius16),
        border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.timer_rounded, color: AppColors.primaryGreen),
              SizedBox(width: 8),
              Text(
                'Study Duration Goals 🎯',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Select how much duration you plan to dedicate to learning:',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),

          // Daily Goal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Daily Goal:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              DropdownButton<int>(
                value: daily,
                onChanged: (val) async {
                  if (val != null) {
                    await goalStorage.setDailyGoalMinutes(val);
                    ref.invalidate(studyGoalStorageProvider);
                  }
                },
                items: const [
                  DropdownMenuItem(value: 10, child: Text('10 mins / day (Casual)')),
                  DropdownMenuItem(value: 15, child: Text('15 mins / day (Regular)')),
                  DropdownMenuItem(value: 30, child: Text('30 mins / day (Serious)')),
                  DropdownMenuItem(value: 45, child: Text('45 mins / day (Intensive)')),
                ],
              ),
            ],
          ),
          const Divider(height: 16),

          // Weekly Goal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Weekly Target:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              DropdownButton<int>(
                value: weekly,
                onChanged: (val) async {
                  if (val != null) {
                    await goalStorage.setWeeklyGoalHours(val);
                    ref.invalidate(studyGoalStorageProvider);
                  }
                },
                items: const [
                  DropdownMenuItem(value: 1, child: Text('1 Hour / week')),
                  DropdownMenuItem(value: 2, child: Text('2 Hours / week')),
                  DropdownMenuItem(value: 4, child: Text('4 Hours / week')),
                  DropdownMenuItem(value: 7, child: Text('7 Hours / week')),
                ],
              ),
            ],
          ),
          const Divider(height: 16),

          // Monthly Goal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Monthly Target:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              DropdownButton<int>(
                value: monthly,
                onChanged: (val) async {
                  if (val != null) {
                    await goalStorage.setMonthlyGoalHours(val);
                    ref.invalidate(studyGoalStorageProvider);
                  }
                },
                items: const [
                  DropdownMenuItem(value: 5, child: Text('5 Hours / month')),
                  DropdownMenuItem(value: 10, child: Text('10 Hours / month')),
                  DropdownMenuItem(value: 20, child: Text('20 Hours / month')),
                  DropdownMenuItem(value: 30, child: Text('30 Hours / month')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeartsModeSettings(BuildContext context, WidgetRef ref) {
    final heartStorage = ref.watch(heartSettingsStorageProvider);
    final isUnlimited = heartStorage.isUnlimitedMode;

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
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Unlimited Hearts Mode ❤️',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(height: 4),
                Text(
                  'Recommended for beginners. Learn without app blocking on mistakes.',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Switch(
            value: isUnlimited,
            onChanged: (val) async {
              await heartStorage.setHeartsMode(val ? 'unlimited' : 'challenge');
              ref.invalidate(heartSettingsStorageProvider);
            },
            activeThumbColor: AppColors.primaryGreen,
          ),
        ],
      ),
    );
  }

  Future<void> _switchCourseWithReset(BuildContext context, WidgetRef ref, String newLangCode, String langName) async {
    final onboardingStorage = ref.read(onboardingStorageProvider);
    final currentLangCode = onboardingStorage.targetLanguage ?? 'es';

    if (currentLangCode == newLangCode) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
            SizedBox(width: 8),
            Text('Switch Course & Reset?'),
          ],
        ),
        content: Text(
          'Warning! Switching your course to $langName will reset your completed modules and streak for your active course.\n\nDo you want to proceed?',
          style: const TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes, Reset & Switch', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final db = ref.read(databaseProvider);
        await (db.update(db.lessons)..where((t) => t.id.isBiggerThanValue(1))).write(
          const LessonsCompanion(isCompleted: Value(false), isLocked: Value(true)),
        );
        await (db.update(db.lessons)..where((t) => t.id.equals(1))).write(
          const LessonsCompanion(isCompleted: Value(false), isLocked: Value(false)),
        );
      } catch (_) {}

      await onboardingStorage.setTargetLanguage(newLangCode);
      ref.invalidate(progressControllerProvider);
      ref.invalidate(learnRepositoryProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Switched course to $langName! Progress reset.'),
            backgroundColor: AppColors.primaryGreen,
          ),
        );
      }
    }
  }

  void _showEditProfileDialog(BuildContext context, WidgetRef ref, String currentName) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.person_pin_rounded, color: AppColors.primaryGreen, size: 28),
            SizedBox(width: 8),
            Text('Edit Profile Info'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Update Username / Display Name:'),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.badge_rounded),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                await ref.read(userControllerProvider.notifier).updateProfile(username: newName);
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
