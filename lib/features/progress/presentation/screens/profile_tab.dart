import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:go_router/go_router.dart';
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
import '../../../../core/storage/premium_storage.dart';
import '../../../../core/widgets/shared/premium_badge.dart';
import '../../../../core/audio/tts_service.dart';
import '../../../../core/providers/target_language_provider.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  static const Map<String, String> _languages = TargetLanguages.languages;

  Widget _buildPillBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24, width: 0.8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressState = ref.watch(progressControllerProvider);
    final authState = ref.watch(authControllerProvider);

    // Reactive Riverpod Premium state
    final isPremium = ref.watch(premiumStorageProvider);
    final premiumNotifier = ref.watch(premiumStorageProvider.notifier);
    final loc = AppLocalizations.of(context)!;

    final username =
        authState.user?.username ?? authState.user?.name ?? 'Learner';
    final email = authState.user?.email ?? 'Not signed in';
    final targetLangCode = ref.watch(targetLanguageProvider);
    final targetLangName = _languages[targetLangCode] ?? 'Spanish 🇪🇸';

    // Expiry check
    final expiryDate = premiumNotifier.expiryDate;
    final isLastDay =
        isPremium &&
        expiryDate != null &&
        expiryDate.difference(DateTime.now()).inDays <= 1;

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
              // Premium Expiration Renewal Alert Banner (Last Day)
              if (isLastDay) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.amber.shade700, width: 2),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.amber,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          loc.renewReminderMessage,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.amber.shade900,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber.shade900,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        onPressed: () => context.push('/payment'),
                        child: const Text('Reactivate'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // User Profile Header Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isPremium ? Colors.amber : AppColors.divider,
                    width: isPremium ? 2 : 1,
                  ),
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
                      backgroundColor: isPremium
                          ? Colors.amber.shade100
                          : AppColors.primaryGreen.withValues(alpha: 0.2),
                      child: Text(
                        username.isNotEmpty ? username[0].toUpperCase() : 'U',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: isPremium
                              ? Colors.amber.shade900
                              : AppColors.primaryGreen,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  username,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isPremium) ...[
                                const SizedBox(width: 8),
                                const PremiumBadge(),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.stars_rounded,
                                size: 14,
                                color: AppColors.primaryGreen,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Level: ${authState.user?.knowledgeLevel?.toUpperCase() ?? "A1 (Beginner)"}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.edit_rounded,
                        color: AppColors.primaryGreen,
                      ),
                      tooltip: 'Edit Profile Info',
                      onPressed: () =>
                          _showEditProfileDialog(context, ref, username),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.space24),

              // If FREE: Show Unlock Premium Banner
              // If PREMIUM: Show Active Premium Subscription Badge
              if (!isPremium) ...[
                InkWell(
                  onTap: () => _showUnlockPremiumModal(context),
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF1E1B4B),
                          Color(0xFF312E81),
                          Color(0xFF4338CA),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.amber.shade400,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF4338CA,
                          ).withValues(alpha: 0.35),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade400.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.amber.shade400,
                              width: 1.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.workspace_premium_rounded,
                            size: 36,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Text(
                                    'LinguAI PRO',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  PremiumBadge(),
                                ],
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Unlock AI Tutor, Ad-Free Sessions, Unlimited Lives & Priority Support!',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 6,
                                runSpacing: 4,
                                children: [
                                  _buildPillBadge('🤖 AI Tutor'),
                                  _buildPillBadge('🚫 No Ads'),
                                  _buildPillBadge('❤️ Infinite Lives'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade400,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.black,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.space24),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.amber.shade600, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade600,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.workspace_premium_rounded,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '👑 Active LinguAI PRO Membership',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              expiryDate != null
                                  ? 'Your 1-Month Pass is active • Expires ${expiryDate.day}/${expiryDate.month}/${expiryDate.year}'
                                  : 'Active Unlimited PRO Pass',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.amber.shade900,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const PremiumBadge(),
                    ],
                  ),
                ),
                const SizedBox(height: AppConstants.space24),
              ],

              // Language Enrolment Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primaryGreen.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.language_rounded,
                          color: AppColors.primaryGreen,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          loc.enrolledLanguageCourse,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          targetLangName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreenDark,
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.swap_horiz_rounded,
                            color: AppColors.primaryGreen,
                          ),
                          tooltip: 'Switch or Enroll in New Language',
                          onSelected: (String langCode) {
                            _switchCourseWithReset(
                              context,
                              ref,
                              langCode,
                              _languages[langCode] ?? langCode,
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
                        side: BorderSide(
                          color: Colors.red.withValues(alpha: 0.5),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(
                        Icons.remove_circle_outline_rounded,
                        size: 18,
                      ),
                      label: Text(loc.unenrollCourse),
                      onPressed: () => _switchCourseWithReset(
                        context,
                        ref,
                        'es',
                        'Spanish 🇪🇸',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.space24),

              // Level Progress Bar
              Text(
                loc.levelProgress(level, level + 1),
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
                loc.xpProgress(xp, nextThreshold),
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: AppConstants.space32),

              // Settings & Admin Panel
              Text(
                loc.settingsTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppConstants.space16),

              // Admin tools accessible to all users.
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AdminPanelScreen(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(AppConstants.radius16),
                child: Container(
                  padding: const EdgeInsets.all(AppConstants.space16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      AppConstants.radius16,
                    ),
                    border: Border.all(color: AppColors.primaryGreen),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.admin_panel_settings_rounded,
                        color: AppColors.primaryGreen,
                        size: 28,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loc.adminPanelTitle,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: AppColors.primaryGreenDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              loc.adminPanelDesc,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.primaryGreen,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.space16),

              _buildTtsSpeedSettings(context, ref),
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
                    Row(
                      children: [
                        const Icon(
                          Icons.headset_mic_rounded,
                          color: AppColors.primaryGreen,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          loc.contactUsSupport,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ContactUsScreen(),
                          ),
                        );
                      },
                      child: Text(loc.contactButton),
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
                        title: Text(loc.logOut),
                        content: const Text(
                          'Are you sure you want to log out?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: Text(loc.logOut),
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
                    loc.logOut,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.space16,
                    ),
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.radius16,
                      ),
                    ),
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

  Widget _buildTtsSpeedSettings(BuildContext context, WidgetRef ref) {
    final ttsSpeed = ref.watch(ttsSpeechRateProvider);
    final safeSpeed = ttsSpeed.clamp(0.225, 0.675);
    final speedLabel = '${(safeSpeed / 0.45).toStringAsFixed(2)}x';

    return Container(
      padding: const EdgeInsets.all(AppConstants.space16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radius16),
        border: Border.all(
          color: AppColors.primaryGreen.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.record_voice_over_rounded,
                    color: AppColors.primaryGreen,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Audio Pronunciation Speed 🔊',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  speedLabel,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreenDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'LinguAI automatically prefers an installed neural or enhanced native voice. Adjust its pace for flashcards and quizzes.',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                '0.5x',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
              Expanded(
                child: Slider(
                  value: safeSpeed,
                  min: 0.225,
                  max: 0.675,
                  divisions: 10,
                  activeColor: AppColors.primaryGreen,
                  label: speedLabel,
                  onChanged: (newRate) {
                    ref.read(ttsSpeechRateProvider.notifier).setRate(newRate);
                  },
                ),
              ),
              const Text(
                '1.5x',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showUnlockPremiumModal(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(
              Icons.workspace_premium_rounded,
              color: Colors.amber,
              size: 32,
            ),
            const SizedBox(width: 8),
            Text(loc.unlockPremiumTitle),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Unlock full access to LinguAI Premium Features for 1 Month:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 14),
            const Text('🤖 Personal AI Language Tutor 24/7'),
            const SizedBox(height: 6),
            const Text('🚫 100% Ad-Free Experience'),
            const SizedBox(height: 6),
            const Text('❤️ Unlimited Hearts Mode (Infinite lives ∞)'),
            const SizedBox(height: 6),
            const Text('⚡ Priority Customer Support Desk'),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              context.push('/payment');
            },
            child: Text(
              loc.proceedToPayment,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings(BuildContext context, WidgetRef ref) {
    final isDesktop =
        Theme.of(context).platform == TargetPlatform.windows ||
        Theme.of(context).platform == TargetPlatform.macOS ||
        Theme.of(context).platform == TargetPlatform.linux;

    final loc = AppLocalizations.of(context)!;
    final label = isDesktop
        ? loc.receiveRemindersDesktop
        : loc.pushNotifications;

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
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  loc.getStreakReminders,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
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
                    final granted = await ref
                        .read(notificationServiceProvider)
                        .requestPermission();
                    if (!context.mounted) return;
                    if (granted) {
                      ref
                          .read(settingsProvider.notifier)
                          .toggleNotifications(true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Notifications enabled!')),
                      );
                    } else {
                      ref
                          .read(settingsProvider.notifier)
                          .toggleNotifications(false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Permission denied.')),
                      );
                    }
                  } else {
                    ref
                        .read(settingsProvider.notifier)
                        .toggleNotifications(false);
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
    final loc = AppLocalizations.of(context)!;

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
                  loc.appInterfaceLanguage,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  loc.switchBetweenEnUr,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
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
            items: [
              DropdownMenuItem(value: 'en', child: Text(loc.englishLanguage)),
              DropdownMenuItem(value: 'ur', child: Text(loc.urduLanguage)),
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
    final loc = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(AppConstants.space16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radius16),
        border: Border.all(
          color: AppColors.primaryGreen.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.timer_rounded, color: AppColors.primaryGreen),
              const SizedBox(width: 8),
              Text(
                loc.studyDurationGoals,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            loc.selectDurationPlan,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),

          // Daily Goal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                loc.dailyGoalLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              DropdownButton<int>(
                value: daily,
                onChanged: (val) async {
                  if (val != null) {
                    await goalStorage.setDailyGoalMinutes(val);
                    ref.invalidate(studyGoalStorageProvider);
                  }
                },
                items: const [
                  DropdownMenuItem(value: 10, child: Text('10 mins / day')),
                  DropdownMenuItem(value: 15, child: Text('15 mins / day')),
                  DropdownMenuItem(value: 30, child: Text('30 mins / day')),
                  DropdownMenuItem(value: 45, child: Text('45 mins / day')),
                ],
              ),
            ],
          ),
          const Divider(height: 16),

          // Weekly Goal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                loc.weeklyTargetLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
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
              Text(
                loc.monthlyTargetLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
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
    final isPremium = ref.watch(premiumStorageProvider);
    final isUnlimited = heartStorage.isUnlimitedMode && isPremium;
    final loc = AppLocalizations.of(context)!;

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
                Row(
                  children: [
                    Text(
                      loc.unlimitedHeartsMode,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isPremium
                            ? Colors.amber.shade100
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isPremium ? 'PREMIUM (∞)' : 'PRO FEATURE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isPremium
                              ? Colors.amber.shade900
                              : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  loc.unlimitedHeartsDesc,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isUnlimited,
            onChanged: (val) async {
              if (val && !isPremium) {
                _showUnlockPremiumModal(context);
                return;
              }
              await heartStorage.setHeartsMode(val ? 'unlimited' : 'challenge');
              ref.invalidate(heartSettingsStorageProvider);
            },
            activeThumbColor: AppColors.primaryGreen,
          ),
        ],
      ),
    );
  }

  Future<void> _switchCourseWithReset(
    BuildContext context,
    WidgetRef ref,
    String newLangCode,
    String langName,
  ) async {
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
            Text('Reset Course Progress? ⚠️'),
          ],
        ),
        content: Text(
          'Warning! Switching or unenrolling your language course to $langName will reset ALL your progress, unlocked lessons, AND saved review flashcards.\n\nAre you sure you want to proceed?',
          style: const TextStyle(fontSize: 14, height: 1.4),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Yes, Reset Everything',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final db = ref.read(databaseProvider);
        await (db.update(
          db.lessons,
        )..where((t) => t.id.isBiggerThanValue(1))).write(
          const LessonsCompanion(
            isCompleted: Value(false),
            isLocked: Value(true),
          ),
        );
        await (db.update(db.lessons)..where((t) => t.id.equals(1))).write(
          const LessonsCompanion(
            isCompleted: Value(false),
            isLocked: Value(false),
          ),
        );
        await db
            .update(db.vocabWords)
            .write(
              const VocabWordsCompanion(
                repetitions: Value(0),
                interval: Value(1),
                easinessFactor: Value(2.5),
                nextReviewDate: Value(null),
                status: Value('learning'),
              ),
            );
      } catch (_) {}

      await onboardingStorage.setTargetLanguage(newLangCode);
      ref.invalidate(progressControllerProvider);
      ref.invalidate(learnRepositoryProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Switched course to $langName! All lessons & SRS review cards reset.',
            ),
            backgroundColor: AppColors.primaryGreen,
          ),
        );
      }
    }
  }

  void _showEditProfileDialog(
    BuildContext context,
    WidgetRef ref,
    String currentName,
  ) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(
              Icons.person_pin_rounded,
              color: AppColors.primaryGreen,
              size: 28,
            ),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                await ref
                    .read(userControllerProvider.notifier)
                    .updateProfile(username: newName);
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text(
              'Save Changes',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
