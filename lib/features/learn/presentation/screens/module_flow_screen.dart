import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/flashcard_view.dart';
import '../../../quiz/presentation/widgets/quiz_view.dart';
import '../../../quiz/presentation/widgets/module_scoreboard_view.dart';
import '../../../quiz/presentation/providers/quiz_controller.dart';
import '../../../../core/theme/app_colors.dart';

enum ModuleStage {
  flashcards,
  practiceQuiz,
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
    // Initialize the quiz controller for this lesson
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(quizControllerProvider(widget.lessonId).notifier).restartQuiz();
    });
  }

  void _advanceStage() {
    setState(() {
      switch (_currentStage) {
        case ModuleStage.flashcards:
          _currentStage = ModuleStage.practiceQuiz;
          break;
        case ModuleStage.practiceQuiz:
          _currentStage = ModuleStage.finalQuiz;
          // restart quiz for the final mock version
          ref.read(quizControllerProvider(widget.lessonId).notifier).restartQuiz();
          break;
        case ModuleStage.finalQuiz:
          _currentStage = ModuleStage.scoreboard;
          break;
        case ModuleStage.scoreboard:
          // Should not hit this via advanceStage
          break;
      }
    });
  }

  void _onPracticeQuizComplete(double score) {
    if (score < 0.6) {
      // Dynamic branching: user struggled. Send them back to flashcards with a toast/snackbar.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Looks like you need a bit more practice. Let\'s review the flashcards again!'),
          backgroundColor: AppColors.streakOrange,
        ),
      );
      setState(() {
        _currentStage = ModuleStage.flashcards;
      });
    } else {
      _advanceStage();
    }
  }

  void _onFinalQuizComplete(double score) {
    _finalScore = score;
    _advanceStage();
  }

  void _onRetry() {
    // Restart from final quiz, or from the beginning?
    // Let's restart from the final quiz
    ref.read(quizControllerProvider(widget.lessonId).notifier).restartQuiz();
    setState(() {
      _currentStage = ModuleStage.finalQuiz;
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
      case ModuleStage.practiceQuiz:
        content = QuizView(
          lessonId: widget.lessonId,
          isPractice: true,
          onComplete: _onPracticeQuizComplete,
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
          : null, // Hide app bar on scoreboard
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
        return 'Learn Vocabulary';
      case ModuleStage.practiceQuiz:
        return 'Practice Quiz';
      case ModuleStage.finalQuiz:
        return 'Final Module Quiz';
      case ModuleStage.scoreboard:
        return 'Results';
    }
  }
}
