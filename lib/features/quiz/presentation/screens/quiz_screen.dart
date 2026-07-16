import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/quiz_controller.dart';
import '../widgets/question_views.dart';
import '../widgets/feedback_bottom_sheet.dart';
import '../../../../core/widgets/shared/progress_bar.dart';
import '../../../../core/widgets/shared/primary_button.dart';
import '../../../../core/theme/app_constants.dart';
import '../../domain/models/quiz_question.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final int lessonId;
  const QuizScreen({super.key, required this.lessonId});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
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

    final question = ref.read(quizControllerProvider(widget.lessonId)).currentQuestion;
    if (question == null) return;

    _isFeedbackShowing = true;
    final isCorrect = ref.read(quizControllerProvider(widget.lessonId).notifier).submitAnswer(_currentAnswer);

    FeedbackBottomSheet.show(
      context: context,
      isCorrect: isCorrect,
      correctAnswer: question.correctAnswer,
      explanation: question.explanation,
      onContinue: () {
        _isFeedbackShowing = false;
        setState(() {
          _currentAnswer = '';
        });
        ref.read(quizControllerProvider(widget.lessonId).notifier).nextQuestion();
        
        final isFinished = ref.read(quizControllerProvider(widget.lessonId)).isFinished;
        if (isFinished) {
          context.go('/quiz/results/${widget.lessonId}');
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

      final question = ref.read(quizControllerProvider(widget.lessonId)).currentQuestion;
      if (question?.type == QuestionType.multipleChoice && !_isFeedbackShowing) {
        if (event.logicalKey == LogicalKeyboardKey.digit1 || event.logicalKey == LogicalKeyboardKey.numpad1) {
          if (question!.options.isNotEmpty) _onAnswerChanged(question.options[0]);
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.digit2 || event.logicalKey == LogicalKeyboardKey.numpad2) {
          if (question!.options.length > 1) _onAnswerChanged(question.options[1]);
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.digit3 || event.logicalKey == LogicalKeyboardKey.numpad3) {
          if (question!.options.length > 2) _onAnswerChanged(question.options[2]);
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.digit4 || event.logicalKey == LogicalKeyboardKey.numpad4) {
          if (question!.options.length > 3) _onAnswerChanged(question.options[3]);
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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
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

    return Scaffold(
      body: SafeArea(
        child: Focus(
          focusNode: _focusNode,
          onKeyEvent: _handleKeyEvent,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.space16, vertical: AppConstants.space24),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => context.go('/'),
                    ),
                    Expanded(
                      child: ProgressBar(progress: state.progress),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.space24),
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
        ),
      ),
    );
  }
}
