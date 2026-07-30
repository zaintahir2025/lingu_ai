import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ad_service.dart';

class BannerAdWidget extends ConsumerWidget {
  const BannerAdWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adService = ref.watch(adServiceProvider);
    return adService.buildBannerAdContainer(context);
  }
}
