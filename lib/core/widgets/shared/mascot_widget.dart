import 'dart:math' as math;
import 'package:flutter/material.dart';

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
    final w = size.width;
    final h = size.height;
    final paint = Paint()..style = PaintingStyle.fill;

    // Colors
    final chassisColor = pose == MascotPose.encouraging
        ? const Color(0xFFFFE8B2)
        : const Color(0xFFD0EBF7);
    final chassisBorder = pose == MascotPose.encouraging
        ? const Color(0xFFF77F00)
        : const Color(0xFF00B0FF);
    final visorColor = const Color(0xFF121926);
    final ledGlow = pose == MascotPose.encouraging
        ? const Color(0xFFFF9F1C)
        : const Color(0xFF00F5D4);

    // 1. Antenna Rod & Orb Top
    paint.color = const Color(0xFF64748B);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.475, h * 0.05, w * 0.05, h * 0.15),
        Radius.circular(w * 0.025),
      ),
      paint,
    );
    paint.color = ledGlow;
    canvas.drawCircle(Offset(w * 0.5, h * 0.06), w * 0.06, paint);
    paint.color = Colors.white;
    canvas.drawCircle(Offset(w * 0.5, h * 0.06), w * 0.025, paint);

    // 2. Ear Bolts (Left & Right)
    paint.color = chassisBorder;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.12, h * 0.38, w * 0.07, h * 0.18),
        Radius.circular(w * 0.035),
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.81, h * 0.38, w * 0.07, h * 0.18),
        Radius.circular(w * 0.035),
      ),
      paint,
    );

    // 3. Robot Head Chassis
    paint.color = chassisColor;
    final headRect = Rect.fromLTWH(w * 0.17, h * 0.18, w * 0.66, h * 0.54);
    canvas.drawRRect(
      RRect.fromRectAndRadius(headRect, Radius.circular(w * 0.18)),
      paint,
    );

    paint.style = PaintingStyle.stroke;
    paint.color = chassisBorder;
    paint.strokeWidth = math.max(1.5, w * 0.02);
    canvas.drawRRect(
      RRect.fromRectAndRadius(headRect, Radius.circular(w * 0.18)),
      paint,
    );

    // 4. Dark Visor Screen
    paint.style = PaintingStyle.fill;
    paint.color = visorColor;
    final visorRect = Rect.fromLTWH(w * 0.24, h * 0.27, w * 0.52, h * 0.36);
    canvas.drawRRect(
      RRect.fromRectAndRadius(visorRect, Radius.circular(w * 0.12)),
      paint,
    );

    // 5. LED Eyes & Expressions
    paint.color = ledGlow;
    if (pose == MascotPose.celebrating) {
      // Star / Curved happy eyes
      final pathLeft = Path()
        ..moveTo(w * 0.35, h * 0.44)
        ..quadraticBezierTo(w * 0.40, h * 0.36, w * 0.45, h * 0.44);
      final pathRight = Path()
        ..moveTo(w * 0.55, h * 0.44)
        ..quadraticBezierTo(w * 0.60, h * 0.36, w * 0.65, h * 0.44);
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = w * 0.035;
      paint.strokeCap = StrokeCap.round;
      canvas.drawPath(pathLeft, paint);
      canvas.drawPath(pathRight, paint);
    } else if (pose == MascotPose.encouraging) {
      // Soft droopy eyes
      final pathLeft = Path()
        ..moveTo(w * 0.35, h * 0.40)
        ..quadraticBezierTo(w * 0.40, h * 0.46, w * 0.45, h * 0.40);
      final pathRight = Path()
        ..moveTo(w * 0.55, h * 0.40)
        ..quadraticBezierTo(w * 0.60, h * 0.46, w * 0.65, h * 0.40);
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = w * 0.035;
      paint.strokeCap = StrokeCap.round;
      canvas.drawPath(pathLeft, paint);
      canvas.drawPath(pathRight, paint);
    } else {
      // Standard glowing oval eyes
      paint.style = PaintingStyle.fill;
      canvas.drawOval(
        Rect.fromCenter(
            center: Offset(w * 0.38, h * 0.42), width: w * 0.09, height: h * 0.12),
        paint,
      );
      canvas.drawOval(
        Rect.fromCenter(
            center: Offset(w * 0.62, h * 0.42), width: w * 0.09, height: h * 0.12),
        paint,
      );
      paint.color = Colors.white;
      canvas.drawCircle(Offset(w * 0.40, h * 0.40), w * 0.02, paint);
      canvas.drawCircle(Offset(w * 0.64, h * 0.40), w * 0.02, paint);
    }

    // 6. LED Smile / Mouth
    paint.color = ledGlow;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = w * 0.025;
    paint.strokeCap = StrokeCap.round;
    final mouthPath = Path();
    if (pose == MascotPose.celebrating || pose == MascotPose.encouraging) {
      mouthPath.moveTo(w * 0.42, h * 0.52);
      mouthPath.quadraticBezierTo(w * 0.50, h * 0.59, w * 0.58, h * 0.52);
    } else {
      mouthPath.moveTo(w * 0.44, h * 0.53);
      mouthPath.quadraticBezierTo(w * 0.50, h * 0.57, w * 0.56, h * 0.53);
    }
    canvas.drawPath(mouthPath, paint);

    // 7. Base Robot Torso & Chest Badge
    paint.style = PaintingStyle.fill;
    paint.color = chassisColor;
    final torsoPath = Path()
      ..moveTo(w * 0.32, h * 0.72)
      ..lineTo(w * 0.68, h * 0.72)
      ..lineTo(w * 0.64, h * 0.90)
      ..quadraticBezierTo(w * 0.50, h * 0.94, w * 0.36, h * 0.90)
      ..close();
    canvas.drawPath(torsoPath, paint);

    paint.color = chassisBorder;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.43, h * 0.77, w * 0.14, h * 0.08),
        Radius.circular(w * 0.04),
      ),
      paint,
    );

    // 8. Hands
    paint.color = chassisBorder;
    if (pose == MascotPose.celebrating) {
      canvas.drawCircle(Offset(w * 0.12, h * 0.58), w * 0.06, paint);
      canvas.drawCircle(Offset(w * 0.88, h * 0.58), w * 0.06, paint);
    } else {
      canvas.drawCircle(Offset(w * 0.12, h * 0.78), w * 0.06, paint);
      canvas.drawCircle(Offset(w * 0.88, h * 0.78), w * 0.06, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MascotPainter oldDelegate) =>
      pose != oldDelegate.pose;
}
