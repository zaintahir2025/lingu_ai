import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/quiz_question.dart';
import '../../domain/models/wrong_answer_log.dart';
import '../../../../core/local_storage/local_storage_provider.dart';
import '../../../learn/domain/repositories/learn_repository.dart';
import 'package:drift/drift.dart' hide Column;
import '../../../../core/database/database.dart';
import '../../../progress/presentation/providers/progress_controller.dart';
import '../../../../core/game_state/game_state_provider.dart';
import '../../../../core/storage/onboarding_storage.dart';
import '../../../../main.dart';
import '../../../learn/data/vocab_translator.dart';

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

class QuizController extends AutoDisposeFamilyNotifier<QuizState, int> {
  static const Map<int, List<QuizQuestion>> _curriculumQuestions = {
    1: [
      QuizQuestion(
        id: 'l1_q1',
        type: QuestionType.multipleChoice,
        prompt: 'Select the correct translation for "Hello"',
        options: ['Hola', 'Adiós', 'Por favor', 'Gracias'],
        correctAnswer: 'Hola',
        explanation: 'Standard greeting for hello.',
      ),
      QuizQuestion(
        id: 'l1_q2',
        type: QuestionType.fillBlank,
        prompt: '____ tardes.',
        correctAnswer: 'Buenas',
        explanation: 'Greeting for Good afternoon.',
      ),
      QuizQuestion(
        id: 'l1_q3',
        type: QuestionType.translation,
        prompt: 'Good morning',
        correctAnswer: 'Buenos días',
        explanation: 'Used for good morning.',
      ),
      QuizQuestion(
        id: 'l1_q4',
        type: QuestionType.listening,
        prompt: 'Audio: "Cómo estás"',
        correctAnswer: 'Cómo estás',
        explanation: 'Asks "How are you?".',
      ),
    ],
    2: [
      QuizQuestion(
        id: 'l2_q1',
        type: QuestionType.multipleChoice,
        prompt: 'Select the correct translation for "What is your name?"',
        options: ['Cómo te llamas', 'Mucho gusto', 'Cómo estás', 'De dónde eres'],
        correctAnswer: 'Cómo te llamas',
        explanation: 'Asks for a name.',
      ),
      QuizQuestion(
        id: 'l2_q2',
        type: QuestionType.fillBlank,
        prompt: 'Yo ____ de España.',
        correctAnswer: 'soy',
        explanation: 'Used to state origin.',
      ),
      QuizQuestion(
        id: 'l2_q3',
        type: QuestionType.translation,
        prompt: 'Nice to meet you',
        correctAnswer: 'Mucho gusto',
        explanation: 'Means Nice to meet you.',
      ),
      QuizQuestion(
        id: 'l2_q4',
        type: QuestionType.listening,
        prompt: 'Audio: "De dónde eres"',
        correctAnswer: 'De dónde eres',
        explanation: 'Asks "Where are you from?".',
      ),
    ],
    3: [
      QuizQuestion(
        id: 'l3_q1',
        type: QuestionType.multipleChoice,
        prompt: 'Select the correct translation for "Apple"',
        options: ['Manzana', 'Pan', 'Agua', 'Leche'],
        correctAnswer: 'Manzana',
        explanation: 'Means apple.',
      ),
      QuizQuestion(
        id: 'l3_q2',
        type: QuestionType.fillBlank,
        prompt: 'Yo como ____.',
        correctAnswer: 'pan',
        explanation: 'Means bread.',
      ),
      QuizQuestion(
        id: 'l3_q3',
        type: QuestionType.translation,
        prompt: 'I want a coffee',
        correctAnswer: 'Quiero un café',
        explanation: 'Translates to I want a coffee.',
      ),
      QuizQuestion(
        id: 'l3_q4',
        type: QuestionType.listening,
        prompt: 'Audio: "El agua es buena"',
        correctAnswer: 'El agua es buena',
        explanation: 'Translates to Water is good.',
      ),
    ],
  };

