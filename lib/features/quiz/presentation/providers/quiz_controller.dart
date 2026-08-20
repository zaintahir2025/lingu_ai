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
import '../../../../main.dart';
import '../../../learn/data/vocab_translator.dart';
import '../../../../core/providers/target_language_provider.dart';
import 'dart:math';

class QuizState {
  final List<QuizQuestion> queue;
  final int currentIndex;
  final int correctCount;
  final int totalQuestions;
  final bool isFinished;
  final int xpEarned;

  QuizState({
    required this.queue,
    this.currentIndex = 0,
    this.correctCount = 0,
    required this.totalQuestions,
    this.isFinished = false,
    this.xpEarned = 0,
  });

  QuizQuestion? get currentQuestion =>
      currentIndex < queue.length ? queue[currentIndex] : null;

  double get progress => queue.isEmpty ? 0 : currentIndex / queue.length;

  double get score => totalQuestions == 0 ? 0 : correctCount / totalQuestions;

  QuizState copyWith({
    List<QuizQuestion>? queue,
    int? currentIndex,
    int? correctCount,
    int? totalQuestions,
    bool? isFinished,
    int? xpEarned,
  }) {
    return QuizState(
      queue: queue ?? this.queue,
      currentIndex: currentIndex ?? this.currentIndex,
      correctCount: correctCount ?? this.correctCount,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      isFinished: isFinished ?? this.isFinished,
      xpEarned: xpEarned ?? this.xpEarned,
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
        options: [
          'Cómo te llamas',
          'Mucho gusto',
          'Cómo estás',
          'De dónde eres',
        ],
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
    final targetLang = ref.watch(targetLanguageProvider);
    final uiLocale = ref.read(localeProvider).languageCode;
    final baseQuestions = _curriculumQuestions[arg] ?? _curriculumQuestions[1]!;

    final List<QuizQuestion> expandedPool = [];
    final stableLanguageSeed = targetLang.codeUnits.fold<int>(
      0,
      (sum, code) => sum + code,
    );
    final random = Random(arg * 997 + stableLanguageSeed);

    for (int i = 0; i < baseQuestions.length; i++) {
      final q = baseQuestions[i];

      VocabWord makeOptionWord(String w) => VocabWord(
        id: 0,
        lessonId: arg,
        word: w,
        translation: w,
        repetitions: 0,
        easinessFactor: 2.5,
        interval: 1,
        status: 'learning',
      );

      final translatedOption1 = VocabTranslator.translate(
        makeOptionWord(q.options[0]),
        targetLang,
        uiLocale,
      ).word;
      final translatedOption2 = q.options.length > 1
          ? VocabTranslator.translate(
              makeOptionWord(q.options[1]),
              targetLang,
              uiLocale,
            ).word
          : 'Adiós';
      final translatedOption3 = q.options.length > 2
          ? VocabTranslator.translate(
              makeOptionWord(q.options[2]),
              targetLang,
              uiLocale,
            ).word
          : 'Por favor';
      final translatedOption4 = q.options.length > 3
          ? VocabTranslator.translate(
              makeOptionWord(q.options[3]),
              targetLang,
              uiLocale,
            ).word
          : 'Gracias';
      final translatedCorrect = VocabTranslator.translate(
        makeOptionWord(q.correctAnswer),
        targetLang,
        uiLocale,
      ).word;

      final optionsList = [
        translatedOption1,
        translatedOption2,
        translatedOption3,
        translatedOption4,
      ];
      if (!optionsList.contains(translatedCorrect)) {
        optionsList[0] = translatedCorrect;
      }
      optionsList.shuffle(random);

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

    // Check for saved draft progress
    int initialIndex = 0;
    int initialCorrect = 0;
    try {
      final box = ref.read(localStorageProvider);
      final draft = box.get('quiz_draft_lesson_$arg') as Map?;
      if (draft != null) {
        final savedIndex = (draft['currentIndex'] as int?) ?? 0;
        final savedCorrect = (draft['correctCount'] as int?) ?? 0;
        final savedQueueIds = (draft['queueIds'] as List?)
            ?.whereType<String>()
            .toList();
        if (savedQueueIds != null && savedQueueIds.isNotEmpty) {
          final questionById = {
            for (final question in finalQueue) question.id: question,
          };
          final restoredQueue = savedQueueIds
              .map((id) => questionById[id])
              .whereType<QuizQuestion>()
              .toList();
          if (restoredQueue.length == savedQueueIds.length) {
            finalQueue
              ..clear()
              ..addAll(restoredQueue);
          }
        }
        if (savedIndex > 0 && savedIndex < finalQueue.length) {
          initialIndex = savedIndex;
          initialCorrect = savedCorrect;
        }
      }
    } catch (_) {}

    return QuizState(
      queue: finalQueue,
      totalQuestions: finalQueue.length,
      currentIndex: initialIndex,
      correctCount: initialCorrect,
    );
  }

  bool submitAnswer(String answer) {
    final question = state.currentQuestion;
    if (question == null) return false;

    final isCorrect =
        answer.trim().toLowerCase() ==
        question.correctAnswer.trim().toLowerCase();

    if (isCorrect) {
      state = state.copyWith(correctCount: state.correctCount + 1);
      try {
        final db = ref.read(databaseProvider);
        final targetWord = question.correctAnswer.trim();
        (db.update(db.vocabWords)..where((t) => t.word.equals(targetWord)))
            .write(const VocabWordsCompanion(status: Value('mastered')));
      } catch (_) {}
    } else {
      ref.read(gameStateProvider.notifier).reduceHeart();
      final newQueue = List<QuizQuestion>.from(state.queue);
      newQueue.add(question);
      state = state.copyWith(queue: newQueue);
      _logWrongAnswer(question.id, answer, question.correctAnswer);
    }

    // If the app is killed while feedback or the tutor is open, resume at the
    // next unanswered question rather than charging the same answer twice.
    final canAdvanceOnResume = state.currentIndex + 1 < state.queue.length;
    _saveDraftProgress(
      nextIndex: canAdvanceOnResume
          ? state.currentIndex + 1
          : state.currentIndex,
      correctCountOverride: !canAdvanceOnResume && isCorrect
          ? state.correctCount - 1
          : null,
    );
    return isCorrect;
  }

  void nextQuestion() {
    if (state.currentIndex + 1 >= state.queue.length) {
      state = state.copyWith(isFinished: true);
      _clearDraftProgress();

      if (state.score >= 0.75) {
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
      _saveDraftProgress();
    }
  }

  void restartQuiz() {
    _clearDraftProgress();
    ref.invalidateSelf();
  }

  void _saveDraftProgress({int? nextIndex, int? correctCountOverride}) {
    try {
      final box = ref.read(localStorageProvider);
      box.put('quiz_draft_lesson_$arg', {
        'currentIndex': nextIndex ?? state.currentIndex,
        'correctCount': correctCountOverride ?? state.correctCount,
        'queueIds': state.queue.map((question) => question.id).toList(),
      });
    } catch (_) {}
  }

  void _clearDraftProgress() {
    try {
      final box = ref.read(localStorageProvider);
      box.delete('quiz_draft_lesson_$arg');
    } catch (_) {}
  }

  Future<void> _logWrongAnswer(
    String questionId,
    String userAnswer,
    String correctAnswer,
  ) async {
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
      final wordMatch =
          await (db.select(db.vocabWords)..where(
                (t) =>
                    t.word.equals(correctAnswer) |
                    t.translation.equals(correctAnswer),
              ))
              .getSingleOrNull();

      if (wordMatch != null) {
        await db
            .update(db.vocabWords)
            .replace(
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

final quizControllerProvider = NotifierProvider.family
    .autoDispose<QuizController, QuizState, int>(QuizController.new);
