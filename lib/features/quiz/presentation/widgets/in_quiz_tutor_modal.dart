import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/mascot/piko_mascot.dart';
import '../../../../core/audio/tts_service.dart';
import '../../../tutor/data/repositories/tutor_repository.dart';
import '../../../tutor/presentation/screens/ai_settings_screen.dart';

class InQuizTutorModal extends ConsumerStatefulWidget {
  final String questionPrompt;
  final String userAnswer;
  final String correctAnswer;
  final String explanation;

  const InQuizTutorModal({
    super.key,
    required this.questionPrompt,
    required this.userAnswer,
    required this.correctAnswer,
    required this.explanation,
  });

  static Future<void> show(
    BuildContext context, {
    required String questionPrompt,
    required String userAnswer,
    required String correctAnswer,
    required String explanation,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: InQuizTutorModal(
          questionPrompt: questionPrompt,
          userAnswer: userAnswer,
          correctAnswer: correctAnswer,
          explanation: explanation,
        ),
      ),
    );
  }

  @override
  ConsumerState<InQuizTutorModal> createState() => _InQuizTutorModalState();
}

class _InQuizTutorModalState extends ConsumerState<InQuizTutorModal> {
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchInitialExplanation();
  }

  @override
  void dispose() {
    _chatController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchInitialExplanation() async {
    setState(() => _isLoading = true);
    final prompt =
        'Question: "${widget.questionPrompt}". I chose: "${widget.userAnswer}". Correct answer: "${widget.correctAnswer}". Brief explanation: ${widget.explanation}. Explain in simple, friendly terms why my answer was incorrect and how to remember the correct one.';

    _messages.add({'sender': 'user', 'text': prompt});

    final repo = ref.read(tutorRepositoryProvider);
    StringBuffer replyBuffer = StringBuffer();
    _messages.add({'sender': 'tutor', 'text': ''});

    await for (final chunk in repo.streamTutorMessage(prompt, [
      widget.correctAnswer,
    ])) {
      replyBuffer.write(chunk);
      if (mounted) {
        setState(() {
          _messages.last['text'] = replyBuffer.toString();
        });
      }
    }

    if (mounted) {
      setState(() => _isLoading = false);
      // Humanized vocal explanation
      TtsService().speakTarget(
        replyBuffer.toString(),
        emotion: TtsEmotion.encouraging,
      );
    }
  }

  void _sendCustomQuestion() async {
    final text = _chatController.text.trim();
    if (text.isEmpty || _isLoading) return;

    _chatController.clear();
    setState(() {
      _messages.add({'sender': 'user', 'text': text});
      _messages.add({'sender': 'tutor', 'text': ''});
      _isLoading = true;
    });

    final repo = ref.read(tutorRepositoryProvider);
    StringBuffer replyBuffer = StringBuffer();

    await for (final chunk in repo.streamTutorMessage(text, [
      widget.correctAnswer,
    ])) {
      replyBuffer.write(chunk);
      if (mounted) {
        setState(() {
          _messages.last['text'] = replyBuffer.toString();
        });
      }
    }

    if (mounted) {
      setState(() => _isLoading = false);
      TtsService().speakTarget(
        replyBuffer.toString(),
        emotion: TtsEmotion.expressive,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeProvider = ref.watch(aiSettingsStorageProvider).provider;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Drag handle & Header
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                const PikoMascot(pose: PikoPose.thinking, size: 45),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AI Tutor Explanation 🤖',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Engine: $activeProvider',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () {
                    TtsService().stop();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['sender'] == 'user';
                final isLast = index == _messages.length - 1;

                if (isUser) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12, left: 40),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        msg['text']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }

                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12, right: 40),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.auto_awesome_rounded,
                              color: AppColors.primaryGreen,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Lingu Tutor',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: AppColors.primaryGreenDark,
                              ),
                            ),
                            const Spacer(),
                            if (msg['text']!.isNotEmpty)
                              IconButton(
                                icon: const Icon(
                                  Icons.volume_up_rounded,
                                  size: 18,
                                  color: AppColors.primaryGreen,
                                ),
                                onPressed: () => TtsService().speakTarget(
                                  msg['text']!,
                                  emotion: TtsEmotion.encouraging,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        if (msg['text']!.isEmpty && isLast && _isLoading)
                          const Row(
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Thinking...',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          )
                        else
                          Text(
                            msg['text']!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                              height: 1.4,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Custom question bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    decoration: InputDecoration(
                      hintText: 'Ask follow-up question...',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onSubmitted: (_) => _sendCustomQuestion(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                  ),
                  icon: const Icon(Icons.send_rounded, color: Colors.white),
                  onPressed: _sendCustomQuestion,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
