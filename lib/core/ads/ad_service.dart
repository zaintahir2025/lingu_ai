import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../storage/premium_storage.dart';
import 'banner_ad_widget.dart';

final adServiceProvider = Provider<AdService>((ref) {
  final service = AdService(enabled: !ref.watch(premiumStorageProvider));
  unawaited(service.preloadInterstitial());
  ref.onDispose(service.dispose);
  return service;
});

class AdService {
  AdService({required this.enabled});

  final bool enabled;
  InterstitialAd? _interstitialAd;
  bool _isLoadingInterstitial = false;

  bool get isSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  Widget buildBannerAdContainer(BuildContext context) =>
      const BannerAdWidget(placement: AdPlacement.learnHome);

  Widget buildLessonAdBanner(BuildContext context) =>
      const BannerAdWidget(placement: AdPlacement.vocabulary);

  Widget buildReviewAdBanner(BuildContext context) =>
      const BannerAdWidget(placement: AdPlacement.review);

  Future<bool> showInterstitialAd() async {
    if (!enabled || !isSupported) return false;

    final ad = _interstitialAd ?? await _loadInterstitial();
    if (ad == null) return false;

    _interstitialAd = null;
    final completer = Completer<bool>();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (shownAd) {
        shownAd.dispose();
        if (!completer.isCompleted) completer.complete(true);
        unawaited(_loadInterstitial());
      },
      onAdFailedToShowFullScreenContent: (shownAd, error) {
        shownAd.dispose();
        if (!completer.isCompleted) completer.complete(false);
        unawaited(_loadInterstitial());
      },
    );
    ad.show();
    return completer.future;
  }

  Future<void> preloadInterstitial() async {
    await _loadInterstitial();
  }

  Future<InterstitialAd?> _loadInterstitial() async {
    if (_isLoadingInterstitial || !enabled || !isSupported) {
      return _interstitialAd;
    }

    final adUnitId = _interstitialAdUnitId;
    if (adUnitId.isEmpty) return null;

    _isLoadingInterstitial = true;
    final completer = Completer<InterstitialAd?>();
    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _isLoadingInterstitial = false;
          _interstitialAd = ad;
          completer.complete(ad);
        },
        onAdFailedToLoad: (error) {
          _isLoadingInterstitial = false;
          debugPrint('AdMob interstitial failed to load: $error');
          completer.complete(null);
        },
      ),
    );
    return completer.future;
  }

  String get _interstitialAdUnitId {
    if (defaultTargetPlatform == TargetPlatform.android) {
      const production = String.fromEnvironment(
        'ADMOB_ANDROID_INTERSTITIAL_ID',
      );
      return production.isNotEmpty || kReleaseMode
          ? production
          : 'ca-app-pub-3940256099942544/1033173712';
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      const production = String.fromEnvironment('ADMOB_IOS_INTERSTITIAL_ID');
      return production.isNotEmpty || kReleaseMode
          ? production
          : 'ca-app-pub-3940256099942544/4411468910';
    }
    return '';
  }

  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }
}
