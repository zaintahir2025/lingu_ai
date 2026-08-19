import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_constants.dart';
import '../../../../core/audio/tts_service.dart';
import '../../../../core/storage/onboarding_storage.dart';

class PlacementQuestion {
  final String prompt;
  final List<String> options;
  final String correctAnswer;
  final String level;

  const PlacementQuestion({
    required this.prompt,
    required this.options,
    required this.correctAnswer,
    required this.level,
  });
}

class PlacementTestScreen extends ConsumerStatefulWidget {
  const PlacementTestScreen({super.key});

  @override
  ConsumerState<PlacementTestScreen> createState() =>
      _PlacementTestScreenState();
}

class _PlacementTestScreenState extends ConsumerState<PlacementTestScreen> {
  int _currentIndex = 0;
  int _score = 0;
  String? _selectedOption;
  bool _isFinished = false;
  String _assignedCefrLevel = 'A1';

  final List<PlacementQuestion> _questions = const [
    PlacementQuestion(
      prompt: 'Translate "Hello":',
      options: ['Hola', 'Adiós', 'Gracias', 'Por favor'],
      correctAnswer: 'Hola',
      level: 'A1',
    ),
    PlacementQuestion(
      prompt: 'Complete: "Buenos _____" (Good morning):',
      options: ['días', 'noches', 'tardes', 'luego'],
      correctAnswer: 'días',
      level: 'A1',
    ),
    PlacementQuestion(
      prompt: 'Translate "Water":',
      options: ['Agua', 'Leche', 'Pan', 'Café'],
      correctAnswer: 'Agua',
      level: 'A1',
    ),
    PlacementQuestion(
      prompt: 'Which word means "Mother"?',
      options: ['Madre', 'Padre', 'Hijo', 'Hermana'],
      correctAnswer: 'Madre',
      level: 'A1',
    ),
    PlacementQuestion(
      prompt: 'Translate "Hotel":',
      options: ['Hotel', 'Maleta', 'Avión', 'Tren'],
      correctAnswer: 'Hotel',
      level: 'A2',
    ),
    PlacementQuestion(
      prompt: 'Complete: "Tengo un ____ de cabeza" (I have a headache):',
      options: ['dolor', 'sol', 'salud', 'viento'],
      correctAnswer: 'dolor',
      level: 'A2',
    ),
    PlacementQuestion(
      prompt: 'Translate "To work":',
      options: ['Trabajar', 'Dormir', 'Estudiar', 'Comprar'],
      correctAnswer: 'Trabajar',
      level: 'A2',
    ),
    PlacementQuestion(
      prompt: 'Which word means "Meeting" in an office setting?',
      options: ['Reunión', 'Proyecto', 'Informe', 'Empresa'],
      correctAnswer: 'Reunión',
      level: 'B1',
    ),
    PlacementQuestion(
      prompt: 'Translate "Screen":',
      options: ['Pantalla', 'Computadora', 'Teléfono', 'Red'],
      correctAnswer: 'Pantalla',
      level: 'B2',
    ),
    PlacementQuestion(
      prompt: 'Which word means "Emergency"?',
      options: ['Emergencia', 'Seguridad', 'Precaución', 'Urgencia'],
      correctAnswer: 'Emergencia',
      level: 'B2',
    ),
  ];

  void _submitAnswer() {
    if (_selectedOption == null) return;

    if (_selectedOption == _questions[_currentIndex].correctAnswer) {
      _score++;
    }

    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
      });
    } else {
      _calculateResult();
    }
  }

  void _calculateResult() {
    // REQ-OB-004: 0-3 -> A1, 4-5 -> A2, 6-7 -> B1, 8-10 -> B2
    if (_score <= 3) {
      _assignedCefrLevel = 'A1';
    } else if (_score <= 5) {
      _assignedCefrLevel = 'A2';
    } else if (_score <= 7) {
      _assignedCefrLevel = 'B1';
    } else {
      _assignedCefrLevel = 'B2';
    }

    setState(() {
      _isFinished = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isFinished) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.space32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: AppColors.softSuccess,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.workspace_premium_rounded,
                    color: AppColors.primaryGreen,
                    size: 64,
                  ),
                ),
                const SizedBox(height: AppConstants.space24),
                Text(
                  'Placement Complete!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppConstants.space12),
                Text(
                  'Your Starting Level: $_assignedCefrLevel',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppConstants.space12),
                Text(
                  'Score: $_score / ${_questions.length} correct',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppConstants.space32),
                ElevatedButton(
                  onPressed: () async {
                    await ref
                        .read(onboardingStorageProvider)
                        .setCompletedOnboarding();
                    if (context.mounted) {
                      context.go('/main');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Start Learning Now'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final question = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Placement Test (${_currentIndex + 1}/${_questions.length})',
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.space24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (_currentIndex + 1) / _questions.length,
              backgroundColor: AppColors.divider,
              color: AppColors.primaryGreen,
            ),
            const SizedBox(height: AppConstants.space32),
            Row(
              children: [
                Expanded(
                  child: Text(
                    question.prompt,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.volume_up_rounded,
                    color: AppColors.primaryGreen,
                  ),
                  onPressed: () =>
                      ref.read(ttsServiceProvider).speak(question.prompt),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.space24),
            ...question.options.map((option) {
              final isSelected = _selectedOption == option;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () {
                    ref.read(ttsServiceProvider).speak(option);
                    setState(() {
                      _selectedOption = option;
                    });
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.softSuccess
                          : AppColors.surface,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryGreen
                            : AppColors.divider,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 18,
                        color: isSelected
                            ? AppColors.primaryGreenDark
                            : AppColors.textPrimary,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }),
            const Spacer(),
            ElevatedButton(
              onPressed: _selectedOption != null ? _submitAnswer : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                _currentIndex == _questions.length - 1
                    ? 'Finish Test'
                    : 'Next Question',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
