import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_constants.dart';
import '../../../../core/audio/tts_service.dart';
import '../../../learn/domain/repositories/learn_repository.dart';

class WordMatchingExerciseView extends ConsumerStatefulWidget {
  final int lessonId;
  final VoidCallback onComplete;

  const WordMatchingExerciseView({
    super.key,
    required this.lessonId,
    required this.onComplete,
  });

  @override
  ConsumerState<WordMatchingExerciseView> createState() => _WordMatchingExerciseViewState();
}

class _WordMatchingExerciseViewState extends ConsumerState<WordMatchingExerciseView> {
  String? _selectedTargetWord;
  String? _selectedTranslation;
  final Set<String> _matchedWords = {};
  bool _isLoading = true;
  List<Map<String, String>> _wordPairs = [];
  List<String> _targetWords = [];
  List<String> _translations = [];

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords() async {
    final repo = ref.read(learnRepositoryProvider);
    final vocab = await repo.getVocabForLesson(widget.lessonId);
    
    if (vocab.isNotEmpty) {
      final sample = vocab.take(4).toList();
      _wordPairs = sample.map((v) => {'word': v.word, 'translation': v.translation}).toList();
      _targetWords = _wordPairs.map((p) => p['word']!).toList()..shuffle();
      _translations = _wordPairs.map((p) => p['translation']!).toList()..shuffle();
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _checkMatch() {
    if (_selectedTargetWord == null || _selectedTranslation == null) return;

    final pair = _wordPairs.firstWhere(
      (p) => p['word'] == _selectedTargetWord && p['translation'] == _selectedTranslation,
      orElse: () => {},
    );

    if (pair.isNotEmpty) {
      // Matched correctly!
      ref.read(ttsServiceProvider).speak(_selectedTargetWord!);
      setState(() {
        _matchedWords.add(_selectedTargetWord!);
        _selectedTargetWord = null;
        _selectedTranslation = null;
      });

      if (_matchedWords.length == _wordPairs.length) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) widget.onComplete();
        });
      }
    } else {
      // Incorrect match
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not a match. Try again!'),
          duration: Duration(seconds: 1),
          backgroundColor: AppColors.heartRed,
        ),
      );
      setState(() {
        _selectedTargetWord = null;
        _selectedTranslation = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_wordPairs.isEmpty) {
      return Center(
        child: ElevatedButton(
          onPressed: widget.onComplete,
          child: const Text('Continue to Quiz'),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(AppConstants.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Stage 2: Word Matching',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap a target word on the left, then tap its matching meaning on the right to memorize it before sentence writing.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: AppConstants.space24),
          Expanded(
            child: Row(
              children: [
                // Left Column: Target Words
                Expanded(
                  child: ListView.builder(
                    itemCount: _targetWords.length,
                    itemBuilder: (context, index) {
                      final word = _targetWords[index];
                      final isMatched = _matchedWords.contains(word);
                      final isSelected = _selectedTargetWord == word;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: isMatched
                              ? null
                              : () {
                                  setState(() {
                                    _selectedTargetWord = word;
                                  });
                                  _checkMatch();
                                },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isMatched
                                  ? AppColors.softSuccess
                                  : isSelected
                                      ? AppColors.primaryGreen.withValues(alpha: 0.2)
                                      : AppColors.surface,
                              border: Border.all(
                                color: isMatched
                                    ? AppColors.primaryGreen
                                    : isSelected
                                        ? AppColors.primaryGreen
                                        : AppColors.divider,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    word,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isMatched ? AppColors.primaryGreenDark : AppColors.textPrimary,
                                      decoration: isMatched ? TextDecoration.lineThrough : null,
                                    ),
                                  ),
                                ),
                                if (isMatched) const Icon(Icons.check_circle, color: AppColors.primaryGreen, size: 20),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // Right Column: Meanings
                Expanded(
                  child: ListView.builder(
                    itemCount: _translations.length,
                    itemBuilder: (context, index) {
                      final trans = _translations[index];
                      final isMatched = _wordPairs.any((p) => p['translation'] == trans && _matchedWords.contains(p['word']));
                      final isSelected = _selectedTranslation == trans;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: isMatched
                              ? null
                              : () {
                                  setState(() {
                                    _selectedTranslation = trans;
                                  });
                                  _checkMatch();
                                },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isMatched
                                  ? AppColors.softSuccess
                                  : isSelected
                                      ? AppColors.primaryGreen.withValues(alpha: 0.2)
                                      : AppColors.surface,
                              border: Border.all(
                                color: isMatched
                                    ? AppColors.primaryGreen
                                    : isSelected
                                        ? AppColors.primaryGreen
                                        : AppColors.divider,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              trans,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: isMatched ? AppColors.primaryGreenDark : AppColors.textPrimary,
                                decoration: isMatched ? TextDecoration.lineThrough : null,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _matchedWords.length == _wordPairs.length ? widget.onComplete : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(_matchedWords.length == _wordPairs.length ? 'Continue to Quiz' : 'Match All Words to Continue'),
          ),
        ],
      ),
    );
  }
}
