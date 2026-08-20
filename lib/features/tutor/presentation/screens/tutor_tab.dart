import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_constants.dart';
import '../providers/tutor_controller.dart';
import '../../domain/models/chat_message.dart';
import 'package:lingu_ai/l10n/app_localizations.dart';
import 'paywall_screen.dart';
import 'ai_settings_screen.dart';
import '../../../../core/widgets/mascot/piko_mascot.dart';

import '../../../../core/audio/tts_service.dart';

class TutorTab extends ConsumerStatefulWidget {
  const TutorTab({super.key});

  @override
  ConsumerState<TutorTab> createState() => _TutorTabState();
}

class _TutorTabState extends ConsumerState<TutorTab> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage([String? textToSend]) {
    final text = textToSend ?? _textController.text.trim();
    if (text.isNotEmpty) {
      ref.read(tutorControllerProvider.notifier).sendMessage(text);
      if (textToSend == null) _textController.clear();
      Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
    }
  }

  void _showHelpInstructions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(
              Icons.psychology_rounded,
              color: AppColors.primaryGreen,
              size: 28,
            ),
            SizedBox(width: 10),
            Text(
              'AI Tutor Instructions 🤖',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to your AI Language Tutor! Here is how to get the best experience:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12),
            Text(
              '1. 🔑 Google Gemini API Key:\nTap the Key icon at the top right to paste your free Gemini API key from Google AI Studio (aistudio.google.com).',
            ),
            SizedBox(height: 8),
            Text(
              '2. ⚡ Smart Offline Fallback:\nEven without an API key or internet connection, your AI Tutor provides instant grammar & vocabulary help!',
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tutorState = ref.watch(tutorControllerProvider);

    // Auto scroll when messages change
    ref.listen<TutorState>(tutorControllerProvider, (previous, next) {
      if (previous?.messages.length != next.messages.length) {
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
      }

      if (next.requiresPremium && (previous?.requiresPremium != true)) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Dialog.fullscreen(child: const PaywallScreen()),
        );
      }
    });

    final activeProvider = ref.watch(aiSettingsStorageProvider).provider;
    return Column(
      children: [
        // Top Bar with Gemini Key Settings & Help
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: AppColors.primaryGreen.withValues(alpha: 0.1),
          child: Row(
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                size: 20,
                color: AppColors.primaryGreen,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'AI Language Tutor • $activeProvider',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreenDark,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.help_outline_rounded,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                tooltip: 'AI Tutor Instructions & Help',
                onPressed: _showHelpInstructions,
              ),
              IconButton(
                icon: const Icon(
                  Icons.key_rounded,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                tooltip: 'Google Gemini API Key Settings',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AiSettingsScreen()),
                  );
                },
              ),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1),

        // Message Stream
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(AppConstants.space16),
            itemCount: tutorState.messages.length,
            itemBuilder: (context, index) {
              final message = tutorState.messages[index];
              return _buildMessageBubble(message);
            },
          ),
        ),

        // Quick Suggestion Chips for Gen-Z Learners
        if (!tutorState.isStreaming)
          Container(
            height: 40,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildQuickChip('💬 Practice Conversation', 'Can we practice a simple conversation?'),
                _buildQuickChip('📖 Explain Past Tense', 'Can you explain past tense rules with examples?'),
                _buildQuickChip('😎 Teach Cool Slang', 'Teach me 5 popular native slang words!'),
                _buildQuickChip('☕ Order Cafe Coffee', 'Let\'s roleplay ordering coffee in a restaurant.'),
                _buildQuickChip('⚡ Quiz Me!', 'Quiz me on 3 vocabulary words right now!'),
              ],
            ),
          ),

        _buildInputArea(context, tutorState.isStreaming),
      ],
    );
  }

  Widget _buildQuickChip(String label, String prompt) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        avatar: const Icon(Icons.flash_on_rounded, size: 14, color: AppColors.primaryGreen),
        label: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
        onPressed: () => _sendMessage(prompt),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: AppConstants.space16),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            const PikoMascot(size: 38),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? AppColors.primaryGreen : AppColors.surface,
                borderRadius: BorderRadiusDirectional.only(
                  topStart: const Radius.circular(16),
                  topEnd: const Radius.circular(16),
                  bottomStart: isUser
                      ? const Radius.circular(16)
                      : const Radius.circular(0),
                  bottomEnd: isUser
                      ? const Radius.circular(0)
                      : const Radius.circular(16),
                ).resolve(Directionality.of(context)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: message.isStreaming && message.content.isEmpty
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            message.content,
                            style: TextStyle(
                              color: isUser ? Colors.white : AppColors.textPrimary,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        if (!isUser && message.content.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () {
                              ref.read(ttsServiceProvider).speak(message.content);
                            },
                            child: const Icon(
                              Icons.volume_up_rounded,
                              size: 20,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        ],
                      ],
                    ),
            ),
          ),
          if (isUser) const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildInputArea(BuildContext context, bool isStreaming) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              enabled: !isStreaming,
              decoration: InputDecoration(
                hintText: isStreaming
                    ? (AppLocalizations.of(context)?.tutorIsTyping ?? 'Tutor is typing...')
                    : 'Ask AI Tutor...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            mini: true,
            backgroundColor: isStreaming ? Colors.grey : AppColors.primaryGreen,
            elevation: 0,
            onPressed: isStreaming ? null : () => _sendMessage(),
            child: const Icon(Icons.send, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}
