import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/flashcard_view.dart';
import '../../../quiz/presentation/widgets/quiz_view.dart';
import '../../../quiz/presentation/widgets/module_scoreboard_view.dart';
import '../../../quiz/presentation/providers/quiz_controller.dart';
import '../../../../core/theme/app_colors.dart';

import '../../../quiz/presentation/widgets/word_matching_exercise_view.dart';

enum ModuleStage {
  flashcards,
  wordMatching,
  finalQuiz,
  scoreboard,
}

class ModuleFlowScreen extends ConsumerStatefulWidget {
  final int lessonId;

  const ModuleFlowScreen({super.key, required this.lessonId});

  @override
  ConsumerState<ModuleFlowScreen> createState() => _ModuleFlowScreenState();
}

class _ModuleFlowScreenState extends ConsumerState<ModuleFlowScreen> {
  ModuleStage _currentStage = ModuleStage.flashcards;
  double _finalScore = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(quizControllerProvider(widget.lessonId).notifier).restartQuiz();
    });
  }

  void _advanceStage() {
    setState(() {
      switch (_currentStage) {
        case ModuleStage.flashcards:
          _currentStage = ModuleStage.wordMatching;
          break;
        case ModuleStage.wordMatching:
          _currentStage = ModuleStage.finalQuiz;
          ref.read(quizControllerProvider(widget.lessonId).notifier).restartQuiz();
          break;
        case ModuleStage.finalQuiz:
          _currentStage = ModuleStage.scoreboard;
          break;
        case ModuleStage.scoreboard:
          break;
      }
    });
  }

  void _onFinalQuizComplete(double score) {
    _finalScore = score;
    _advanceStage();
  }

  void _onRetry() {
    ref.read(quizControllerProvider(widget.lessonId).notifier).restartQuiz();
    setState(() {
      _currentStage = ModuleStage.wordMatching;
      _finalScore = 0.0;
    });
  }

  void _onFinish() {
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    switch (_currentStage) {
      case ModuleStage.flashcards:
        content = FlashcardView(
          lessonId: widget.lessonId,
          onComplete: _advanceStage,
        );
        break;
      case ModuleStage.wordMatching:
        content = WordMatchingExerciseView(
          lessonId: widget.lessonId,
          onComplete: _advanceStage,
        );
        break;
      case ModuleStage.finalQuiz:
        content = QuizView(
          lessonId: widget.lessonId,
          isPractice: false,
          onComplete: _onFinalQuizComplete,
        );
        break;
      case ModuleStage.scoreboard:
        content = ModuleScoreboardView(
          lessonId: widget.lessonId,
          score: _finalScore,
          onRetry: _onRetry,
          onContinue: _onFinish,
        );
        break;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _currentStage != ModuleStage.scoreboard
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close, color: AppColors.textPrimary),
                onPressed: () => context.go('/'),
              ),
              title: Text(
                _getStageTitle(),
                style: const TextStyle(color: AppColors.textPrimary),
              ),
              centerTitle: true,
            )
          : null,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: content,
        ),
      ),
    );
  }

  String _getStageTitle() {
    switch (_currentStage) {
      case ModuleStage.flashcards:
        return 'Stage 1: Vocabulary';
      case ModuleStage.wordMatching:
        return 'Stage 2: Word Matching';
      case ModuleStage.finalQuiz:
        return 'Stage 3: Lesson Quiz';
      case ModuleStage.scoreboard:
        return 'Results';
    }
  }
}
