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

abstract class AiUsageRecord implements _i1.SerializableModel {
  AiUsageRecord._({
    this.id,
    required this.userId,
    int? requestCount,
    int? tokensUsed,
    required this.lastReset,
  }) : requestCount = requestCount ?? 0,
       tokensUsed = tokensUsed ?? 0;

  factory AiUsageRecord({
    int? id,
    required int userId,
    int? requestCount,
    int? tokensUsed,
    required DateTime lastReset,
  }) = _AiUsageRecordImpl;

  factory AiUsageRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return AiUsageRecord(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      requestCount: jsonSerialization['requestCount'] as int?,
      tokensUsed: jsonSerialization['tokensUsed'] as int?,
      lastReset: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastReset'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userId;

  int requestCount;

  int tokensUsed;

  DateTime lastReset;

  /// Returns a shallow copy of this [AiUsageRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AiUsageRecord copyWith({
    int? id,
    int? userId,
    int? requestCount,
    int? tokensUsed,
    DateTime? lastReset,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AiUsageRecord',
      if (id != null) 'id': id,
      'userId': userId,
      'requestCount': requestCount,
      'tokensUsed': tokensUsed,
      'lastReset': lastReset.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AiUsageRecordImpl extends AiUsageRecord {
  _AiUsageRecordImpl({
    int? id,
    required int userId,
    int? requestCount,
    int? tokensUsed,
    required DateTime lastReset,
  }) : super._(
         id: id,
         userId: userId,
         requestCount: requestCount,
         tokensUsed: tokensUsed,
         lastReset: lastReset,
       );

  /// Returns a shallow copy of this [AiUsageRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AiUsageRecord copyWith({
    Object? id = _Undefined,
    int? userId,
    int? requestCount,
    int? tokensUsed,
    DateTime? lastReset,
  }) {
    return AiUsageRecord(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      requestCount: requestCount ?? this.requestCount,
      tokensUsed: tokensUsed ?? this.tokensUsed,
      lastReset: lastReset ?? this.lastReset,
    );
  }
}
