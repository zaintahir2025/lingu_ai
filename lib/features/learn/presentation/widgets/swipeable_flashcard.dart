import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/audio/tts_service.dart';
import '../../../../core/database/database.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:lingu_ai/l10n/app_localizations.dart';

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

  double _getDynamicFontSize(String text) {
    if (text.length > 25) return 20;
    if (text.length > 15) return 26;
    if (text.length > 10) return 32;
    return 40;
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
                  child: showFront ? _buildFront(context) : _buildBack(context),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFront(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final fontSize = _getDynamicFontSize(widget.word.word);

    return _buildCardContent(
      color: Colors.white,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 70),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            widget.word.word,
                            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.volume_up_rounded, size: 28, color: AppColors.primaryGreen),
                        tooltip: 'Listen to word',
                        onPressed: () => _speakTarget(widget.word.word),
                      ),
                    ],
                  ),
                  if (widget.word.exampleSentence != null) ...[
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () => _speakTarget(widget.word.exampleSentence!),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.volume_up_outlined, size: 22, color: AppColors.primaryGreenDark),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                widget.word.exampleSentence!,
                                style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.black87),
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.flip_camera_android_rounded, size: 14, color: AppColors.primaryGreen),
                  const SizedBox(width: 4),
                  Text(
                    loc.tapCardToReveal,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryGreenDark),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.1),
                foregroundColor: AppColors.primaryGreenDark,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              icon: const Icon(Icons.volume_up_rounded, size: 18),
              label: Text(loc.readAll, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
              onPressed: () {
                final sentence = widget.word.exampleSentence;
                if (sentence != null && sentence.isNotEmpty) {
                  _speakTarget('${widget.word.word}. $sentence');
                } else {
                  _speakTarget(widget.word.word);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBack(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final fontSize = _getDynamicFontSize(widget.word.translation);

    return Transform(
      transform: Matrix4.identity()..rotateY(pi),
      alignment: Alignment.center,
      child: _buildCardContent(
        color: AppColors.primaryGreen.withAlpha(51),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 70),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              widget.word.translation,
                              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.volume_up_rounded, size: 28, color: AppColors.primaryGreen),
                          tooltip: 'Listen to translation',
                          onPressed: () => _speakEnglish(widget.word.translation),
                        ),
                      ],
                    ),
                    if (widget.word.exampleTranslation != null) ...[
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () => _speakEnglish(widget.word.exampleTranslation!),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.volume_up_outlined, size: 22, color: AppColors.primaryGreenDark),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  widget.word.exampleTranslation!,
                                  style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.black87),
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.touch_app_rounded, size: 14, color: AppColors.primaryGreenDark),
                    const SizedBox(width: 4),
                    Text(
                      loc.tapToFlipBack,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryGreenDark),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.2),
                  foregroundColor: AppColors.primaryGreenDark,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                icon: const Icon(Icons.volume_up_rounded, size: 18),
                label: Text(loc.readAll, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                onPressed: () {
                  final sentence = widget.word.exampleTranslation;
                  if (sentence != null && sentence.isNotEmpty) {
                    _speakEnglish('${widget.word.translation}. $sentence');
                  } else {
                    _speakEnglish(widget.word.translation);
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
