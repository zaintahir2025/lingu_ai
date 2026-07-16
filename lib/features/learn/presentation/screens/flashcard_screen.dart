import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/repositories/learn_repository.dart';
import '../../../../core/database/database.dart';
import '../widgets/swipeable_flashcard.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:lingu_ai/l10n/app_localizations.dart';

class FlashcardScreen extends ConsumerStatefulWidget {
  final int lessonId;

  const FlashcardScreen({super.key, required this.lessonId});

  @override
  ConsumerState<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends ConsumerState<FlashcardScreen> {
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
      context.pop();
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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_words.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(AppLocalizations.of(context)!.noVocabForLesson)),
      );
    }

    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.wordsLeft(_words.length)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: SwipeableFlashcard(
                        // force widget recreation when word changes
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
