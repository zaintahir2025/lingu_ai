import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/quiz_question.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_constants.dart';
import '../../../../../core/audio/tts_service.dart';

class MultipleChoiceView extends ConsumerWidget {
  final QuizQuestion question;
  final String? selectedOption;
  final ValueChanged<String> onSelect;
  final bool isSubmitted;
  final bool isCorrect;

  const MultipleChoiceView({
    super.key,
    required this.question,
    required this.selectedOption,
    required this.onSelect,
    this.isSubmitted = false,
    this.isCorrect = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tts = ref.watch(ttsServiceProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                question.prompt,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.volume_up_rounded,
                color: AppColors.primaryGreen,
                size: 28,
              ),
              tooltip: 'Listen to question',
              onPressed: () => tts.speakEnglish(question.prompt),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.space24),
        ...question.options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          final isSelected = selectedOption == option;
          final isThisTheCorrectAnswer = option == question.correctAnswer;
          
          Color bgColor = isSelected ? AppColors.softSuccess : AppColors.surface;
          Color borderColor = isSelected ? AppColors.primaryGreen : AppColors.divider;
          Color textColor = isSelected ? AppColors.primaryGreenDark : AppColors.textPrimary;
          Color iconBgColor = isSelected ? AppColors.primaryGreen : AppColors.divider;
          Color iconTextColor = isSelected ? Colors.white : AppColors.textPrimary;
          
          if (isSubmitted) {
            if (isThisTheCorrectAnswer) {
              bgColor = AppColors.softSuccess;
              borderColor = AppColors.primaryGreen;
              textColor = AppColors.primaryGreenDark;
              iconBgColor = AppColors.primaryGreen;
              iconTextColor = Colors.white;
            } else if (isSelected && !isCorrect) {
              bgColor = AppColors.softError;
              borderColor = AppColors.heartRed;
              textColor = AppColors.heartRedDark;
              iconBgColor = AppColors.heartRed;
              iconTextColor = Colors.white;
            } else {
              bgColor = AppColors.surface;
              borderColor = AppColors.divider;
              textColor = AppColors.textSecondary;
              iconBgColor = AppColors.divider;
              iconTextColor = AppColors.textSecondary;
            }
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: AppConstants.space12),
            child: InkWell(
              onTap: () {
                if (!isSubmitted) {
                  tts.speak(option);
                  onSelect(option);
                }
              },
              borderRadius: BorderRadius.circular(AppConstants.radius16),
              child: Container(
                padding: const EdgeInsets.all(AppConstants.space16),
                decoration: BoxDecoration(
                  color: bgColor,
                  border: Border.all(
                    color: borderColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(AppConstants.radius16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: iconBgColor,
                        borderRadius: BorderRadius.circular(AppConstants.radius8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: iconTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppConstants.space16),
                    Expanded(
                      child: Text(
                        option,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: textColor,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.volume_up_outlined,
                        size: 20,
                        color: textColor.withValues(alpha: 0.6),
                      ),
                      onPressed: () => tts.speak(option),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class FillBlankView extends ConsumerWidget {
  final QuizQuestion question;
  final String answer;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit;
  final bool promptIsEnglish;
  final bool isSubmitted;
  final bool isCorrect;
  final String? correctAnswer;

  const FillBlankView({
    super.key,
    required this.question,
    required this.answer,
    required this.onChanged,
    required this.onSubmit,
    this.promptIsEnglish = false,
    this.isSubmitted = false,
    this.isCorrect = false,
    this.correctAnswer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tts = ref.watch(ttsServiceProvider);
    
    Color inputColor = AppColors.primaryGreen;
    Color fillColor = Colors.transparent;
    if (isSubmitted) {
      inputColor = isCorrect ? AppColors.primaryGreen : AppColors.heartRed;
      fillColor = isCorrect ? AppColors.softSuccess : AppColors.softError;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Fill in the blank',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: AppConstants.space24),
        Row(
          children: [
            Expanded(
              child: Text(
                question.prompt,
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.volume_up_rounded,
                color: AppColors.primaryGreen,
                size: 32,
              ),
              onPressed: () => promptIsEnglish
                  ? tts.speakEnglish(question.prompt)
                  : tts.speakTarget(question.prompt),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.space24),
        TextField(
          autofocus: true,
          readOnly: isSubmitted,
          controller: TextEditingController(text: answer)
            ..selection = TextSelection.collapsed(offset: answer.length),
          style: TextStyle(
            color: isSubmitted ? inputColor : AppColors.textPrimary,
            fontWeight: isSubmitted ? FontWeight.bold : FontWeight.normal,
          ),
          decoration: InputDecoration(
            hintText: 'Type your answer...',
            filled: isSubmitted,
            fillColor: fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radius16),
              borderSide: BorderSide(
                color: isSubmitted ? inputColor : AppColors.divider, 
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radius16),
              borderSide: BorderSide(
                color: inputColor,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radius16),
              borderSide: BorderSide(
                color: isSubmitted ? inputColor : AppColors.divider,
                width: 2,
              ),
            ),
          ),
          onChanged: onChanged,
          onSubmitted: (_) => onSubmit(),
        ),
      ],
    );
  }
}

class TranslationView extends ConsumerWidget {
  final QuizQuestion question;
  final String answer;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit;
  final bool isSubmitted;
  final bool isCorrect;
  final String? correctAnswer;

  const TranslationView({
    super.key,
    required this.question,
    required this.answer,
    required this.onChanged,
    required this.onSubmit,
    this.isSubmitted = false,
    this.isCorrect = false,
    this.correctAnswer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FillBlankView(
      question: question,
      answer: answer,
      onChanged: onChanged,
      onSubmit: onSubmit,
      promptIsEnglish: true,
      isSubmitted: isSubmitted,
      isCorrect: isCorrect,
      correctAnswer: correctAnswer,
    );
  }
}

class ListeningView extends ConsumerStatefulWidget {
  final QuizQuestion question;
  final String answer;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit;
  final bool isSubmitted;
  final bool isCorrect;
  final String? correctAnswer;

  const ListeningView({
    super.key,
    required this.question,
    required this.answer,
    required this.onChanged,
    required this.onSubmit,
    this.isSubmitted = false,
    this.isCorrect = false,
    this.correctAnswer,
  });

  @override
  ConsumerState<ListeningView> createState() => _ListeningViewState();
}

class _ListeningViewState extends ConsumerState<ListeningView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playAudio();
    });
  }

  void _playAudio() {
    ref.read(ttsServiceProvider).speak(widget.question.prompt);
  }

  @override
  Widget build(BuildContext context) {
    Color inputColor = AppColors.primaryGreen;
    Color fillColor = Colors.transparent;
    if (widget.isSubmitted) {
      inputColor = widget.isCorrect ? AppColors.primaryGreen : AppColors.heartRed;
      fillColor = widget.isCorrect ? AppColors.softSuccess : AppColors.softError;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Type what you hear',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: AppConstants.space24),
        Center(
          child: InkWell(
            onTap: _playAudio,
            borderRadius: BorderRadius.circular(60),
            child: Container(
              padding: const EdgeInsets.all(AppConstants.space24),
              decoration: const BoxDecoration(
                color: AppColors.primaryGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.volume_up_rounded,
                color: Colors.white,
                size: 48,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppConstants.space32),
        TextField(
          autofocus: true,
          readOnly: widget.isSubmitted,
          controller: TextEditingController(text: widget.answer)
            ..selection = TextSelection.collapsed(offset: widget.answer.length),
          style: TextStyle(
            color: widget.isSubmitted ? inputColor : AppColors.textPrimary,
            fontWeight: widget.isSubmitted ? FontWeight.bold : FontWeight.normal,
          ),
          decoration: InputDecoration(
            hintText: 'Type your answer...',
            filled: widget.isSubmitted,
            fillColor: fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radius16),
              borderSide: BorderSide(
                color: widget.isSubmitted ? inputColor : AppColors.divider, 
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radius16),
              borderSide: BorderSide(
                color: inputColor,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radius16),
              borderSide: BorderSide(
                color: widget.isSubmitted ? inputColor : AppColors.divider,
                width: 2,
              ),
            ),
          ),
          onChanged: widget.onChanged,
          onSubmitted: (_) => widget.onSubmit(),
        ),
      ],
    );
  }
}
