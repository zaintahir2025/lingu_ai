import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../local_storage/local_storage_provider.dart';

final onboardingStorageProvider = Provider<OnboardingStorage>((ref) {
  final box = ref.watch(localStorageProvider);
  return OnboardingStorage(box);
});

class OnboardingStorage {
  final Box _box;
  static const String _onboardingCompleteKey = 'onboarding_complete';
  static const String _lastOnboardingRouteKey = 'last_onboarding_route';

  OnboardingStorage(this._box);

  bool get hasCompletedOnboarding => _box.get(_onboardingCompleteKey, defaultValue: false) as bool;

  String? get lastOnboardingRoute => _box.get(_lastOnboardingRouteKey) as String?;

  Future<void> setCompletedOnboarding() async {
    await _box.put(_onboardingCompleteKey, true);
    await _box.delete(_lastOnboardingRouteKey);
  }

  Future<void> setLastOnboardingRoute(String route) async {
    await _box.put(_lastOnboardingRouteKey, route);
  }

  Future<void> resetOnboarding() async {
    await _box.delete(_onboardingCompleteKey);
    await _box.delete(_lastOnboardingRouteKey);
  }
}
