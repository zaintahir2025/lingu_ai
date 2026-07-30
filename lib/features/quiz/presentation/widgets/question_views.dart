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

  const MultipleChoiceView({
    super.key,
    required this.question,
    required this.selectedOption,
    required this.onSelect,
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
              icon: const Icon(Icons.volume_up_rounded, color: AppColors.primaryGreen, size: 28),
              tooltip: 'Listen to question',
              onPressed: () => tts.speak(question.prompt),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.space24),
        ...question.options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          final isSelected = selectedOption == option;

          return Padding(
            padding: const EdgeInsets.only(bottom: AppConstants.space12),
            child: InkWell(
              onTap: () {
                tts.speak(option);
                onSelect(option);
              },
              borderRadius: BorderRadius.circular(AppConstants.radius16),
              child: Container(
                padding: const EdgeInsets.all(AppConstants.space16),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.softSuccess : AppColors.surface,
                  border: Border.all(
                    color: isSelected ? AppColors.primaryGreen : AppColors.divider,
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
                        color: isSelected ? AppColors.primaryGreen : AppColors.divider,
                        borderRadius: BorderRadius.circular(AppConstants.radius8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppConstants.space16),
                    Expanded(
                      child: Text(
                        option,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: isSelected ? AppColors.primaryGreenDark : AppColors.textPrimary,
                            ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.volume_up_outlined, size: 20, color: AppColors.textSecondary),
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

  const FillBlankView({
    super.key,
    required this.question,
    required this.answer,
    required this.onChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tts = ref.watch(ttsServiceProvider);

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
              icon: const Icon(Icons.volume_up_rounded, color: AppColors.primaryGreen, size: 32),
              onPressed: () => tts.speak(question.prompt),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.space24),
        TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Type your answer...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radius16),
              borderSide: const BorderSide(color: AppColors.divider, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radius16),
              borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
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

  const TranslationView({
    super.key,
    required this.question,
    required this.answer,
    required this.onChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FillBlankView(
      question: question,
      answer: answer,
      onChanged: onChanged,
      onSubmit: onSubmit,
    );
  }
}

class ListeningView extends ConsumerStatefulWidget {
  final QuizQuestion question;
  final String answer;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit;

  const ListeningView({
    super.key,
    required this.question,
    required this.answer,
    required this.onChanged,
    required this.onSubmit,
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
          decoration: InputDecoration(
            hintText: 'Type your answer...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radius16),
              borderSide: const BorderSide(color: AppColors.divider, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radius16),
              borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
            ),
          ),
          onChanged: widget.onChanged,
          onSubmitted: (_) => widget.onSubmit(),
        ),
      ],
    );
  }
}
