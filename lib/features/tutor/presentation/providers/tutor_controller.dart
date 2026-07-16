import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database.dart';
import '../../domain/models/chat_message.dart';
import '../../data/repositories/tutor_repository.dart';

class TutorState {
  final List<ChatMessage> messages;
  final bool isStreaming;

  const TutorState({
    required this.messages,
    this.isStreaming = false,
  });

  TutorState copyWith({
    List<ChatMessage>? messages,
    bool? isStreaming,
  }) {
    return TutorState(
      messages: messages ?? this.messages,
      isStreaming: isStreaming ?? this.isStreaming,
    );
  }
}

class TutorController extends Notifier<TutorState> {
  @override
  TutorState build() {
    return const TutorState(
      messages: [
        ChatMessage(
          id: '0',
          content: 'Hello! I am your AI language tutor. How can I help you today?',
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
      // 1. Fetch Context
      final recentMistakes = await db.getRecentMistakes(limit: 5);
      final contextWords = recentMistakes.map((e) => e.word).toList();

      // 2. Start Streaming
      final stream = repo.mockStreamTutorMessage(userMessage.content, contextWords);

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
      
      messages[lastIndex] = messages[lastIndex].copyWith(
        content: 'Sorry, I encountered an error. Please try again.',
        isStreaming: false,
      );
      state = state.copyWith(messages: messages);
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
