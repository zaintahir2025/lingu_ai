import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_constants.dart';
import '../../../../core/widgets/shared/mascot_widget.dart';
import '../../../../core/widgets/shared/primary_button.dart';

class LevelUpModal extends StatefulWidget {
  final int newLevel;

  const LevelUpModal({super.key, required this.newLevel});

  @override
  State<LevelUpModal> createState() => _LevelUpModalState();
}

class _LevelUpModalState extends State<LevelUpModal> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppConstants.space24),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Confetti emitter
          Positioned(
            top: -100,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                AppColors.xpGold,
                AppColors.primaryGreen,
                AppColors.streakOrange,
                AppColors.heartRed,
              ],
            ),
          ),
          
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppConstants.space32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.radius32),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const MascotWidget(
                  pose: MascotPose.celebrating,
                  width: 150,
                  height: 150,
                ).animate().scale(delay: 200.ms, duration: 600.ms, curve: Curves.elasticOut),
                const SizedBox(height: AppConstants.space24),
                Text(
                  'Level Up!',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppColors.xpGold,
                    fontWeight: FontWeight.bold,
                  ),
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.5),
                const SizedBox(height: AppConstants.space8),
                Text(
                  'You reached Level ${widget.newLevel}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.5),
                const SizedBox(height: AppConstants.space32),
                PrimaryButton(
                  text: 'Awesome!',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ).animate().fadeIn(delay: 800.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void showLevelUpModal(BuildContext context, int newLevel) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => LevelUpModal(newLevel: newLevel),
  );
}
