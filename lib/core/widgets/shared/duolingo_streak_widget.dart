import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class DuolingoStreakWidget extends StatefulWidget {
  final int streakCount;
  final bool hasStreakFreeze;
  final List<bool> weeklyActivity; // 7 booleans for Mon-Sun

  const DuolingoStreakWidget({
    super.key,
    required this.streakCount,
    this.hasStreakFreeze = true,
    this.weeklyActivity = const [true, true, true, true, true, false, false],
  });

  @override
  State<DuolingoStreakWidget> createState() => _DuolingoStreakWidgetState();
}

class _DuolingoStreakWidgetState extends State<DuolingoStreakWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _flameController;
  late Animation<double> _scaleAnimation;

  final List<String> _weekDays = const ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  void initState() {
    super.initState();
    _flameController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.1).animate(
      CurvedAnimation(parent: _flameController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _flameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.streakOrange.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.streakOrange.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF3E0),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.local_fire_department_rounded,
                    color: AppColors.streakOrange,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.streakCount} Day Streak!',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Complete a lesson today to keep it alive!',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.hasStreakFreeze)
                Tooltip(
                  message: 'Streak Freeze Active 🧊',
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.lightBlue.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.lightBlue),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.ac_unit_rounded,
                          size: 14,
                          color: Colors.lightBlue,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '1 Freeze',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                final isActive =
                    index < widget.weeklyActivity.length &&
                    widget.weeklyActivity[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      Text(
                        _weekDays[index],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isActive
                              ? AppColors.streakOrange
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive
                              ? AppColors.streakOrange
                              : AppColors.divider.withValues(alpha: 0.5),
                        ),
                        child: isActive
                            ? const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 16,
                              )
                            : null,
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
