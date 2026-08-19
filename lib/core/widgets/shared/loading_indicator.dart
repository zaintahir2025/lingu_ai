import 'package:flutter/material.dart';
import '../mascot/piko_mascot.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: PikoMascot(pose: PikoPose.celebrating, size: 80),
    );
  }
}
