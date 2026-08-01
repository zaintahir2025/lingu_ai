import 'package:flutter/material.dart';

class PremiumBadge extends StatelessWidget {
  final double fontSize;
  final EdgeInsetsGeometry padding;

  const PremiumBadge({
    super.key,
    this.fontSize = 11,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.amber,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'PREMIUM 👑',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
