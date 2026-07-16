class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final bool isStreaming;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    this.isStreaming = false,
  });

  ChatMessage copyWith({
    String? id,
    String? content,
    bool? isUser,
    bool? isStreaming,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
      isStreaming: isStreaming ?? this.isStreaming,
    );
  }
}
