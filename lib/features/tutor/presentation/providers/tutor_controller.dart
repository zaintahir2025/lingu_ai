import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database.dart';
import '../../domain/models/chat_message.dart';
import '../../data/repositories/tutor_repository.dart';
import '../../../../core/providers/target_language_provider.dart';

class TutorState {
  final List<ChatMessage> messages;
  final bool isStreaming;
  final bool requiresPremium;

  const TutorState({
    required this.messages,
    this.isStreaming = false,
    this.requiresPremium = false,
  });

  TutorState copyWith({
    List<ChatMessage>? messages,
    bool? isStreaming,
    bool? requiresPremium,
  }) {
    return TutorState(
      messages: messages ?? this.messages,
      isStreaming: isStreaming ?? this.isStreaming,
      requiresPremium: requiresPremium ?? this.requiresPremium,
    );
  }
}

class TutorController extends Notifier<TutorState> {
  @override
  TutorState build() {
    final targetLang = ref.watch(targetLanguageProvider);
    final flag = TargetLanguages.getFlag(targetLang);
    final name = TargetLanguages.getName(targetLang);

    String greeting = '¡Hola!';
    if (targetLang == 'fr') greeting = 'Bonjour !';
    if (targetLang == 'ja') greeting = 'こんにちは !';
    if (targetLang == 'de') greeting = 'Hallo !';

    return TutorState(
      messages: [
        ChatMessage(
          id: '0',
          content: '$greeting $flag I am your AI Language Tutor for $name. Ask me any questions about vocabulary, grammar, or daily conversation!',
          isUser: false,
        ),
      ],
    );
  }

  Future<void> sendMessage(String text, {String? customPrompt}) async {
    if (text.isEmpty && customPrompt == null) return;
    if (state.isStreaming) return;

    final db = ref.read(databaseProvider);
    final repo = ref.read(tutorRepositoryProvider);
    final targetLang = ref.read(targetLanguageProvider);

    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: customPrompt ?? text,
      isUser: true,
    );

    final botMessageId = (DateTime.now().millisecondsSinceEpoch + 1).toString();
    final initialBotMessage = ChatMessage(
      id: botMessageId,
      content: '',
      isUser: false,
      isStreaming: true,
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage, initialBotMessage],
      isStreaming: true,
    );

    try {
      // Tiered Context Window
      final isPro = state.requiresPremium == false;
      final maxContextMistakes = isPro ? 10 : 3;
      final maxMessageHistory = isPro ? 20 : 3;

      // Check context history limit for Free tier
      if (!isPro && state.messages.length > maxMessageHistory * 2) {
        state = state.copyWith(
          requiresPremium: true,
          isStreaming: false,
        );
        return;
      }

      // 1. Fetch Context
      final recentMistakes = await db.getRecentMistakes(limit: maxContextMistakes);
      final contextWords = recentMistakes.map((e) => e.word).toList();

      // 2. Start Streaming with AI Tutor
      final stream = repo.streamTutorMessage(
        userMessage.content,
        contextWords,
        targetLang: targetLang,
      );

      await for (final token in stream) {
        // Update the last message
        final messages = List<ChatMessage>.from(state.messages);
        final lastIndex = messages.length - 1;
        
        final currentBotMessage = messages[lastIndex];
        messages[lastIndex] = currentBotMessage.copyWith(
          content: currentBotMessage.content + token,
        );
        
        state = state.copyWith(messages: messages);
      }
    } catch (e) {
      final messages = List<ChatMessage>.from(state.messages);
      final lastIndex = messages.length - 1;
      
      if (e.toString().contains('PREMIUM_REQUIRED')) {
        // Remove the initial bot message
        messages.removeLast();
        state = state.copyWith(messages: messages, requiresPremium: true, isStreaming: false);
        return;
      } else {
        messages[lastIndex] = messages[lastIndex].copyWith(
          content: 'Sorry, I encountered an error. Please try again.',
          isStreaming: false,
        );
        state = state.copyWith(messages: messages);
      }
    } finally {
      final messages = List<ChatMessage>.from(state.messages);
      final lastIndex = messages.length - 1;
      messages[lastIndex] = messages[lastIndex].copyWith(isStreaming: false);
      
      state = state.copyWith(
        messages: messages,
        isStreaming: false,
      );
    }
  }
}

final tutorControllerProvider = NotifierProvider<TutorController, TutorState>(() {
  return TutorController();
});