  @override
  QuizState build(int arg) {
    final targetLang = ref.read(onboardingStorageProvider).targetLanguage ?? 'es';
    final uiLocale = ref.read(localeProvider).languageCode;
    final baseQuestions = _curriculumQuestions[arg] ?? _curriculumQuestions[1]!;
    
    final List<QuizQuestion> expandedPool = [];

    for (int i = 0; i < baseQuestions.length; i++) {
      final q = baseQuestions[i];

      VocabWord makeDummyWord(String w) => VocabWord(
        id: 0, 
        lessonId: arg, 
        word: w, 
        translation: w,
        repetitions: 0,
        easinessFactor: 2.5,
        interval: 1,
        status: 'learning',
      );

      final translatedOption1 = VocabTranslator.translate(makeDummyWord(q.options[0]), targetLang, uiLocale).word;
      final translatedOption2 = q.options.length > 1 ? VocabTranslator.translate(makeDummyWord(q.options[1]), targetLang, uiLocale).word : 'Adiós';
      final translatedOption3 = q.options.length > 2 ? VocabTranslator.translate(makeDummyWord(q.options[2]), targetLang, uiLocale).word : 'Por favor';
      final translatedOption4 = q.options.length > 3 ? VocabTranslator.translate(makeDummyWord(q.options[3]), targetLang, uiLocale).word : 'Gracias';
      final translatedCorrect = VocabTranslator.translate(makeDummyWord(q.correctAnswer), targetLang, uiLocale).word;

      final optionsList = [translatedOption1, translatedOption2, translatedOption3, translatedOption4];
      if (!optionsList.contains(translatedCorrect)) {
        optionsList[0] = translatedCorrect;
      }
      optionsList.shuffle();

      expandedPool.add(
        QuizQuestion(
          id: '${q.id}_mc',
          type: QuestionType.multipleChoice,
          prompt: q.prompt,
          options: optionsList,
          correctAnswer: translatedCorrect,
          explanation: q.explanation,
        ),
      );

      expandedPool.add(
        QuizQuestion(
          id: '${q.id}_listen',
          type: QuestionType.listening,
          prompt: 'Audio: "$translatedCorrect"',
          correctAnswer: translatedCorrect,
          explanation: 'Listen carefully: ${q.explanation}',
        ),
      );

      expandedPool.add(
        QuizQuestion(
          id: '${q.id}_trans',
          type: QuestionType.translation,
          prompt: q.prompt,
          correctAnswer: translatedCorrect,
          explanation: q.explanation,
        ),
      );
    }

    final finalQueue = expandedPool.take(15).toList();

    return QuizState(
      queue: finalQueue,
      totalQuestions: finalQueue.length,
    );
  }

  bool submitAnswer(String answer) {
    final question = state.currentQuestion;
    if (question == null) return false;

    final isCorrect = answer.trim().toLowerCase() ==
        question.correctAnswer.trim().toLowerCase();

    if (isCorrect) {
      state = state.copyWith(correctCount: state.correctCount + 1);
      try {
        final db = ref.read(databaseProvider);
        final targetWord = question.correctAnswer.trim();
        (db.update(db.vocabWords)..where((t) => t.word.equals(targetWord))).write(
          const VocabWordsCompanion(status: Value('mastered')),
        );
      } catch (_) {}
    } else {
      ref.read(gameStateProvider.notifier).reduceHeart();
      final newQueue = List<QuizQuestion>.from(state.queue);
      newQueue.add(question);
      state = state.copyWith(queue: newQueue);
      _logWrongAnswer(question.id, answer, question.correctAnswer);
    }

    return isCorrect;
  }

  void nextQuestion() {
    if (state.currentIndex + 1 >= state.queue.length) {
      state = state.copyWith(isFinished: true);
      
      if (state.score >= 0.8) {
        final repo = ref.read(learnRepositoryProvider);
        repo.completeLesson(arg);
        
        final isPerfectScore = state.correctCount == state.totalQuestions;
        final basePoints = 30;
        final bonusPoints = isPerfectScore ? 50 : 0;
        final totalAwarded = basePoints + bonusPoints;

        ref.read(progressControllerProvider.notifier).addXp(totalAwarded);
        ref.read(gameStateProvider.notifier).addXp(totalAwarded);
        ref.read(gameStateProvider.notifier).incrementStreak();
      }
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

      final db = ref.read(databaseProvider);
      final wordMatch = await (db.select(db.vocabWords)
            ..where((t) => t.word.equals(correctAnswer) | t.translation.equals(correctAnswer)))
          .getSingleOrNull();

      if (wordMatch != null) {
        await db.update(db.vocabWords).replace(
          wordMatch.copyWith(
            easinessFactor: 1.5,
            nextReviewDate: Value(DateTime.now()),
            status: 'learning',
          ),
        );
      }
    } catch (e) {
      debugPrint('Failed to log wrong answer: $e');
    }
  }
}

final quizControllerProvider =
    NotifierProvider.family.autoDispose<QuizController, QuizState, int>(
  QuizController.new,
);
