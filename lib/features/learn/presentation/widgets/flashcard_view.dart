import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/learn_repository.dart';
import 'package:drift/drift.dart' show Value;
import '../../../../core/database/database.dart';
import '../widgets/swipeable_flashcard.dart';
import '../../../../core/theme/app_colors.dart';

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
  final List<VocabWord> _history = [];
  int _totalDeckCount = 0;
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
      _words = List.from(words);
      _history.clear();
      _totalDeckCount = words.length;
      _isLoading = false;
    });
  }

  void _markDone() {
    if (_words.isEmpty) return;
    final currentWord = _words.removeAt(0);
    _history.add(currentWord);
    setState(() {});

    if (_words.isEmpty) {
      _showQuizPromptDialog();
    }
  }

  void _markNotDone() {
    if (_words.isEmpty) return;
    final currentWord = _words.removeAt(0);
    _history.add(currentWord);
    
    // Log persistent mistake/weak word into DB for SRS Daily Review
    try {
      final db = ref.read(databaseProvider);
      db.into(db.vocabWords).insertOnConflictUpdate(
        VocabWordsCompanion.insert(
          id: Value(currentWord.id),
          lessonId: currentWord.lessonId,
          word: currentWord.word,
          translation: currentWord.translation,
          easinessFactor: const Value(1.5), // Lower easiness factor for SRS
        ),
      );
    } catch (_) {}

    setState(() {
      // Re-queue card to end of deck
      _words.add(currentWord);
    });
  }

  void _goPreviousCard() {
    if (_history.isEmpty) return;
    final lastWord = _history.removeLast();
    setState(() {
      _words.insert(0, lastWord);
    });
  }

  void _showQuizPromptDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: AppColors.primaryGreen, size: 28),
            SizedBox(width: 10),
            Text('Deck Completed! 🎉', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          'You have reviewed all vocabulary flashcards in this deck.\n\nAre you ready to test your knowledge in the Quiz?',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _loadWords(); // Reset deck for extra review
            },
            child: const Text('Review Again', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () {
              Navigator.pop(context);
              widget.onComplete();
            },
            child: const Text('Start Quiz', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        _markDone(); 
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        _markNotDone(); 
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
            const Icon(Icons.stars_rounded, size: 64, color: AppColors.primaryGreen),
            const SizedBox(height: 16),
            const Text(
              'All Flashcards Done!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              ),
              onPressed: widget.onComplete,
              child: const Text('Proceed to Quiz', style: TextStyle(fontWeight: FontWeight.bold)),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cards Remaining: ${_words.length}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreenDark,
                      ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Text(
                    'Deck Total: $_totalDeckCount',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: SwipeableFlashcard(
                  key: ValueKey(_words.first.id),
                  word: _words.first,
                  onSwipeLeft: _markNotDone, 
                  onSwipeRight: _markDone, 
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surface,
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.divider, width: 1.5),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.arrow_back_ios_rounded, size: 18),
                label: const Text(
                  'Previous',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                onPressed: _history.isNotEmpty ? _goPreviousCard : null,
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[50],
                  foregroundColor: Colors.red[700],
                  side: const BorderSide(color: Colors.red, width: 1.5),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.refresh_rounded, color: Colors.red),
                label: const Text(
                  'Not Done',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                onPressed: _markNotDone,
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                ),
                icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
                label: const Text(
                  'Done',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                onPressed: _markDone,
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
