import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

enum MascotPose { idle, celebrating, thinking, encouraging }

class LinguMascot extends StatefulWidget {
  final MascotPose pose;
  final double size;

  const LinguMascot({
    super.key,
    this.pose = MascotPose.idle,
    this.size = 100.0,
  });

  @override
  State<LinguMascot> createState() => _LinguMascotState();
}

class _LinguMascotState extends State<LinguMascot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _MascotPainter(widget.pose, _controller.value),
        );
      },
    );
  }
}

class _MascotPainter extends CustomPainter {
  final MascotPose pose;
  final double animationValue;

  _MascotPainter(this.pose, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..style = PaintingStyle.fill;

    // Body (Geometric Blob / Rounded Star)
    paint.color = AppColors.primaryGreen;
    

    final radius = size.width * 0.4;
    
    // Draw a playful rounded body
    final bodyOffset = pose == MascotPose.celebrating 
        ? Offset(0, -animationValue * 10) 
        : Offset(0, 0);

    final rect = Rect.fromCenter(
      center: center + bodyOffset, 
      width: radius * 2, 
      height: radius * 2
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(radius * 0.6)),
      paint,
    );

    // Eyes
    paint.color = Colors.white;
    final eyeRadius = radius * 0.2;
    
    double leftEyeY = center.dy - radius * 0.2 + bodyOffset.dy;
    double rightEyeY = center.dy - radius * 0.2 + bodyOffset.dy;
    
    if (pose == MascotPose.thinking) {
      leftEyeY -= 5;
      rightEyeY += 5;
    }

    canvas.drawCircle(Offset(center.dx - radius * 0.4, leftEyeY), eyeRadius, paint);
    canvas.drawCircle(Offset(center.dx + radius * 0.4, rightEyeY), eyeRadius, paint);

    // Pupils
    paint.color = AppColors.textPrimary;
    final pupilRadius = eyeRadius * 0.4;
    canvas.drawCircle(Offset(center.dx - radius * 0.4, leftEyeY), pupilRadius, paint);
    canvas.drawCircle(Offset(center.dx + radius * 0.4, rightEyeY), pupilRadius, paint);

    // Mouth
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = size.width * 0.05;
    paint.strokeCap = StrokeCap.round;
    
    final mouthPath = Path();
    if (pose == MascotPose.idle) {
      mouthPath.moveTo(center.dx - radius * 0.2, center.dy + radius * 0.3 + bodyOffset.dy);
      mouthPath.quadraticBezierTo(
        center.dx, center.dy + radius * 0.4 + bodyOffset.dy,
        center.dx + radius * 0.2, center.dy + radius * 0.3 + bodyOffset.dy
      );
    } else if (pose == MascotPose.celebrating || pose == MascotPose.encouraging) {
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(Offset(center.dx, center.dy + radius * 0.4 + bodyOffset.dy), radius * 0.15, paint);
    } else if (pose == MascotPose.thinking) {
      mouthPath.moveTo(center.dx - radius * 0.1, center.dy + radius * 0.3 + bodyOffset.dy);
      mouthPath.lineTo(center.dx + radius * 0.1, center.dy + radius * 0.3 + bodyOffset.dy);
    }
    
    if (paint.style == PaintingStyle.stroke) {
      canvas.drawPath(mouthPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MascotPainter oldDelegate) {
    return oldDelegate.pose != pose || oldDelegate.animationValue != animationValue;
  }
}
