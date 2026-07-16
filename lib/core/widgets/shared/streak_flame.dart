import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class StreakFlame extends StatelessWidget {
  final int streakDays;

  const StreakFlame({
    super.key,
    required this.streakDays,
  });

  @override
  Widget build(BuildContext context) {
    final hasStreak = streakDays > 0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.local_fire_department_rounded,
          color: hasStreak ? AppColors.streakOrange : AppColors.textSecondary,
          size: 24,
        ),
        const SizedBox(width: 4),
        Text(
          '$streakDays',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: hasStreak ? AppColors.streakOrange : AppColors.textSecondary,
                fontWeight: FontWeight.w800,
              ),
        ),
      ],
    );
  }
}
