import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

enum MascotPose { idle, celebrating, thinking, encouraging }

class MascotWidget extends StatelessWidget {
  final MascotPose pose;
  final double width;
  final double height;

  const MascotWidget({
    super.key,
    this.pose = MascotPose.idle,
    this.width = 100,
    this.height = 100,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _MascotPainter(pose),
      ),
    );
  }
}

class _MascotPainter extends CustomPainter {
  final MascotPose pose;

  _MascotPainter(this.pose);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    // Simple shape for the mascot (a rounded squircle)
    paint.color = AppColors.primaryGreen;
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(size.width * 0.4)), paint);

    // Eyes
    paint.color = Colors.white;
    canvas.drawCircle(Offset(size.width * 0.35, size.height * 0.4), size.width * 0.1, paint);
    canvas.drawCircle(Offset(size.width * 0.65, size.height * 0.4), size.width * 0.1, paint);

    paint.color = Colors.black87;
    canvas.drawCircle(Offset(size.width * 0.35, size.height * 0.4), size.width * 0.04, paint);
    canvas.drawCircle(Offset(size.width * 0.65, size.height * 0.4), size.width * 0.04, paint);

    // Mouth
    paint.color = AppColors.heartRed;
    if (pose == MascotPose.celebrating || pose == MascotPose.encouraging) {
      canvas.drawArc(
        Rect.fromCenter(center: Offset(size.width * 0.5, size.height * 0.65), width: size.width * 0.3, height: size.height * 0.2),
        0, 3.14, true, paint,
      );
    } else {
      // Idle or thinking
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 3;
      canvas.drawArc(
        Rect.fromCenter(center: Offset(size.width * 0.5, size.height * 0.65), width: size.width * 0.2, height: size.height * 0.1),
        0, 3.14, false, paint,
      );
    }

    // Decorators based on pose
    if (pose == MascotPose.celebrating) {
      paint.style = PaintingStyle.fill;
      paint.color = AppColors.xpGold;
      // Simple star above head
      canvas.drawCircle(Offset(size.width * 0.5, size.height * -0.1), size.width * 0.1, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MascotPainter oldDelegate) => pose != oldDelegate.pose;
}
