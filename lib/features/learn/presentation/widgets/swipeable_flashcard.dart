import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../../core/database/database.dart';
import '../../../../core/theme/app_colors.dart';

class SwipeableFlashcard extends StatefulWidget {
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
  State<SwipeableFlashcard> createState() => SwipeableFlashcardState();
}

class SwipeableFlashcardState extends State<SwipeableFlashcard> with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late AudioPlayer _audioPlayer;
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
  }

  @override
  void dispose() {
    _flipController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void flipCard() {
    if (_isFront) {
      _flipController.forward();
      if (widget.word.audioUrl != null) {
        _audioPlayer.play(UrlSource(widget.word.audioUrl!));
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
        ),
      ),
    );
  }

  Widget _buildFront() {
    return _buildCardContent(
      color: Colors.white,
      child: Center(
        child: Text(
          widget.word.word,
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
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
            if (widget.word.audioUrl != null)
              Positioned(
                bottom: 20,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.volume_up, size: 36, color: AppColors.primaryGreen),
                  tooltip: 'Play pronunciation',
                  onPressed: () => _audioPlayer.play(UrlSource(widget.word.audioUrl!)),
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
