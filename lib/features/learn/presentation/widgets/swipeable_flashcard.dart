import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/storage/onboarding_storage.dart';

class SwipeableFlashcard extends ConsumerStatefulWidget {
  final VocabWord word;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;
  final bool canUseKeyboard;

  const SwipeableFlashcard({
    super.key,
    required this.word,
    required this.onSwipeLeft,
    required this.onSwipeRight,
    this.canUseKeyboard = false,
  });

  @override
  ConsumerState<SwipeableFlashcard> createState() => SwipeableFlashcardState();
}

class SwipeableFlashcardState extends ConsumerState<SwipeableFlashcard> with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late AudioPlayer _audioPlayer;
  late FlutterTts _flutterTts;
  late FocusNode _focusNode;
  bool _isFront = true;
  Offset _dragOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _audioPlayer = AudioPlayer();
    _flutterTts = FlutterTts();
    _focusNode = FocusNode();
    if (widget.canUseKeyboard) {
      _focusNode.requestFocus();
    }
  }

  Future<void> _speak(String text) async {
    final languageCode = ref.read(onboardingStorageProvider).targetLanguage ?? 'es';
    
    String ttsCode = 'es-ES';
    switch (languageCode) {
      case 'es': ttsCode = 'es-ES'; break;
      case 'fr': ttsCode = 'fr-FR'; break;
      case 'ja': ttsCode = 'ja-JP'; break;
      default: ttsCode = 'es-ES';
    }

    await _flutterTts.setLanguage(ttsCode);
    await _flutterTts.speak(text);
  }

  @override
  void dispose() {
    _flipController.dispose();
    _audioPlayer.dispose();
    _flutterTts.stop();
    _focusNode.dispose();
    super.dispose();
  }

  void flipCard() {
    if (_isFront) {
      _flipController.forward();
      if (widget.word.audioUrl != null) {
        _audioPlayer.play(UrlSource(widget.word.audioUrl!));
      } else {
        _speak(widget.word.word);
      }
    } else {
      _flipController.reverse();
    }
    setState(() {
      _isFront = !_isFront;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_dragOffset.dx > 100) {
      widget.onSwipeRight();
    } else if (_dragOffset.dx < -100) {
      widget.onSwipeLeft();
    } else {
      setState(() {
        _dragOffset = Offset.zero;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: _isFront
          ? 'Flashcard: ${widget.word.word}. Tap to reveal translation.'
          : 'Flashcard: ${widget.word.translation}. Swipe right if correct, left if incorrect.',
      hint: _isFront ? 'Double tap to flip' : 'Double tap to flip back',
      child: Focus(
        focusNode: _focusNode,
        autofocus: widget.canUseKeyboard,
        onKeyEvent: (node, event) {
          if (!widget.canUseKeyboard) return KeyEventResult.ignored;
          if (event is KeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
              widget.onSwipeLeft();
              return KeyEventResult.handled;
            } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
              widget.onSwipeRight();
              return KeyEventResult.handled;
            } else if (event.logicalKey == LogicalKeyboardKey.space || event.logicalKey == LogicalKeyboardKey.enter) {
              flipCard();
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        child: GestureDetector(
          onTap: flipCard,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: AnimatedBuilder(
          animation: _flipController,
          builder: (context, child) {
            final angle = _flipController.value * pi;
            final transform = Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle);

            bool showFront = angle < pi / 2;

            return Transform.translate(
              offset: _dragOffset,
              child: Transform(
                transform: transform,
                alignment: Alignment.center,
                child: showFront ? _buildFront() : _buildBack(),
              ),
            );
          },
        ), // AnimatedBuilder
      ), // GestureDetector
    ), // Focus
    ); // Semantics
  }

  Widget _buildFront() {
    return _buildCardContent(
      color: Colors.white,
      child: Stack(
        children: [
          Center(
            child: Text(
              widget.word.word,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.volume_up, size: 36, color: AppColors.primaryGreen),
              tooltip: 'Play pronunciation',
              onPressed: () => _speak(widget.word.word),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBack() {
    return Transform(
      transform: Matrix4.identity()..rotateY(pi),
      alignment: Alignment.center,
      child: _buildCardContent(
        color: AppColors.primaryGreen.withAlpha(51),
        child: Stack(
          children: [
            Center(
              child: Text(
                widget.word.translation,
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.volume_up, size: 36, color: AppColors.primaryGreen),
                tooltip: 'Play pronunciation',
                onPressed: () {
                  if (widget.word.audioUrl != null) {
                    _audioPlayer.play(UrlSource(widget.word.audioUrl!));
                  } else {
                    _speak(widget.word.word);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardContent({required Widget child, required Color color}) {
    return Container(
      width: double.infinity,
      height: 400,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
        border: Border.all(color: AppColors.divider),
      ),
      child: child,
    );
  }
}
