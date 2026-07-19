import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_constants.dart';

class AchievementOverlay {
  static void show(BuildContext context, {required String title, required String description, IconData icon = Icons.emoji_events}) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned.directional(
          textDirection: Directionality.of(context),
          top: 50,
          start: 16,
          end: 16,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(AppConstants.space16),
              decoration: BoxDecoration(
                color: AppColors.xpGold,
                borderRadius: BorderRadius.circular(AppConstants.radius16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: AppColors.xpGold, size: 32),
                  ),
                  const SizedBox(width: AppConstants.space16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Achievement Unlocked!',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          description,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
            .animate(onComplete: (controller) async {
              // Wait 3 seconds, then reverse animation and remove overlay
              await Future.delayed(const Duration(seconds: 3));
              if (overlayEntry.mounted) {
                controller.reverse().then((_) => overlayEntry.remove());
              }
            })
            .slideY(begin: -2.0, end: 0, duration: 600.ms, curve: Curves.bounceOut)
            .fadeIn(duration: 400.ms),
          ),
        );
      },
    );

    overlay.insert(overlayEntry);
  }
}
