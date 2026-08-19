/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class SupportTicketRecord implements _i1.SerializableModel {
  SupportTicketRecord._({
    this.id,
    required this.userId,
    required this.category,
    required this.subject,
    required this.message,
    String? priority,
    String? status,
    this.reply,
    this.repliedAt,
    required this.createdAt,
    required this.updatedAt,
  }) : priority = priority ?? 'normal',
       status = status ?? 'open';

  factory SupportTicketRecord({
    int? id,
    required int userId,
    required String category,
    required String subject,
    required String message,
    String? priority,
    String? status,
    String? reply,
    DateTime? repliedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _SupportTicketRecordImpl;

  factory SupportTicketRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return SupportTicketRecord(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      category: jsonSerialization['category'] as String,
      subject: jsonSerialization['subject'] as String,
      message: jsonSerialization['message'] as String,
      priority: jsonSerialization['priority'] as String?,
      status: jsonSerialization['status'] as String?,
      reply: jsonSerialization['reply'] as String?,
      repliedAt: jsonSerialization['repliedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['repliedAt']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userId;

  String category;

  String subject;

  String message;

  String priority;

  String status;

  String? reply;

  DateTime? repliedAt;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [SupportTicketRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SupportTicketRecord copyWith({
    int? id,
    int? userId,
    String? category,
    String? subject,
    String? message,
    String? priority,
    String? status,
    String? reply,
    DateTime? repliedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SupportTicketRecord',
      if (id != null) 'id': id,
      'userId': userId,
      'category': category,
      'subject': subject,
      'message': message,
      'priority': priority,
      'status': status,
      if (reply != null) 'reply': reply,
      if (repliedAt != null) 'repliedAt': repliedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SupportTicketRecordImpl extends SupportTicketRecord {
  _SupportTicketRecordImpl({
    int? id,
    required int userId,
    required String category,
    required String subject,
    required String message,
    String? priority,
    String? status,
    String? reply,
    DateTime? repliedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         category: category,
         subject: subject,
         message: message,
         priority: priority,
         status: status,
         reply: reply,
         repliedAt: repliedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [SupportTicketRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SupportTicketRecord copyWith({
    Object? id = _Undefined,
    int? userId,
    String? category,
    String? subject,
    String? message,
    String? priority,
    String? status,
    Object? reply = _Undefined,
    Object? repliedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SupportTicketRecord(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      category: category ?? this.category,
      subject: subject ?? this.subject,
      message: message ?? this.message,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      reply: reply is String? ? reply : this.reply,
      repliedAt: repliedAt is DateTime? ? repliedAt : this.repliedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
