import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../local_storage/local_storage_provider.dart';

final supportMessagesStorageProvider = Provider<SupportMessagesStorage>((ref) {
  final box = ref.watch(localStorageProvider);
  return SupportMessagesStorage(box);
});

class SupportTicket {
  final String id;
  final String userEmail;
  final String username;
  final String category;
  final String subject;
  final String message;
  final bool isPremium;
  final String submittedAt;
  final String? reply;
  final String? repliedAt;

  SupportTicket({
    required this.id,
    required this.userEmail,
    required this.username,
    required this.category,
    required this.subject,
    required this.message,
    required this.isPremium,
    required this.submittedAt,
    this.reply,
    this.repliedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userEmail': userEmail,
        'username': username,
        'category': category,
        'subject': subject,
        'message': message,
        'isPremium': isPremium,
        'submittedAt': submittedAt,
        'reply': reply,
        'repliedAt': repliedAt,
      };

  factory SupportTicket.fromJson(Map<String, dynamic> json) => SupportTicket(
        id: json['id'],
        userEmail: json['userEmail'],
        username: json['username'],
        category: json['category'],
        subject: json['subject'],
        message: json['message'],
        isPremium: json['isPremium'] ?? false,
        submittedAt: json['submittedAt'],
        reply: json['reply'],
        repliedAt: json['repliedAt'],
      );

  SupportTicket copyWith({
    String? reply,
    String? repliedAt,
  }) {
    return SupportTicket(
      id: id,
      userEmail: userEmail,
      username: username,
      category: category,
      subject: subject,
      message: message,
      isPremium: isPremium,
      submittedAt: submittedAt,
      reply: reply ?? this.reply,
      repliedAt: repliedAt ?? this.repliedAt,
    );
  }
}

class SupportMessagesStorage {
  final Box _box;
  static const String _supportTicketsKey = 'support_contact_tickets_v1';

  SupportMessagesStorage(this._box) {
    _seedDefaultTicketsIfEmpty();
  }

  void _seedDefaultTicketsIfEmpty() {
    final raw = _box.get(_supportTicketsKey) as String?;
    if (raw == null || raw.isEmpty) {
      final defaultTickets = [
        SupportTicket(
          id: 'tkt_101',
          userEmail: 'pro_learner@gmail.com',
          username: 'Sarah_Polyglot',
          category: 'Feature Request 💡',
          subject: 'Priority Support Request - Japanese Sentences',
          message: 'Can you please add more advanced Japanese conversation flashcards in Unit 2?',
          isPremium: true,
          submittedAt: '2026-08-01 10:15',
        ),
        SupportTicket(
          id: 'tkt_102',
          userEmail: 'student@linguai.com',
          username: 'ZainTahir',
          category: 'General Feedback',
          subject: 'Love the app interface!',
          message: 'Great app! The streak flame and XP counters keep me motivated every day.',
          isPremium: false,
          submittedAt: '2026-07-31 16:40',
        ),
      ];
      _saveTickets(defaultTickets);
    }
  }

  List<SupportTicket> getAllMessages() {
    final raw = _box.get(_supportTicketsKey) as String?;
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> decoded = jsonDecode(raw);
      return decoded.map((item) => SupportTicket.fromJson(Map<String, dynamic>.from(item))).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveTickets(List<SupportTicket> tickets) async {
    final jsonStr = jsonEncode(tickets.map((t) => t.toJson()).toList());
    await _box.put(_supportTicketsKey, jsonStr);
  }

  Future<void> addMessage(SupportTicket ticket) async {
    final tickets = getAllMessages();
    tickets.insert(0, ticket);
    await _saveTickets(tickets);
  }

  Future<void> replyMessage(String id, String replyText) async {
    final tickets = getAllMessages();
    final index = tickets.indexWhere((t) => t.id == id);
    if (index >= 0) {
      tickets[index] = tickets[index].copyWith(
        reply: replyText,
        repliedAt: DateTime.now().toIso8601String().substring(0, 16).replaceAll('T', ' '),
      );
      await _saveTickets(tickets);
    }
  }

  Future<void> deleteMessage(String id) async {
    final tickets = getAllMessages();
    tickets.removeWhere((t) => t.id == id);
    await _saveTickets(tickets);
  }
}
