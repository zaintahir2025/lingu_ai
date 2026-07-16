import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/subscription_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';
import 'package:lingu_ai/l10n/app_localizations.dart';

class ProGate extends ConsumerWidget {
  final Widget child;
  
  const ProGate({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscription = ref.watch(subscriptionProvider);
    final isPro = subscription == SubscriptionTier.pro;

    if (isPro) {
      return child;
    }

    return Stack(
      children: [
        // Background content (blurred)
        Positioned.fill(
          child: IgnorePointer(
            ignoring: true,
            child: child,
          ),
        ),
        
        // Blur effect
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
            child: Container(
              color: Colors.black.withValues(alpha: 0.1),
            ),
          ),
        ),
        
        // Unlock Banner
        Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: AppConstants.space32),
            padding: const EdgeInsets.all(AppConstants.space24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppConstants.radius16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.xpGold.withAlpha(25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_outline,
                    color: AppColors.xpGold,
                    size: 48,
                  ),
                ),
                const SizedBox(height: AppConstants.space16),
                Text(
                  AppLocalizations.of(context)!.unlockProTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.space8),
                Text(
                  AppLocalizations.of(context)!.unlockProDesc,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.space24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(AppConstants.space16),
                      backgroundColor: AppColors.xpGold,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppConstants.radius12),
                      ),
                    ),
                    onPressed: () {
                      // For testing: tapping the button unlocks it.
                      ref.read(subscriptionProvider.notifier).setPro();
                    },
                    child: Text(
                      AppLocalizations.of(context)!.upgradeToPro,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
