import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'screen_size.dart';
import '../theme/app_colors.dart';
import '../../features/progress/presentation/providers/progress_controller.dart';
import '../network/connectivity_provider.dart';

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = ScreenSizeHelper.getSize(context);
    final progressState = ref.watch(progressControllerProvider);

    int currentStreak = 0;
    if (progressState is AsyncData && progressState.value != null) {
      currentStreak = progressState.value!.progress.currentStreak;
    }

    final actions = [
      Padding(
        padding: const EdgeInsetsDirectional.only(end: 16.0),
        child: Row(
          children: [
            Icon(
              Icons.local_fire_department,
              color: currentStreak > 0 ? AppColors.streakOrange : Colors.grey,
            ).animate(target: currentStreak > 0 ? 1 : 0).scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 1.seconds, curve: Curves.easeInOut).then().scale(begin: const Offset(1.2, 1.2), end: const Offset(1, 1), duration: 1.seconds, curve: Curves.easeInOut),
            const SizedBox(width: 4),
            Text(
              currentStreak.toString(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: currentStreak > 0 ? AppColors.streakOrange : Colors.grey,
                fontWeight: FontWeight.bold,
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
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                alignment: Alignment.center,
                child: const Text(
                  'You are offline. Progress is saved locally.',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ],
    );

    if (screenSize.isMobile) {
      return Scaffold(
        appBar: AppBar(title: Text(title), actions: actions),
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
        appBar: AppBar(title: Text(title), actions: actions),
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: onNavigationIndexChanged,
              labelType: NavigationRailLabelType.none,
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
