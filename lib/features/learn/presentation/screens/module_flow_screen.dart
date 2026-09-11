import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/flashcard_view.dart';
import '../../../quiz/presentation/widgets/quiz_view.dart';
import '../../../quiz/presentation/widgets/module_scoreboard_view.dart';
import '../../../quiz/presentation/providers/quiz_controller.dart';
import '../../../../core/theme/app_colors.dart';

import '../../../quiz/presentation/widgets/word_matching_exercise_view.dart';

import '../../../../core/local_storage/local_storage_provider.dart';

enum ModuleStage { flashcards, wordMatching, finalQuiz, scoreboard }

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
      _restoreSavedStage();
    });
  }

  Future<void> _restoreSavedStage() async {
    try {
      final box = ref.read(localStorageProvider);
      final savedIdx =
          box.get('module_flow_stage_lesson_${widget.lessonId}') as int?;
      final savedScore =
          box.get('module_flow_score_lesson_${widget.lessonId}') as num?;

      if (savedIdx != null &&
          savedIdx > 0 &&
          savedIdx < ModuleStage.values.length) {
        final stageName = _getStageNameForIndex(savedIdx);

        final shouldResume = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: AppColors.surface,
            title: const Row(
              children: [
                Icon(
                  Icons.history_rounded,
                  color: AppColors.primaryGreen,
                  size: 28,
                ),
                SizedBox(width: 10),
                Text(
                  'Resume Lesson?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: Text(
              'You left off at $stageName.\n\nWould you like to resume, or start over from the Vocabulary flashcards?',
              style: const TextStyle(fontSize: 15),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text(
                  'Start Fresh 🔄',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Resume ⚡',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );

        if (shouldResume == true) {
          setState(() {
            _currentStage = ModuleStage.values[savedIdx];
            _finalScore = savedScore?.toDouble() ?? 0;
          });
        } else {
          try {
            box.delete('module_flow_stage_lesson_${widget.lessonId}');
            box.delete('module_flow_score_lesson_${widget.lessonId}');
            box.delete('flashcard_draft_lesson_${widget.lessonId}');
            box.delete('matching_draft_lesson_${widget.lessonId}');
          } catch (_) {}
        }
      }
    } catch (_) {}
  }

  String _getStageNameForIndex(int index) {
    switch (index) {
      case 0:
        return 'Stage 1: Vocabulary';
      case 1:
        return 'Stage 2: Word Matching';
      case 2:
        return 'Stage 3: Lesson Quiz';
      case 3:
        return 'Results';
      default:
        return 'an earlier stage';
    }
  }

  void _saveStage(ModuleStage stage) {
    try {
      final box = ref.read(localStorageProvider);
      box.put('module_flow_stage_lesson_${widget.lessonId}', stage.index);
    } catch (_) {}
  }

  void _advanceStage() {
    setState(() {
      switch (_currentStage) {
        case ModuleStage.flashcards:
          _currentStage = ModuleStage.wordMatching;
          break;
        case ModuleStage.wordMatching:
          _currentStage = ModuleStage.finalQuiz;
          break;
        case ModuleStage.finalQuiz:
          _currentStage = ModuleStage.scoreboard;
          break;
        case ModuleStage.scoreboard:
          break;
      }
      _saveStage(_currentStage);
    });
  }

  void _onFinalQuizComplete(double score) {
    _finalScore = score;
    ref
        .read(localStorageProvider)
        .put('module_flow_score_lesson_${widget.lessonId}', score);
    _advanceStage();
  }

  void _onRetry() {
    ref.read(quizControllerProvider(widget.lessonId).notifier).restartQuiz();
    setState(() {
      _currentStage = ModuleStage.wordMatching;
      _finalScore = 0.0;
    });
    _saveStage(_currentStage);
  }

  void _onFinish() {
    try {
      final box = ref.read(localStorageProvider);
      box.delete('module_flow_stage_lesson_${widget.lessonId}');
      box.delete('module_flow_score_lesson_${widget.lessonId}');
    } catch (_) {}
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
