import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/learn_repository.dart';
import '../../../../core/database/database.dart';
import '../widgets/swipeable_flashcard.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:lingu_ai/l10n/app_localizations.dart';

class FlashcardView extends ConsumerStatefulWidget {
  final int lessonId;
  final VoidCallback onComplete;

  const FlashcardView({
    super.key, 
    required this.lessonId,
    required this.onComplete,
  });

  @override
  ConsumerState<FlashcardView> createState() => _FlashcardViewState();
}

class _FlashcardViewState extends ConsumerState<FlashcardView> {
  List<VocabWord> _words = [];
  bool _isLoading = true;
  final GlobalKey<SwipeableFlashcardState> _cardKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords() async {
    final words = await ref.read(learnRepositoryProvider).getVocabForLesson(widget.lessonId);
    setState(() {
      _words = words;
      _isLoading = false;
    });
  }

  void _nextCard() {
    if (_words.isNotEmpty) {
      setState(() {
        _words.removeAt(0);
      });
    }
    if (_words.isEmpty) {
      widget.onComplete();
    }
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        _nextCard(); 
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        _nextCard(); 
      } else if (event.logicalKey == LogicalKeyboardKey.space || event.logicalKey == LogicalKeyboardKey.arrowUp) {
        _cardKey.currentState?.flipCard();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_words.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.noVocabForLesson),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: widget.onComplete,
              child: const Text('Continue'),
            ),
          ],
        ),
      );
    }

    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKeyEvent: _handleKeyEvent,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              AppLocalizations.of(context)!.wordsLeft(_words.length),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: SwipeableFlashcard(
                  key: ValueKey(_words.first.id),
                  word: _words.first,
                  onSwipeLeft: _nextCard, 
                  onSwipeRight: _nextCard, 
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[100],
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                onPressed: _nextCard,
                child: Text(AppLocalizations.of(context)!.stillLearningLeft),
              ),
              const SizedBox(width: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                onPressed: _nextCard,
                child: Text(AppLocalizations.of(context)!.gotItRight),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
