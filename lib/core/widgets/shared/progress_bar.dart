import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';

class ProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final Color? color;

  const ProgressBar({
    super.key,
    required this.progress,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16,
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(AppConstants.radiusRound),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: constraints.maxWidth * progress.clamp(0.0, 1.0),
                decoration: BoxDecoration(
                  color: color ?? AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(AppConstants.radiusRound),
                ),
              ),
              // Highlight effect
              if (progress > 0.1)
                Positioned(
                  top: 4,
                  left: 8,
                  right: constraints.maxWidth * (1 - progress) + 8,
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(76),
                      borderRadius: BorderRadius.circular(AppConstants.radiusRound),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
