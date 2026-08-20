import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'screen_size.dart';
import '../theme/app_colors.dart';

import '../network/connectivity_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../game_state/heart_settings_storage.dart';
import '../storage/premium_storage.dart';
import '../game_state/game_state_provider.dart';
import '../providers/target_language_provider.dart';
import '../widgets/mascot/piko_mascot.dart';
import '../audio/sound_service.dart';

class AdaptiveScaffold extends ConsumerWidget {
  final Widget body;
  final String title;
  final List<NavigationDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onNavigationIndexChanged;

  const AdaptiveScaffold({
    super.key,
    required this.body,
    required this.title,
    required this.destinations,
    required this.selectedIndex,
    required this.onNavigationIndexChanged,
  });

  void _showCoursePickerSheet(BuildContext context, WidgetRef ref) {
    final currentLang = ref.read(targetLanguageProvider);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 24.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Language Courses 🌍',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Select a language course to learn. Switching will update your active course.',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 16),
                ...TargetLanguages.languages.entries.map((entry) {
                  final code = entry.key;
                  final name = entry.value;
                  final isSelected = code == currentLang;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryGreen.withAlpha(20)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryGreen
                            : AppColors.divider,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: ListTile(
                      leading: Text(
                        TargetLanguages.getFlag(code),
                        style: const TextStyle(fontSize: 28),
                      ),
                      title: Text(
                        name,
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? AppColors.primaryGreen
                              : AppColors.textPrimary,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.primaryGreen,
                            )
                          : const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                              color: Colors.grey,
                            ),
                      onTap: () async {
                        Navigator.pop(context);
                        if (code == currentLang) return;

                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: const Row(
                              children: [
                                Icon(
                                  Icons.swap_horizontal_circle_rounded,
                                  color: AppColors.primaryGreen,
                                  size: 28,
                                ),
                                SizedBox(width: 8),
                                Text('Switch Course?'),
                              ],
                            ),
                            content: Text(
                              'Switching course to $name will reset unlocked lessons & flashcards for the new course.\n\nDo you want to proceed?',
                              style: const TextStyle(fontSize: 14),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryGreen,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text(
                                  'Switch Course',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await ref
                              .read(targetLanguageProvider.notifier)
                              .switchLanguage(code);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Course switched to $name!'),
                                backgroundColor: AppColors.primaryGreen,
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = ScreenSizeHelper.getSize(context);
    final gameState = ref.watch(gameStateProvider);
    final heartStorage = ref.watch(heartSettingsStorageProvider);
    final isPremium = ref.watch(premiumStorageProvider);
    final isUnlimited = heartStorage.isUnlimitedMode && isPremium;
    final targetLang = ref.watch(targetLanguageProvider);

    final actions = [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset('assets/images/svgs/points.svg', height: 22),
            const SizedBox(width: 4),
            Text(
              gameState.xp.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(width: 12),
            Icon(
                  Icons.local_fire_department,
                  color: gameState.streak > 0
                      ? AppColors.streakOrange
                      : Colors.grey,
                )
                .animate(target: gameState.streak > 0 ? 1 : 0)
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.2, 1.2),
                  duration: 1.seconds,
                  curve: Curves.easeInOut,
                )
                .then()
                .scale(
                  begin: const Offset(1.2, 1.2),
                  end: const Offset(1, 1),
                  duration: 1.seconds,
                  curve: Curves.easeInOut,
                ),
            const SizedBox(width: 4),
            Text(
              gameState.streak.toString(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: gameState.streak > 0
                    ? AppColors.streakOrange
                    : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 12),
            SvgPicture.asset('assets/images/svgs/heart.svg', height: 22),
            const SizedBox(width: 4),
            Text(
              isUnlimited ? '∞' : gameState.hearts.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
                fontSize: isUnlimited ? 20 : 14,
              ),
            ),
          ],
        ),
      ),
    ];

    final isOnline = ref.watch(connectivityProvider).value ?? true;

    Widget bodyWithBanner = Stack(
      children: [
        body,
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          top: isOnline ? -100 : 0,
          left: 0,
          right: 0,
          child: Material(
            color: AppColors.heartRed,
            elevation: 4,
            child: SafeArea(
              bottom: false,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                alignment: Alignment.center,
                child: const Text(
                  'You are offline. Progress is saved locally.',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );

    Widget appBarTitle = Row(
      children: [
        GestureDetector(
          onTap: () {
            SoundService.playTap();
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                backgroundColor: AppColors.surface,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const PikoMascot(size: 80, pose: PikoPose.encouraging)
                        .animate()
                        .shake(duration: 400.ms, hz: 4),
                    const SizedBox(height: 16),
                    const Text(
                      '🐥 Piko Mascot',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primaryGreen),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '"Consistency is key! Just 5 minutes a day builds fluency fast. You got this! 🚀"',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrimary),
                    ),
                  ],
                ),
                actions: [
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('LET\'S LEARN! ⚡', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
          child: const PikoMascot(size: 34)
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 1500.ms),
        ),
        const SizedBox(width: 6),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        InkWell(
          onTap: () => _showCoursePickerSheet(context, ref),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primaryGreen.withAlpha(120),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  TargetLanguages.getFlag(targetLang),
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 2),
                const Icon(
                  Icons.arrow_drop_down_rounded,
                  size: 20,
                  color: AppColors.primaryGreen,
                ),
              ],
            ),
          ),
        ),
      ],
    );

    if (screenSize.isMobile) {
      return Scaffold(
        appBar: AppBar(title: appBarTitle, actions: actions),
        body: bodyWithBanner,
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: onNavigationIndexChanged,
          destinations: destinations,
          backgroundColor: AppColors.surface,
          indicatorColor: AppColors.primaryGreen.withAlpha(51),
        ),
      );
    } else {
      // Tablet and Desktop -> Side rail
      return Scaffold(
        appBar: AppBar(title: appBarTitle, actions: actions),
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: onNavigationIndexChanged,
              labelType: screenSize.isDesktop
                  ? null
                  : NavigationRailLabelType.all,
              destinations: destinations.map((d) {
                return NavigationRailDestination(
                  icon: d.icon,
                  selectedIcon: d.selectedIcon,
                  label: Text(d.label),
                );
              }).toList(),
              backgroundColor: AppColors.surface,
              indicatorColor: AppColors.primaryGreen.withAlpha(51),
              extended: screenSize.isDesktop,
              minExtendedWidth: 200,
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: bodyWithBanner),
          ],
        ),
      );
    }
  }
}
