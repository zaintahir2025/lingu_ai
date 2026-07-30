import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final adServiceProvider = Provider<AdService>((ref) {
  return AdService();
});

class AdService {
  bool _isAdEnabled = true;

  bool get isAdEnabled => _isAdEnabled;

  void toggleAds(bool enabled) {
    _isAdEnabled = enabled;
  }

  /// Renders a responsive AdMob Banner Container placeholder
  Widget buildBannerAdContainer(BuildContext context) {
    if (!_isAdEnabled) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.ads_click_rounded, color: Colors.grey, size: 20),
          SizedBox(width: 8),
          Text(
            'Google AdMob Banner (Ad Placeholder)',
            style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  /// Simulates triggering an Interstitial Ad after quiz completion
  void showInterstitialAd(BuildContext context) {
    if (!_isAdEnabled) return;
    
    debugPrint('AdMob: Interstitial Ad triggered for Free tier user.');
  }
}
