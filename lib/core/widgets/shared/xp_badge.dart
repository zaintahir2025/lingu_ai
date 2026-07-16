import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class XpBadge extends StatelessWidget {
  final int amount;

  const XpBadge({
    super.key,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.stars_rounded, color: AppColors.xpGold, size: 24),
        const SizedBox(width: 4),
        Text(
          '$amount XP',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.xpGold,
                fontWeight: FontWeight.w800,
              ),
        ),
      ],
    );
  }
}
