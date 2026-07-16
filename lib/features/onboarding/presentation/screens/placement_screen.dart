import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/mascot/lingu_mascot.dart';
import '../../../../core/widgets/shared/primary_button.dart';
import '../../../../core/widgets/shared/app_card.dart';
import 'package:lingu_ai/l10n/app_localizations.dart';

class PlacementScreen extends StatefulWidget {
  const PlacementScreen({super.key});

  @override
  State<PlacementScreen> createState() => _PlacementScreenState();
}

class _PlacementScreenState extends State<PlacementScreen> {
  int _currentQuestionIndex = 0;
  final int _totalQuestions = 10;
  MascotPose _mascotPose = MascotPose.thinking;
  
  void _answerQuestion() async {
    setState(() {
      _mascotPose = MascotPose.celebrating;
    });
    
    await Future.delayed(const Duration(milliseconds: 1000));
    
    if (_currentQuestionIndex < _totalQuestions - 1) {
      setState(() {
        _currentQuestionIndex++;
        _mascotPose = MascotPose.thinking;
      });
    } else {
      if (mounted) {
        context.push('/onboarding/results');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textSecondary),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: List.generate(_totalQuestions, (index) {
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                height: 8,
                decoration: BoxDecoration(
                  color: index <= _currentQuestionIndex 
                      ? AppColors.primaryGreen 
                      : AppColors.divider,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: AppCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LinguMascot(pose: _mascotPose, size: 120),
                  const SizedBox(height: 32),
                  Text(
                    AppLocalizations.of(context)!.placementQuestionTitle(_currentQuestionIndex + 1),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.placementSelectTranslation,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ...List.generate(3, (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: PrimaryButton(
                      text: AppLocalizations.of(context)!.placementOptionTitle(index + 1),
                      isSecondary: true,
                      onPressed: _answerQuestion,
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
