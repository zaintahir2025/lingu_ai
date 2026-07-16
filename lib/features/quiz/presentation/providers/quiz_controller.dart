import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/quiz_question.dart';
import '../../domain/models/wrong_answer_log.dart';
import '../../../../core/local_storage/local_storage_provider.dart';
import '../../../learn/domain/repositories/learn_repository.dart';
import '../../../progress/presentation/providers/progress_controller.dart';

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
    // Lesson 1: Greetings (A1)
    1: [
      QuizQuestion(
        id: 'l1_q1',
        type: QuestionType.multipleChoice,
        prompt: 'Select the correct translation for "Hello"',
        options: ['Hola', 'Adiós', 'Por favor', 'Gracias'],
        correctAnswer: 'Hola',
        explanation: '"Hola" is the standard Spanish greeting for hello.',
      ),
      QuizQuestion(
        id: 'l1_q2',
        type: QuestionType.fillBlank,
        prompt: '____ tardes.',
        correctAnswer: 'Buenas',
        explanation: '"Buenas tardes" means Good afternoon.',
      ),
      QuizQuestion(
        id: 'l1_q3',
        type: QuestionType.translation,
        prompt: 'Good morning',
        correctAnswer: 'Buenos días',
        explanation: '"Buenos días" is used for good morning in Spanish.',
      ),
      QuizQuestion(
        id: 'l1_q4',
        type: QuestionType.listening,
        prompt: 'Audio: "Cómo estás"',
        correctAnswer: 'Cómo estás',
        explanation: '"Cómo estás" asks "How are you?".',
      ),
    ],
    // Lesson 2: Introductions (A1)
    2: [
      QuizQuestion(
        id: 'l2_q1',
        type: QuestionType.multipleChoice,
        prompt: 'Select the correct translation for "What is your name?"',
        options: ['Cómo te llamas', 'Mucho gusto', 'Cómo estás', 'De dónde eres'],
        correctAnswer: 'Cómo te llamas',
        explanation: '"Cómo te llamas" asks for a name.',
      ),
      QuizQuestion(
        id: 'l2_q2',
        type: QuestionType.fillBlank,
        prompt: 'Yo ____ de España.',
        correctAnswer: 'soy',
        explanation: 'We use the verb "ser" (soy) to state origin.',
      ),
      QuizQuestion(
        id: 'l2_q3',
        type: QuestionType.translation,
        prompt: 'Nice to meet you',
        correctAnswer: 'Mucho gusto',
        explanation: '"Mucho gusto" means Nice to meet you.',
      ),
      QuizQuestion(
        id: 'l2_q4',
        type: QuestionType.listening,
        prompt: 'Audio: "De dónde eres"',
        correctAnswer: 'De dónde eres',
        explanation: '"De dónde eres" asks "Where are you from?".',
      ),
    ],
    // Lesson 3: Food & Drink (A1)
    3: [
      QuizQuestion(
        id: 'l3_q1',
        type: QuestionType.multipleChoice,
        prompt: 'Select the correct translation for "Apple"',
        options: ['Manzana', 'Pan', 'Agua', 'Leche'],
        correctAnswer: 'Manzana',
        explanation: '"Manzana" is apple in Spanish.',
      ),
      QuizQuestion(
        id: 'l3_q2',
        type: QuestionType.fillBlank,
        prompt: 'Yo como ____.',
        correctAnswer: 'pan',
        explanation: '"Pan" means bread in Spanish.',
      ),
      QuizQuestion(
        id: 'l3_q3',
        type: QuestionType.translation,
        prompt: 'I want a coffee',
        correctAnswer: 'Quiero un café',
        explanation: '"Quiero un café" translates to I want a coffee.',
      ),
      QuizQuestion(
        id: 'l3_q4',
        type: QuestionType.listening,
        prompt: 'Audio: "El agua es buena"',
        correctAnswer: 'El agua es buena',
        explanation: '"El agua es buena" translates to Water is good.',
      ),
    ],
    // Lesson 4: Travel (A2)
    4: [
      QuizQuestion(
        id: 'l4_q1',
        type: QuestionType.multipleChoice,
        prompt: 'Select the correct translation for "Airport"',
        options: ['Aeropuerto', 'Hotel', 'Maleta', 'Estación'],
        correctAnswer: 'Aeropuerto',
        explanation: '"Aeropuerto" is airport in Spanish.',
      ),
      QuizQuestion(
        id: 'l4_q2',
        type: QuestionType.fillBlank,
        prompt: 'El ____ está aquí.',
        correctAnswer: 'hotel',
        explanation: '"Hotel" is spelled the same in Spanish.',
      ),
      QuizQuestion(
        id: 'l4_q3',
        type: QuestionType.translation,
        prompt: 'I have a suitcase',
        correctAnswer: 'Tengo una maleta',
        explanation: '"Maleta" is suitcase in Spanish.',
      ),
      QuizQuestion(
        id: 'l4_q4',
        type: QuestionType.listening,
        prompt: 'Audio: "Buen viaje"',
        correctAnswer: 'Buen viaje',
        explanation: '"Buen viaje" means Have a good trip.',
      ),
    ],
    // Lesson 5: Family (A2)
    5: [
      QuizQuestion(
        id: 'l5_q1',
        type: QuestionType.multipleChoice,
        prompt: 'Select the correct translation for "Brother"',
        options: ['Hermano', 'Padre', 'Hijo', 'Abuelo'],
        correctAnswer: 'Hermano',
        explanation: '"Hermano" is brother in Spanish.',
      ),
      QuizQuestion(
        id: 'l5_q2',
        type: QuestionType.fillBlank,
        prompt: 'Mi ____ es alta.',
        correctAnswer: 'madre',
        explanation: '"Madre" is mother in Spanish.',
      ),
      QuizQuestion(
        id: 'l5_q3',
        type: QuestionType.translation,
        prompt: 'My father is nice',
        correctAnswer: 'Mi padre es simpático',
        explanation: '"Simpático" is friendly/nice.',
      ),
      QuizQuestion(
        id: 'l5_q4',
        type: QuestionType.listening,
        prompt: 'Audio: "Tengo un hijo"',
        correctAnswer: 'Tengo un hijo',
        explanation: '"Tengo un hijo" translates to I have a son.',
      ),
    ],
    // Lesson 6: Shopping (B1)
    6: [
      QuizQuestion(
        id: 'l6_q1',
        type: QuestionType.multipleChoice,
        prompt: 'Select the correct translation for "Shirt"',
        options: ['Camisa', 'Pantalón', 'Zapato', 'Tienda'],
        correctAnswer: 'Camisa',
        explanation: '"Camisa" is shirt.',
      ),
      QuizQuestion(
        id: 'l6_q2',
        type: QuestionType.fillBlank,
        prompt: 'La ____ de ropa está abierta.',
        correctAnswer: 'tienda',
        explanation: '"Tienda" is shop/store.',
      ),
      QuizQuestion(
        id: 'l6_q3',
        type: QuestionType.translation,
        prompt: 'I would like a discount',
        correctAnswer: 'Me gustaría un descuento',
        explanation: '"Me gustaría" is I would like.',
      ),
      QuizQuestion(
        id: 'l6_q4',
        type: QuestionType.listening,
        prompt: 'Audio: "Esta falda es cara"',
        correctAnswer: 'Esta falda es cara',
        explanation: '"Caro/a" means expensive.',
      ),
    ],
    // Lesson 7: Work & Office (B1)
    7: [
      QuizQuestion(
        id: 'l7_q1',
        type: QuestionType.multipleChoice,
        prompt: 'Select the correct translation for "Job"',
        options: ['Trabajo', 'Oficina', 'Negocio', 'Empresa'],
        correctAnswer: 'Trabajo',
        explanation: '"Trabajo" is job or work.',
      ),
      QuizQuestion(
        id: 'l7_q2',
        type: QuestionType.fillBlank,
        prompt: 'Él es un ____ universitario.',
        correctAnswer: 'estudiante',
        explanation: '"Estudiante" is student.',
      ),
      QuizQuestion(
        id: 'l7_q3',
        type: QuestionType.translation,
        prompt: 'I work in an office',
        correctAnswer: 'Trabajo en una oficina',
        explanation: '"Oficina" is office.',
      ),
      QuizQuestion(
        id: 'l7_q4',
        type: QuestionType.listening,
        prompt: 'Audio: "Estudio ingeniería"',
        correctAnswer: 'Estudio ingeniería',
        explanation: '"Ingeniería" is engineering.',
      ),
    ],
    // Lesson 8: Health & Wellness (B2)
    8: [
      QuizQuestion(
        id: 'l8_q1',
        type: QuestionType.multipleChoice,
        prompt: 'Select the correct translation for "Health"',
        options: ['Salud', 'Enfermedad', 'Ejercicio', 'Médico'],
        correctAnswer: 'Salud',
        explanation: '"Salud" is health.',
      ),
      QuizQuestion(
        id: 'l8_q2',
        type: QuestionType.fillBlank,
        prompt: 'Necesito ver a un ____.',
        correctAnswer: 'médico',
        explanation: '"Médico" is doctor.',
      ),
      QuizQuestion(
        id: 'l8_q3',
        type: QuestionType.translation,
        prompt: 'Exercise is good for the heart',
        correctAnswer: 'El ejercicio es bueno para el corazón',
        explanation: '"Corazón" is heart.',
      ),
      QuizQuestion(
        id: 'l8_q4',
        type: QuestionType.listening,
        prompt: 'Audio: "Tengo dolor de cabeza"',
        correctAnswer: 'Tengo dolor de cabeza',
        explanation: '"Dolor de cabeza" means headache.',
      ),
    ],
    // Lesson 9: Technology (B2)
    9: [
      QuizQuestion(
        id: 'l9_q1',
        type: QuestionType.multipleChoice,
        prompt: 'Select the correct translation for "Computer"',
        options: ['Computadora', 'Pantalla', 'Teléfono', 'Red'],
        correctAnswer: 'Computadora',
        explanation: '"Computadora" is computer.',
      ),
      QuizQuestion(
        id: 'l9_q2',
        type: QuestionType.fillBlank,
        prompt: 'La ____ de mi teléfono está rota.',
        correctAnswer: 'pantalla',
        explanation: '"Pantalla" is screen.',
      ),
      QuizQuestion(
        id: 'l9_q3',
        type: QuestionType.translation,
        prompt: 'The internet is slow today',
        correctAnswer: 'El internet está lento hoy',
        explanation: '"Lento" is slow.',
      ),
      QuizQuestion(
        id: 'l9_q4',
        type: QuestionType.listening,
        prompt: 'Audio: "Envíame un mensaje"',
        correctAnswer: 'Envíame un mensaje',
        explanation: '"Mensaje" is message.',
      ),
    ],
    // Lesson 10: Global Issues (C1)
    10: [
      QuizQuestion(
        id: 'l10_q1',
        type: QuestionType.multipleChoice,
        prompt: 'Select the correct translation for "Globalization"',
        options: ['Globalización', 'Ambiente', 'Cultura', 'Historia'],
        correctAnswer: 'Globalización',
        explanation: '"Globalización" is globalization.',
      ),
      QuizQuestion(
        id: 'l10_q2',
        type: QuestionType.fillBlank,
        prompt: 'Debemos proteger el medio ____.',
        correctAnswer: 'ambiente',
        explanation: '"Medio ambiente" is environment.',
      ),
      QuizQuestion(
        id: 'l10_q3',
        type: QuestionType.translation,
        prompt: 'Culture defines society',
        correctAnswer: 'La cultura define a la sociedad',
        explanation: '"Cultura" is culture.',
      ),
      QuizQuestion(
        id: 'l10_q4',
        type: QuestionType.listening,
        prompt: 'Audio: "La historia es fascinante"',
        correctAnswer: 'La historia es fascinante',
        explanation: '"La historia es fascinante" is history is fascinating.',
      ),
    ],
  };

  @override
  QuizState build(int arg) {
    final questions = _curriculumQuestions[arg] ?? _curriculumQuestions[1]!;
    return QuizState(
      queue: List.from(questions),
      totalQuestions: questions.length,
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
      
      // Check pass threshold (60%)
      if (state.score >= 0.6) {
        final repo = ref.read(learnRepositoryProvider);
        repo.completeLesson(arg);
        
        // Award XP via ProgressController
        ref.read(progressControllerProvider.notifier).addXp(30);
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
    } catch (e) {
      debugPrint('Failed to log wrong answer: $e');
    }
  }
}

final quizControllerProvider =
    NotifierProvider.family.autoDispose<QuizController, QuizState, int>(
  QuizController.new,
);
