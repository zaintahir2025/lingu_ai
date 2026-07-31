import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/responsive/adaptive_scaffold.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:lingu_ai/l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../learn/presentation/screens/learn_tab.dart';
import '../../review/presentation/screens/review_tab.dart';

import '../../progress/presentation/widgets/floating_xp.dart';
import '../../progress/presentation/widgets/level_up_modal.dart';
import '../../progress/presentation/providers/progress_controller.dart';
import '../../progress/presentation/screens/progress_tab.dart';
import '../../progress/presentation/screens/profile_tab.dart';
import '../../tutor/presentation/screens/tutor_tab.dart';

final homeTabProvider = StateProvider<int>((ref) => 0);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(progressControllerProvider, (previous, next) {
      if (next.hasValue) {
        final state = next.value!;
        if (state.hasLevelUp) {
          showLevelUpModal(context, state.progress.level);
          ref.read(progressControllerProvider.notifier).clearFlags();
        } else if (state.addedXp > 0) {
          showFloatingXp(context, state.addedXp);
          ref.read(progressControllerProvider.notifier).clearFlags();
        }
      }
    });

    final selectedIndex = ref.watch(homeTabProvider);

    return AdaptiveScaffold(
      title: 'LinguAI',
      selectedIndex: selectedIndex,
      onNavigationIndexChanged: (index) {
        ref.read(homeTabProvider.notifier).state = index;
      },
      destinations: [
        NavigationDestination(
          icon: SvgPicture.asset('assets/images/svgs/learn.svg', height: 24, colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn)),
          selectedIcon: SvgPicture.asset('assets/images/svgs/learn.svg', height: 28),
          label: AppLocalizations.of(context)!.learnTab,
        ),
        NavigationDestination(
          icon: SvgPicture.asset('assets/images/svgs/quests.svg', height: 24, colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn)),
          selectedIcon: SvgPicture.asset('assets/images/svgs/quests.svg', height: 28),
          label: AppLocalizations.of(context)!.reviewTab,
        ),
        NavigationDestination(
          icon: SvgPicture.asset('assets/images/svgs/mascot.svg', height: 24, colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn)),
          selectedIcon: SvgPicture.asset('assets/images/svgs/mascot.svg', height: 28),
          label: AppLocalizations.of(context)!.tutorTab,
        ),
        NavigationDestination(
          icon: SvgPicture.asset('assets/images/svgs/leaderboard.svg', height: 24, colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn)),
          selectedIcon: SvgPicture.asset('assets/images/svgs/leaderboard.svg', height: 28),
          label: AppLocalizations.of(context)!.progressTab,
        ),
        NavigationDestination(
          icon: const Icon(Icons.person_outline_rounded, size: 26, color: Colors.grey),
          selectedIcon: Icon(Icons.person_rounded, size: 28, color: AppColors.primaryGreen),
          label: AppLocalizations.of(context)!.profileTab,
        ),
      ],
      body: _buildBody(context, selectedIndex),
    );
  }

  Widget _buildBody(BuildContext context, int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return const LearnTab();
      case 1:
        return const ReviewTab();
      case 2:
        return const TutorTab();
      case 3:
        return const ProgressTab();
      case 4:
        return const ProfileTab();
      default:
        return const LearnTab();
    }
  }
}
