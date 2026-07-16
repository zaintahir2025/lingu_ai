import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SubscriptionTier { free, pro }

class SubscriptionNotifier extends Notifier<SubscriptionTier> {
  @override
  SubscriptionTier build() {
    // Default to free for testing Pro gating.
    // In a real app, this would be fetched from RevenueCat/purchases.
    return SubscriptionTier.free;
  }

  void toggleSubscription() {
    state = state == SubscriptionTier.free 
        ? SubscriptionTier.pro 
        : SubscriptionTier.free;
  }

  void setPro() {
    state = SubscriptionTier.pro;
  }

  void setFree() {
    state = SubscriptionTier.free;
  }
}

final subscriptionProvider = NotifierProvider<SubscriptionNotifier, SubscriptionTier>(() {
  return SubscriptionNotifier();
});
