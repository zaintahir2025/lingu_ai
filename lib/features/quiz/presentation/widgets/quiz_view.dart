import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/quiz_controller.dart';
import 'question_views.dart';
import 'feedback_bottom_sheet.dart';
import '../../../../core/widgets/shared/progress_bar.dart';
import '../../../../core/widgets/shared/primary_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_constants.dart';
import '../../domain/models/quiz_question.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/game_state/game_state_provider.dart';
import '../../../../core/game_state/heart_settings_storage.dart';

import 'in_quiz_tutor_modal.dart';

class QuizView extends ConsumerStatefulWidget {
  final int lessonId;
  final bool isPractice;
  final Function(double score) onComplete;

  const QuizView({
    super.key,
    required this.lessonId,
    this.isPractice = false,
    required this.onComplete,
  });

  @override
  ConsumerState<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends ConsumerState<QuizView> {
  String _currentAnswer = '';
  final FocusNode _focusNode = FocusNode();
  bool _isFeedbackShowing = false;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _onAnswerChanged(String value) {
    setState(() {
      _currentAnswer = value;
    });
  }

  void _submitAnswer() {
    if (_currentAnswer.isEmpty || _isFeedbackShowing) return;

    final isUnlimited = ref.read(heartSettingsStorageProvider).isUnlimitedMode;
    final hearts = ref.read(gameStateProvider).hearts;
    if (!isUnlimited && hearts <= 0) {
      _showOutOfHeartsDialog();
      return;
    }

    final question = ref
        .read(quizControllerProvider(widget.lessonId))
        .currentQuestion;
    if (question == null) return;

    _isFeedbackShowing = true;
    final isCorrect = ref
        .read(quizControllerProvider(widget.lessonId).notifier)
        .submitAnswer(_currentAnswer);

    FeedbackBottomSheet.show(
      context: context,
      isCorrect: isCorrect,
      correctAnswer: question.correctAnswer,
      explanation: question.explanation,
      onAskTutor: () {
        InQuizTutorModal.show(
          context,
          questionPrompt: question.prompt,
          userAnswer: _currentAnswer,
          correctAnswer: question.correctAnswer,
          explanation: question.explanation,
        );
      },
      onContinue: () {
        _isFeedbackShowing = false;
        setState(() {
          _currentAnswer = '';
        });
        ref
            .read(quizControllerProvider(widget.lessonId).notifier)
            .nextQuestion();

        final state = ref.read(quizControllerProvider(widget.lessonId));
        if (state.isFinished) {
          widget.onComplete(state.score);
        } else {
          _focusNode.requestFocus(); // Re-focus for next question
        }
      },
    );
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (!_isFeedbackShowing) {
          _submitAnswer();
        }
        return KeyEventResult.handled;
      }

      final question = ref
          .read(quizControllerProvider(widget.lessonId))
          .currentQuestion;
      if (question?.type == QuestionType.multipleChoice &&
          !_isFeedbackShowing) {
        if (event.logicalKey == LogicalKeyboardKey.digit1 ||
            event.logicalKey == LogicalKeyboardKey.numpad1) {
          if (question!.options.isNotEmpty) {
            _onAnswerChanged(question.options[0]);
          }
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.digit2 ||
            event.logicalKey == LogicalKeyboardKey.numpad2) {
          if (question!.options.length > 1) {
            _onAnswerChanged(question.options[1]);
          }
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.digit3 ||
            event.logicalKey == LogicalKeyboardKey.numpad3) {
          if (question!.options.length > 2) {
            _onAnswerChanged(question.options[2]);
          }
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.digit4 ||
            event.logicalKey == LogicalKeyboardKey.numpad4) {
          if (question!.options.length > 3) {
            _onAnswerChanged(question.options[3]);
          }
          return KeyEventResult.handled;
        }
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizControllerProvider(widget.lessonId));
    final question = state.currentQuestion;

    if (question == null) {
      return const Center(child: CircularProgressIndicator());
    }

    Widget content = const SizedBox.shrink();
    switch (question.type) {
      case QuestionType.multipleChoice:
        content = MultipleChoiceView(
          question: question,
          selectedOption: _currentAnswer.isNotEmpty ? _currentAnswer : null,
          onSelect: _onAnswerChanged,
        );
        break;
      case QuestionType.fillBlank:
        content = FillBlankView(
          question: question,
          answer: _currentAnswer,
          onChanged: _onAnswerChanged,
          onSubmit: _submitAnswer,
        );
        break;
      case QuestionType.translation:
        content = TranslationView(
          question: question,
          answer: _currentAnswer,
          onChanged: _onAnswerChanged,
          onSubmit: _submitAnswer,
        );
        break;
      case QuestionType.listening:
        content = ListeningView(
          question: question,
          answer: _currentAnswer,
          onChanged: _onAnswerChanged,
          onSubmit: _submitAnswer,
        );
        break;
    }

    return Focus(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: Column(
        children: [
          if (widget.isPractice)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.space16,
                vertical: AppConstants.space8,
              ),
              child: Text(
                'Practice Quiz',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.space16,
              vertical: AppConstants.space16,
            ),
            child: ProgressBar(progress: state.progress),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.space24,
              ),
              child: content,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppConstants.space24),
            child: SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: 'Check',
                onPressed: _currentAnswer.isNotEmpty ? _submitAnswer : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOutOfHeartsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.favorite_rounded, color: AppColors.heartRed, size: 28),
            SizedBox(width: 10),
            Text(
              'Out of Hearts! 💔',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'You ran out of hearts from wrong answers.\n\nRefill your hearts now to continue learning or try again later!',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/');
            },
            child: const Text(
              'Exit Quiz',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            icon: const Icon(
              Icons.favorite_rounded,
              color: Colors.white,
              size: 18,
            ),
            label: const Text(
              'Refill Hearts (5 ❤️)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              ref.read(gameStateProvider.notifier).refillHearts();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Hearts Refilled! ❤️❤️❤️❤️❤️')),
              );
            },
          ),
        ],
      ),
    );
  }
}
