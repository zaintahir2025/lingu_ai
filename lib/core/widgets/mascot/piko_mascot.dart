import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum PikoPose { idle, celebrating, thinking, encouraging, sad }

/// The single official LinguAI character used throughout the product.
class PikoMascot extends StatelessWidget {
  const PikoMascot({
    super.key,
    this.pose = PikoPose.idle,
    this.size = 96,
    this.animated = true,
  });

  static const asset = 'assets/images/brand/piko_official_master.png';
  static const _animationDirectory = 'assets/images/brand/animations';

  final PikoPose pose;
  final double size;
  final bool animated;

  @override
  Widget build(BuildContext context) {
    final motionEnabled = animated && !MediaQuery.disableAnimationsOf(context);
    final displayAsset = motionEnabled ? _animatedAsset : asset;

    return Semantics(
      image: true,
      label: _semanticLabel,
      child: Image.asset(
        displayAsset,
        key: ValueKey(displayAsset),
        width: size,
        height: size,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        gaplessPlayback: true,
      ),
    );
  }

  String get _animatedAsset => switch (pose) {
    PikoPose.celebrating => '$_animationDirectory/piko_celebrating.gif',
    PikoPose.thinking => '$_animationDirectory/piko_thinking.gif',
    PikoPose.encouraging => '$_animationDirectory/piko_encouraging.gif',
    PikoPose.sad => '$_animationDirectory/piko_sad.gif',
    PikoPose.idle => '$_animationDirectory/piko_idle.gif',
  };

  String get _semanticLabel => switch (pose) {
    PikoPose.celebrating => 'Piko celebrating your achievement',
    PikoPose.thinking => 'Piko thinking about your question',
    PikoPose.encouraging => 'Piko encouraging you to continue',
    PikoPose.sad => 'Piko offering support after a mistake',
    PikoPose.idle => 'Piko, the LinguAI learning companion',
  };
}

class PikoSpeechBubble extends StatelessWidget {
  const PikoSpeechBubble({
    super.key,
    required this.text,
    this.pose = PikoPose.encouraging,
  });

  final String text;
  final PikoPose pose;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PikoMascot(pose: pose, size: 70),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.35),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.07),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.08, end: 0),
        ),
      ],
    );
  }
}
