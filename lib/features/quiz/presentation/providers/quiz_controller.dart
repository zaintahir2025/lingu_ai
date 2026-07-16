import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/quiz_question.dart';
import '../../domain/models/wrong_answer_log.dart';
import '../../../../core/local_storage/local_storage_provider.dart';

class QuizState {
  final List<QuizQuestion> queue;
  final int currentIndex;
  final int correctCount;
  final int totalQuestions;
  final bool isFinished;

  QuizState({
    required this.queue,
    this.currentIndex = 0,
    this.correctCount = 0,
    required this.totalQuestions,
    this.isFinished = false,
  });

  QuizQuestion? get currentQuestion =>
      currentIndex < queue.length ? queue[currentIndex] : null;

  double get progress => totalQuestions == 0
      ? 0
      : (totalQuestions - (queue.length - currentIndex)) / totalQuestions;

  double get score => totalQuestions == 0 ? 0 : correctCount / totalQuestions;

  QuizState copyWith({
    List<QuizQuestion>? queue,
    int? currentIndex,
    int? correctCount,
    int? totalQuestions,
    bool? isFinished,
  }) {
    return QuizState(
      queue: queue ?? this.queue,
      currentIndex: currentIndex ?? this.currentIndex,
      correctCount: correctCount ?? this.correctCount,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      isFinished: isFinished ?? this.isFinished,
    );
  }
}

class QuizController extends AutoDisposeNotifier<QuizState> {
  @override
  QuizState build() {
    // We'll initialize with some mock questions for testing.
    final initialQuestions = [
      const QuizQuestion(
        id: 'q1',
        type: QuestionType.multipleChoice,
        prompt: 'Select the correct translation for "Hello"',
        options: ['Hola', 'Adios', 'Por favor', 'Gracias'],
        correctAnswer: 'Hola',
        explanation: '"Hola" is the most common greeting in Spanish.',
      ),
      const QuizQuestion(
        id: 'q2',
        type: QuestionType.fillBlank,
        prompt: '____ tardes.',
        correctAnswer: 'Buenas',
        explanation: 'We say "Buenas tardes" in the afternoon.',
      ),
      const QuizQuestion(
        id: 'q3',
        type: QuestionType.translation,
        prompt: 'Good morning',
        correctAnswer: 'Buenos dias',
        explanation: '"Buenos" is masculine plural to match "dias".',
      ),
      const QuizQuestion(
        id: 'q4',
        type: QuestionType.listening,
        prompt: 'Audio: "Como estas"',
        correctAnswer: 'Como estas',
        explanation: 'The speaker is asking "How are you?".',
      ),
    ];

    return QuizState(
      queue: List.from(initialQuestions),
      totalQuestions: initialQuestions.length,
    );
  }

  bool submitAnswer(String answer) {
    final question = state.currentQuestion;
    if (question == null) return false;

    final isCorrect = answer.trim().toLowerCase() ==
        question.correctAnswer.trim().toLowerCase();

    if (isCorrect) {
      state = state.copyWith(correctCount: state.correctCount + 1);
    } else {
      // Re-queue the wrong answer to the end of the list.
      final newQueue = List<QuizQuestion>.from(state.queue);
      newQueue.add(question);
      state = state.copyWith(queue: newQueue);

      // Log the wrong answer
      _logWrongAnswer(question.id, answer, question.correctAnswer);
    }

    return isCorrect;
  }

  void nextQuestion() {
    if (state.currentIndex + 1 >= state.queue.length) {
      state = state.copyWith(isFinished: true);
    } else {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
    }
  }

  void restartQuiz() {
    ref.invalidateSelf();
  }

  Future<void> _logWrongAnswer(
      String questionId, String userAnswer, String correctAnswer) async {
    final log = WrongAnswerLog(
      questionId: questionId,
      userAnswer: userAnswer,
      correctAnswer: correctAnswer,
      timestamp: DateTime.now(),
    );

    try {
      final box = ref.read(localStorageProvider);
      final logs = box.get('wrong_answers', defaultValue: []) as List;
      logs.add(log.toJson());
      await box.put('wrong_answers', logs);
    } catch (e) {
      // Handle missing box error in tests
      debugPrint('Failed to log wrong answer: $e');
    }
  }
}

final quizControllerProvider =
    NotifierProvider.autoDispose<QuizController, QuizState>(QuizController.new);
