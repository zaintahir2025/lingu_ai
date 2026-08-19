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

abstract class AdminAuditLogRecord implements _i1.SerializableModel {
  AdminAuditLogRecord._({
    this.id,
    this.actorUserId,
    required this.action,
    required this.targetType,
    this.targetId,
    this.details,
    required this.createdAt,
  });

  factory AdminAuditLogRecord({
    int? id,
    int? actorUserId,
    required String action,
    required String targetType,
    String? targetId,
    String? details,
    required DateTime createdAt,
  }) = _AdminAuditLogRecordImpl;

  factory AdminAuditLogRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminAuditLogRecord(
      id: jsonSerialization['id'] as int?,
      actorUserId: jsonSerialization['actorUserId'] as int?,
      action: jsonSerialization['action'] as String,
      targetType: jsonSerialization['targetType'] as String,
      targetId: jsonSerialization['targetId'] as String?,
      details: jsonSerialization['details'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int? actorUserId;

  String action;

  String targetType;

  String? targetId;

  String? details;

  DateTime createdAt;

  /// Returns a shallow copy of this [AdminAuditLogRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AdminAuditLogRecord copyWith({
    int? id,
    int? actorUserId,
    String? action,
    String? targetType,
    String? targetId,
    String? details,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminAuditLogRecord',
      if (id != null) 'id': id,
      if (actorUserId != null) 'actorUserId': actorUserId,
      'action': action,
      'targetType': targetType,
      if (targetId != null) 'targetId': targetId,
      if (details != null) 'details': details,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminAuditLogRecordImpl extends AdminAuditLogRecord {
  _AdminAuditLogRecordImpl({
    int? id,
    int? actorUserId,
    required String action,
    required String targetType,
    String? targetId,
    String? details,
    required DateTime createdAt,
  }) : super._(
         id: id,
         actorUserId: actorUserId,
         action: action,
         targetType: targetType,
         targetId: targetId,
         details: details,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AdminAuditLogRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AdminAuditLogRecord copyWith({
    Object? id = _Undefined,
    Object? actorUserId = _Undefined,
    String? action,
    String? targetType,
    Object? targetId = _Undefined,
    Object? details = _Undefined,
    DateTime? createdAt,
  }) {
    return AdminAuditLogRecord(
      id: id is int? ? id : this.id,
      actorUserId: actorUserId is int? ? actorUserId : this.actorUserId,
      action: action ?? this.action,
      targetType: targetType ?? this.targetType,
      targetId: targetId is String? ? targetId : this.targetId,
      details: details is String? ? details : this.details,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
