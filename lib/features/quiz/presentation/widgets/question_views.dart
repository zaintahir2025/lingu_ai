import 'package:flutter/material.dart';

import '../../../../core/audio/tts_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_constants.dart';
import '../../domain/models/quiz_question.dart';

class MultipleChoiceView extends StatelessWidget {
  final QuizQuestion question;
  final String? selectedOption;
  final ValueChanged<String> onSelect;
  final bool isSubmitted;
  final bool? isCorrect;
  final String? correctAnswer;

  const MultipleChoiceView({
    super.key,
    required this.question,
    required this.selectedOption,
    required this.onSelect,
    this.isSubmitted = false,
    this.isCorrect,
    this.correctAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final tts = TtsService();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          question.prompt,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppConstants.space32),
        ...List.generate(question.options.length, (index) {
          final option = question.options[index];
          final isSelected = selectedOption == option;
          
          Color bgColor = isSelected ? AppColors.softSuccess : AppColors.surface;
          Color borderColor = isSelected ? AppColors.primaryGreen : AppColors.divider;
          Color iconBgColor = isSelected ? AppColors.primaryGreen : AppColors.divider;
          Color iconTextColor = isSelected ? Colors.white : AppColors.textPrimary;
          Color textColor = isSelected ? AppColors.primaryGreenDark : AppColors.textPrimary;

          if (isSubmitted) {
            if (option == correctAnswer) {
              bgColor = AppColors.softSuccess;
              borderColor = AppColors.primaryGreen;
              iconBgColor = AppColors.primaryGreen;
              iconTextColor = Colors.white;
              textColor = AppColors.primaryGreenDark;
            } else if (isSelected && isCorrect == false) {
              bgColor = AppColors.softError;
              borderColor = AppColors.heartRed;
              iconBgColor = AppColors.heartRed;
              iconTextColor = Colors.white;
              textColor = AppColors.softErrorText;
            }
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: AppConstants.space16),
            child: InkWell(
              onTap: () {
                if (isSubmitted) return;
                onSelect(option);
                tts.speak(option);
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
                        borderRadius: BorderRadius.circular(
                          AppConstants.radius8,
                        ),
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

class FillBlankView extends StatelessWidget {
  final QuizQuestion question;
  final String answer;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit;
  final bool isSubmitted;
  final bool? isCorrect;

  const FillBlankView({
    super.key,
    required this.question,
    required this.answer,
    required this.onChanged,
    required this.onSubmit,
    this.isSubmitted = false,
    this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = AppColors.primaryGreen;
    if (isSubmitted) {
      borderColor = isCorrect == true ? AppColors.primaryGreen : AppColors.heartRed;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          question.prompt,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppConstants.space32),
        TextField(
          autofocus: true,
          readOnly: isSubmitted,
          decoration: InputDecoration(
            hintText: 'Type the missing word...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radius16),
              borderSide: BorderSide(color: borderColor, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radius16),
              borderSide: BorderSide(color: isSubmitted ? borderColor : AppColors.divider, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radius16),
              borderSide: BorderSide(color: borderColor, width: 2),
            ),
          ),
          onChanged: onChanged,
          onSubmitted: (_) => onSubmit(),
          controller: TextEditingController.fromValue(
            TextEditingValue(
              text: answer,
              selection: TextSelection.collapsed(offset: answer.length),
            ),
          ),
        ),
      ],
    );
  }
}

class TranslationView extends StatelessWidget {
  final QuizQuestion question;
  final String answer;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit;
  final bool isSubmitted;
  final bool? isCorrect;

  const TranslationView({
    super.key,
    required this.question,
    required this.answer,
    required this.onChanged,
    required this.onSubmit,
    this.isSubmitted = false,
    this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    final tts = TtsService();

    Color borderColor = AppColors.primaryGreen;
    if (isSubmitted) {
      borderColor = isCorrect == true ? AppColors.primaryGreen : AppColors.heartRed;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Translate this sentence',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppConstants.space16),
        Container(
          padding: const EdgeInsets.all(AppConstants.space24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppConstants.radius16),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.volume_up_rounded,
                  size: 32,
                  color: AppColors.primaryGreen,
                ),
                onPressed: () => tts.speak(question.prompt),
              ),
              const SizedBox(height: AppConstants.space16),
              Text(
                question.prompt,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppConstants.space32),
        TextField(
          autofocus: true,
          readOnly: isSubmitted,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Type your translation here...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radius16),
              borderSide: BorderSide(color: borderColor, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radius16),
              borderSide: BorderSide(color: isSubmitted ? borderColor : AppColors.divider, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radius16),
              borderSide: BorderSide(color: borderColor, width: 2),
            ),
          ),
          onChanged: onChanged,
          onSubmitted: (_) => onSubmit(),
          controller: TextEditingController.fromValue(
            TextEditingValue(
              text: answer,
              selection: TextSelection.collapsed(offset: answer.length),
            ),
          ),
        ),
      ],
    );
  }
}

class ListeningView extends StatelessWidget {
  final QuizQuestion question;
  final String answer;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit;
  final bool isSubmitted;
  final bool? isCorrect;

  const ListeningView({
    super.key,
    required this.question,
    required this.answer,
    required this.onChanged,
    required this.onSubmit,
    this.isSubmitted = false,
    this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    final tts = TtsService();
    
    Color borderColor = AppColors.primaryGreen;
    if (isSubmitted) {
      borderColor = isCorrect == true ? AppColors.primaryGreen : AppColors.heartRed;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Type what you hear',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppConstants.space32),
        Center(
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.volume_up_rounded,
                size: 64,
                color: AppColors.primaryGreen,
              ),
              onPressed: () => tts.speak(question.prompt),
            ),
          ),
        ),
        const SizedBox(height: AppConstants.space48),
        TextField(
          autofocus: true,
          readOnly: isSubmitted,
          decoration: InputDecoration(
            hintText: 'Type the exact words...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radius16),
              borderSide: BorderSide(color: borderColor, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radius16),
              borderSide: BorderSide(color: isSubmitted ? borderColor : AppColors.divider, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radius16),
              borderSide: BorderSide(color: borderColor, width: 2),
            ),
          ),
          onChanged: onChanged,
          onSubmitted: (_) => onSubmit(),
          controller: TextEditingController.fromValue(
            TextEditingValue(
              text: answer,
              selection: TextSelection.collapsed(offset: answer.length),
            ),
          ),
        ),
      ],
    );
  }
}
