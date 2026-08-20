import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Duolingo-styled 4-bar Spaced Repetition Word Memory Strength Meter
class DuolingoWordStrengthMeter extends StatelessWidget {
  final int strength; // 1 to 4 bars

  const DuolingoWordStrengthMeter({
    super.key,
    required this.strength,
  });

  @override
  Widget build(BuildContext context) {
    final activeCount = strength.clamp(1, 4);

    final color = switch (activeCount) {
      1 => AppColors.heartRed,
      2 => AppColors.streakOrange,
      3 => AppColors.gemBlue,
      _ => AppColors.primaryGreen,
    };

    final label = switch (activeCount) {
      1 => 'Needs Review',
      2 => 'Getting Stronger',
      3 => 'Strong Memory',
      _ => 'Mastered',
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAlignment.end,
          children: List.generate(4, (index) {
            final isFilled = index < activeCount;
            final height = 8.0 + (index * 4.0);

            return Container(
              margin: const EdgeInsets.only(right: 3),
              width: 6,
              height: height,
              decoration: BoxDecoration(
                color: isFilled ? color : AppColors.divider,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
