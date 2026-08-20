import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';
import '../../database/database.dart';
import 'duolingo_audio_buttons.dart';
import 'duolingo_word_strength_meter.dart';

/// Wordpecker-inspired 3D Interactive Flip Card with Phonetics (IPA), Audio & Examples
class WordpeckerFlipCard extends StatefulWidget {
  final VocabWord word;
  final String targetLanguage;
  final bool isFlipped;
  final VoidCallback onTap;

  const WordpeckerFlipCard({
    super.key,
    required this.word,
    required this.targetLanguage,
    required this.isFlipped,
    required this.onTap,
  });

  @override
  State<WordpeckerFlipCard> createState() => _WordpeckerFlipCardState();
}

class _WordpeckerFlipCardState extends State<WordpeckerFlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
    );

    if (widget.isFlipped) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(WordpeckerFlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipped != oldWidget.isFlipped) {
      if (widget.isFlipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getPhonetics(String word, String lang) {
    final lower = word.toLowerCase().trim();
    final dict = {
      'hola': '[ˈo.la]',
      'gracias': '[ˈɡɾa.sjas]',
      'por favor': '[poɾ faˈβoɾ]',
      'buenos días': '[ˈbwe.nos ˈdi.as]',
      'adiós': '[aˈðjos]',
      'bonjour': '[bɔ̃.ʒuʁ]',
      'merci': '[mɛʁ.si]',
      'guten tag': '[ˈɡuː.tən taːk]',
      'danke': '[ˈdaŋ.kə]',
      'konnichiwa': '[koɴ.ni.tɕi.wa]',
      'arigatou': '[a.ɾi.ɡa.toː]',
    };
    return dict[lower] ?? '[/$lower/]';
  }

  String _getExampleSentence(String word) {
    final lower = word.toLowerCase().trim();
    final examples = {
      'hola': '¡Hola! ¿Cómo estás hoy?',
      'gracias': 'Muchas gracias por tu ayuda.',
      'por favor': 'Un café, por favor.',
      'buenos días': 'Buenos días a todos.',
      'adiós': 'Adiós, nos vemos mañana.',
      'bonjour': 'Bonjour tout le monde!',
      'merci': 'Merci beaucoup!',
      'guten tag': 'Guten Tag, wie geht es Ihnen?',
      'danke': 'Vielen Dank für Ihre Hilfe.',
    };
    return examples[lower] ?? 'Practice using "$word" in daily conversation.';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * math.pi;
          final isFront = angle < (math.pi / 2);

          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0012)
              ..rotateY(angle),
            alignment: Alignment.center,
            child: isFront ? _buildFront(context) : _buildBack(context),
          );
        },
      ),
    );
  }

  Widget _buildFront(BuildContext context) {
    final phonetics = _getPhonetics(widget.word.word, widget.targetLanguage);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.space24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radius24),
        border: Border.all(color: AppColors.primaryGreen, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'Wordpecker Flashcard',
              style: TextStyle(
                color: AppColors.primaryGreenDark,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: AppConstants.space24),
          Text(
            widget.word.word,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            phonetics,
            style: const TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: AppColors.gemBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.space24),
          DuolingoAudioButtons(
            text: widget.word.word,
            targetLanguage: widget.targetLanguage,
            size: 54,
          ),
          const SizedBox(height: AppConstants.space32),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.touch_app_rounded, color: AppColors.textSecondary, size: 20),
              SizedBox(width: 6),
              Text(
                'Tap card to reveal translation 🔄',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBack(BuildContext context) {
    final example = _getExampleSentence(widget.word.word);
    final strengthBars = widget.word.interval >= 21
        ? 4
        : (widget.word.interval >= 10 ? 3 : (widget.word.interval >= 3 ? 2 : 1));

    return Transform(
      transform: Matrix4.identity()..rotateY(math.pi),
      alignment: Alignment.center,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppConstants.space24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radius24),
          border: Border.all(color: AppColors.gemBlue, width: 2.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.gemBlue.withValues(alpha: 0.15),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DuolingoWordStrengthMeter(strength: strengthBars),
            const SizedBox(height: AppConstants.space20),
            Text(
              widget.word.translation,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.space20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                children: [
                  const Text(
                    'Example Usage:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    example,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.space20),
            DuolingoAudioButtons(
              text: widget.word.translation,
              targetLanguage: 'en-US',
              size: 48,
            ),
          ],
        ),
      ),
    );
  }
}
