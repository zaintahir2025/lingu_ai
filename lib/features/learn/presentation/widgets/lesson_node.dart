import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/database/database.dart';
import '../../../../core/audio/sound_service.dart';

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
    Gradient nodeGradient;
    Color shadowColor;
    Color borderShadow;

    if (lesson.isLocked) {
      nodeGradient = const LinearGradient(
        colors: [Color(0xFFCBD5E1), Color(0xFF94A3B8)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      shadowColor = const Color(0xFF64748B);
      borderShadow = const Color(0xFF64748B);
      nodeIcon = const Icon(Icons.lock_rounded, color: Colors.white, size: 30);
    } else if (lesson.isCompleted) {
      nodeGradient = const LinearGradient(
        colors: [Color(0xFFFBBF24), Color(0xFFD97706)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      shadowColor = const Color(0xFFB45309);
      borderShadow = const Color(0xFFB45309);
      nodeIcon = const Icon(Icons.star_rounded, color: Colors.white, size: 42);
    } else {
      nodeGradient = const LinearGradient(
        colors: [Color(0xFF10B981), Color(0xFF059669)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      shadowColor = const Color(0xFF047857);
      borderShadow = const Color(0xFF047857);
      nodeIcon = const Icon(
        Icons.play_arrow_rounded,
        color: Colors.white,
        size: 48,
      );
    }

    Widget nodeCore = Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: nodeGradient,
        boxShadow: [
          BoxShadow(
            color: shadowColor.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: borderShadow,
            blurRadius: 0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(child: nodeIcon),
    );

    if (isCurrent) {
      nodeCore = Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primaryGreen,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGreen.withValues(alpha: 0.3),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: nodeCore,
      )
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .scale(
            begin: const Offset(1, 1),
            end: const Offset(1.08, 1.08),
            duration: 900.ms,
            curve: Curves.easeInOut,
          );
    }

    return GestureDetector(
      onTap: () {
        if (!lesson.isLocked) {
          SoundService.playTap();
          onTap();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isCurrent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGreen.withValues(alpha: 0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Text(
                'START',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          nodeCore,
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: lesson.isLocked
                  ? AppColors.surface
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: lesson.isLocked ? AppColors.divider : AppColors.primaryGreen.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: Text(
              lesson.topic,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: lesson.isLocked
                    ? AppColors.textSecondary
                    : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
