import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/audio/tts_service.dart';
import '../../../../core/database/database.dart';
import '../../../../core/theme/app_colors.dart';

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
    _focusNode = FocusNode();
    if (widget.canUseKeyboard) {
      _focusNode.requestFocus();
    }
  }

  void _speakTarget(String text) {
    ref.read(ttsServiceProvider).speakTarget(text);
  }

  void _speakEnglish(String text) {
    ref.read(ttsServiceProvider).speakEnglish(text);
  }

  @override
  void dispose() {
    _flipController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void flipCard() {
    if (_isFront) {
      _flipController.forward();
      _speakTarget(widget.word.word);
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.word.word,
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                if (widget.word.exampleSentence != null) ...[
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      widget.word.exampleSentence!,
                      style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.flip_camera_android_rounded, size: 16, color: AppColors.primaryGreen),
                  SizedBox(width: 6),
                  Text(
                    'Tap card to reveal meaning',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryGreenDark),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.volume_up, size: 36, color: AppColors.primaryGreen),
              tooltip: 'Play pronunciation',
              onPressed: () => _speakTarget(widget.word.word),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.word.translation,
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  if (widget.word.exampleTranslation != null) ...[
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        widget.word.exampleTranslation!,
                        style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic, color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.touch_app_rounded, size: 16, color: AppColors.primaryGreenDark),
                    SizedBox(width: 6),
                    Text(
                      'Tap to flip back',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryGreenDark),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.volume_up, size: 36, color: AppColors.primaryGreen),
                tooltip: 'Play English pronunciation',
                onPressed: () => _speakEnglish(widget.word.translation),
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
