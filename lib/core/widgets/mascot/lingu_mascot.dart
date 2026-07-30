import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum MascotPose { idle, celebrating, thinking, encouraging, sad, bad }

class LinguMascot extends StatelessWidget {
  final MascotPose pose;
  final double size;

  const LinguMascot({
    super.key,
    this.pose = MascotPose.idle,
    this.size = 100.0,
  });

  @override
  Widget build(BuildContext context) {
    String assetPath = 'assets/images/svgs/mascot.svg';
    
    // Map poses to SVGs
    if (pose == MascotPose.sad || pose == MascotPose.encouraging) {
      assetPath = 'assets/images/svgs/mascot_sad.svg';
    } else if (pose == MascotPose.bad) {
      assetPath = 'assets/images/svgs/mascot_bad.svg';
    }
    
    return SvgPicture.asset(
      assetPath,
      height: size,
      width: size,
    );
  }
}
