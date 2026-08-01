import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/premium_storage.dart';
import '../../features/admin/presentation/screens/admin_panel_screen.dart';
import 'ad_service.dart';

class BannerAdWidget extends ConsumerWidget {
  const BannerAdWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(premiumStorageProvider).isPremium;
    final adminState = ref.watch(adminSettingsProvider);

    // Premium members DO NOT see ads. Ads only show for Free tier if enabled by Admin.
    if (isPremium || !adminState.adsEnabled) {
      return const SizedBox.shrink();
    }

    final adService = ref.watch(adServiceProvider);
    return adService.buildBannerAdContainer(context);
  }
}
