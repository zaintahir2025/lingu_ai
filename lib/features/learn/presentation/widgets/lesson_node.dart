import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/database/database.dart';

class LessonNode extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback onTap;
  final bool isCurrent;

  const LessonNode({
    super.key,
    required this.lesson,
    required this.onTap,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    Widget nodeIcon;
    Color nodeColor;

    if (lesson.isLocked) {
      nodeColor = AppColors.divider;
      nodeIcon = const Icon(Icons.lock, color: Colors.white, size: 32);
    } else if (lesson.isCompleted) {
      nodeColor = const Color(0xFFFFD700); // Gold for completed
      nodeIcon = const Icon(Icons.check, color: Colors.white, size: 40);
    } else {
      nodeColor = AppColors.primaryGreen;
      nodeIcon = const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 48);
    }

    Widget node = GestureDetector(
      onTap: lesson.isLocked ? null : onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: nodeColor,
          boxShadow: [
            BoxShadow(
              color: nodeColor.withAlpha(128),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(child: nodeIcon),
      ),
    );

    if (lesson.isLocked) {
      node = Tooltip(
        message: 'Complete previous lessons to unlock',
        child: node,
      );
    }

    if (isCurrent) {
      node = node.animate(onPlay: (controller) => controller.repeat(reverse: true))
          .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 800.ms);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        node,
        const SizedBox(height: 8),
        Text(
          lesson.topic,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: lesson.isLocked ? AppColors.textSecondary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
