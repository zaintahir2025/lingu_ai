import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';

void showFloatingXp(BuildContext context, int amount) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) {
      return Positioned(
        top: MediaQuery.of(context).size.height * 0.2, // 20% down from top
        left: 0,
        right: 0,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Text(
              '+$amount XP',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: AppColors.xpGold,
                fontWeight: FontWeight.bold,
                shadows: [
                  const Shadow(
                    color: Colors.white,
                    blurRadius: 10,
                  ),
                ],
              ),
            )
            .animate(onComplete: (controller) {
              entry.remove();
            })
            .fadeIn(duration: 300.ms)
            .slideY(begin: 0.5, end: -0.5, duration: 1500.ms, curve: Curves.easeOut)
            .fadeOut(delay: 1000.ms, duration: 500.ms),
          ),
        ),
      );
    },
  );

  overlay.insert(entry);
}
