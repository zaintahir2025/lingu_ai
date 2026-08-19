import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../storage/premium_storage.dart';

enum AdPlacement { learnHome, vocabulary, review }

class BannerAdWidget extends ConsumerStatefulWidget {
  const BannerAdWidget({super.key, required this.placement});

  final AdPlacement placement;

  @override
  ConsumerState<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends ConsumerState<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  bool get _isSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bannerAd == null && _isSupported) _loadAd();
  }

  void _loadAd() {
    final adUnitId = _adUnitId;
    if (adUnitId.isEmpty) return;

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _isLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _bannerAd = null;
          debugPrint('AdMob banner failed to load: $error');
        },
      ),
    )..load();
  }

  String get _adUnitId {
    if (defaultTargetPlatform == TargetPlatform.android) {
      const production = String.fromEnvironment('ADMOB_ANDROID_BANNER_ID');
      return production.isNotEmpty || kReleaseMode
          ? production
          : 'ca-app-pub-3940256099942544/6300978111';
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      const production = String.fromEnvironment('ADMOB_IOS_BANNER_ID');
      return production.isNotEmpty || kReleaseMode
          ? production
          : 'ca-app-pub-3940256099942544/2934735716';
    }
    return '';
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(premiumStorageProvider) || !_isSupported || !_isLoaded) {
      return const SizedBox.shrink();
    }

    final ad = _bannerAd;
    if (ad == null) return const SizedBox.shrink();

    return Semantics(
      label: 'Sponsored advertisement',
      child: SafeArea(
        minimum: const EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: SizedBox(
            width: ad.size.width.toDouble(),
            height: ad.size.height.toDouble(),
            child: AdWidget(ad: ad),
          ),
        ),
      ),
    );
  }
}
