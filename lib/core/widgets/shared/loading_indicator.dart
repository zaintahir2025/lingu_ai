import 'package:flutter/material.dart';
import '../mascot/lingu_mascot.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: LinguMascot(
        pose: MascotPose.celebrating,
        size: 80.0,
      ),
    );
  }
}
