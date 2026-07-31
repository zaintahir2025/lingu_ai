import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_constants.dart';
import '../../../../core/widgets/shared/offline_gate.dart';
import '../providers/tutor_controller.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/models/character_model.dart';
import 'package:lingu_ai/l10n/app_localizations.dart';
import 'paywall_screen.dart';
import 'ai_settings_screen.dart';

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

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      ref.read(tutorControllerProvider.notifier).sendMessage(text);
      _textController.clear();
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
            Icon(Icons.psychology_rounded, color: AppColors.primaryGreen, size: 28),
            SizedBox(width: 10),
            Text('AI Tutor Instructions 🤖', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to your AI Language Companions! Here is how to make the most out of them:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12),
            Text('1. 🎭 Choose Your Fun Character:\nTap any character chip at the top (Lingu Owl, Professor Bear, Viktor Robot, Zari, Junior, or Detective Lucy) to practice with different personalities!'),
            SizedBox(height: 8),
            Text('2. 🔑 Bring Your Own Key (BYOK):\nTap the Key icon at the top right to use custom Groq, Gemini, OpenAI, or Claude API keys.'),
            SizedBox(height: 8),
            Text('3. ⚡ Smart Offline Mode:\nEven without an API key or internet connection, your AI companion responds with smart grammar & vocabulary help!'),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
    final activeChar = tutorState.activeCharacter;

    // Auto scroll when messages change
    ref.listen<TutorState>(tutorControllerProvider, (previous, next) {
      if (previous?.messages.length != next.messages.length) {
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
      }
      
      if (next.requiresPremium && (previous?.requiresPremium != true)) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Dialog.fullscreen(
            child: const PaywallScreen(),
          ),
        );
      }
    });

    return OfflineGate(
      title: AppLocalizations.of(context)!.tutorSleepingTitle,
      message: AppLocalizations.of(context)!.tutorSleepingMessage,
      child: Column(
        children: [
          // Top Bar with BYOK & Help
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            color: activeChar.themeColor.withValues(alpha: 0.1),
            child: Row(
              children: [
                Icon(activeChar.iconFallback, size: 20, color: activeChar.themeColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${activeChar.name} • ${activeChar.role}',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: activeChar.themeColor),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.help_outline_rounded, size: 20, color: AppColors.textSecondary),
                  tooltip: 'AI Tutor Instructions & Help',
                  onPressed: _showHelpInstructions,
                ),
                IconButton(
                  icon: const Icon(Icons.key_rounded, size: 20, color: AppColors.textSecondary),
                  tooltip: 'BYOK AI Key Settings',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const AiSettingsScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
          
          // Character Selection Horizontal Bar
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(vertical: 6),
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: CharacterModel.allCharacters.length,
              itemBuilder: (context, index) {
                final char = CharacterModel.allCharacters[index];
                final isSelected = char.id == activeChar.id;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    avatar: Icon(
                      char.iconFallback,
                      size: 18,
                      color: isSelected ? Colors.white : char.themeColor,
                    ),
                    label: Text(
                      char.name,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: char.themeColor,
                    backgroundColor: char.themeColor.withValues(alpha: 0.12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    onSelected: (val) {
                      if (val) {
                        ref.read(tutorControllerProvider.notifier).selectCharacter(char);
                      }
                    },
                  ),
                );
              },
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
                return _buildMessageBubble(message, activeChar);
              },
            ),
          ),
          _buildInputArea(context, tutorState.isStreaming, activeChar),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, CharacterModel character) {
    final isUser = message.isUser;
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: AppConstants.space16),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 18,
              backgroundColor: character.themeColor.withValues(alpha: 0.2),
              child: Icon(character.iconFallback, size: 20, color: character.themeColor),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? character.themeColor : AppColors.surface,
                borderRadius: BorderRadiusDirectional.only(
                  topStart: const Radius.circular(16),
                  topEnd: const Radius.circular(16),
                  bottomStart: isUser ? const Radius.circular(16) : const Radius.circular(0),
                  bottomEnd: isUser ? const Radius.circular(0) : const Radius.circular(16),
                ).resolve(Directionality.of(context)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: message.isStreaming && message.content.isEmpty
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      message.content,
                      style: TextStyle(
                        color: isUser ? Colors.white : AppColors.textPrimary,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
          if (isUser) const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildInputArea(BuildContext context, bool isStreaming, CharacterModel character) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -4),
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              enabled: !isStreaming,
              decoration: InputDecoration(
                hintText: isStreaming ? AppLocalizations.of(context)!.tutorIsTyping : 'Ask ${character.name}...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            mini: true,
            backgroundColor: isStreaming ? Colors.grey : character.themeColor,
            elevation: 0,
            onPressed: isStreaming ? null : _sendMessage,
            child: const Icon(Icons.send, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}
