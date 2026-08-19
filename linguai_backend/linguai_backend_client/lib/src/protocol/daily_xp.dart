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

abstract class DailyXpRecord implements _i1.SerializableModel {
  DailyXpRecord._({
    this.id,
    required this.userId,
    required this.day,
    int? xpEarned,
  }) : xpEarned = xpEarned ?? 0;

  factory DailyXpRecord({
    int? id,
    required int userId,
    required DateTime day,
    int? xpEarned,
  }) = _DailyXpRecordImpl;

  factory DailyXpRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return DailyXpRecord(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      day: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['day']),
      xpEarned: jsonSerialization['xpEarned'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userId;

  DateTime day;

  int xpEarned;

  /// Returns a shallow copy of this [DailyXpRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DailyXpRecord copyWith({
    int? id,
    int? userId,
    DateTime? day,
    int? xpEarned,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DailyXpRecord',
      if (id != null) 'id': id,
      'userId': userId,
      'day': day.toJson(),
      'xpEarned': xpEarned,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DailyXpRecordImpl extends DailyXpRecord {
  _DailyXpRecordImpl({
    int? id,
    required int userId,
    required DateTime day,
    int? xpEarned,
  }) : super._(
         id: id,
         userId: userId,
         day: day,
         xpEarned: xpEarned,
       );

  /// Returns a shallow copy of this [DailyXpRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DailyXpRecord copyWith({
    Object? id = _Undefined,
    int? userId,
    DateTime? day,
    int? xpEarned,
  }) {
    return DailyXpRecord(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      day: day ?? this.day,
      xpEarned: xpEarned ?? this.xpEarned,
    );
  }
}
