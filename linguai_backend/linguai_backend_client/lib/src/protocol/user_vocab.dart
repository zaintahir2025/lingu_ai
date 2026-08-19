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

abstract class UserVocabRecord implements _i1.SerializableModel {
  UserVocabRecord._({
    this.id,
    required this.userId,
    required this.vocabWordId,
    String? status,
    this.nextReviewDate,
    int? repetitions,
    double? easinessFactor,
    int? intervalDays,
    int? errorCount,
    this.lastReviewedAt,
    required this.updatedAt,
  }) : status = status ?? 'new',
       repetitions = repetitions ?? 0,
       easinessFactor = easinessFactor ?? 2.5,
       intervalDays = intervalDays ?? 0,
       errorCount = errorCount ?? 0;

  factory UserVocabRecord({
    int? id,
    required int userId,
    required int vocabWordId,
    String? status,
    DateTime? nextReviewDate,
    int? repetitions,
    double? easinessFactor,
    int? intervalDays,
    int? errorCount,
    DateTime? lastReviewedAt,
    required DateTime updatedAt,
  }) = _UserVocabRecordImpl;

  factory UserVocabRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserVocabRecord(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      vocabWordId: jsonSerialization['vocabWordId'] as int,
      status: jsonSerialization['status'] as String?,
      nextReviewDate: jsonSerialization['nextReviewDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['nextReviewDate'],
            ),
      repetitions: jsonSerialization['repetitions'] as int?,
      easinessFactor: (jsonSerialization['easinessFactor'] as num?)?.toDouble(),
      intervalDays: jsonSerialization['intervalDays'] as int?,
      errorCount: jsonSerialization['errorCount'] as int?,
      lastReviewedAt: jsonSerialization['lastReviewedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastReviewedAt'],
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

  int vocabWordId;

  String status;

  DateTime? nextReviewDate;

  int repetitions;

  double easinessFactor;

  int intervalDays;

  int errorCount;

  DateTime? lastReviewedAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [UserVocabRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserVocabRecord copyWith({
    int? id,
    int? userId,
    int? vocabWordId,
    String? status,
    DateTime? nextReviewDate,
    int? repetitions,
    double? easinessFactor,
    int? intervalDays,
    int? errorCount,
    DateTime? lastReviewedAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserVocabRecord',
      if (id != null) 'id': id,
      'userId': userId,
      'vocabWordId': vocabWordId,
      'status': status,
      if (nextReviewDate != null) 'nextReviewDate': nextReviewDate?.toJson(),
      'repetitions': repetitions,
      'easinessFactor': easinessFactor,
      'intervalDays': intervalDays,
      'errorCount': errorCount,
      if (lastReviewedAt != null) 'lastReviewedAt': lastReviewedAt?.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserVocabRecordImpl extends UserVocabRecord {
  _UserVocabRecordImpl({
    int? id,
    required int userId,
    required int vocabWordId,
    String? status,
    DateTime? nextReviewDate,
    int? repetitions,
    double? easinessFactor,
    int? intervalDays,
    int? errorCount,
    DateTime? lastReviewedAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         vocabWordId: vocabWordId,
         status: status,
         nextReviewDate: nextReviewDate,
         repetitions: repetitions,
         easinessFactor: easinessFactor,
         intervalDays: intervalDays,
         errorCount: errorCount,
         lastReviewedAt: lastReviewedAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [UserVocabRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserVocabRecord copyWith({
    Object? id = _Undefined,
    int? userId,
    int? vocabWordId,
    String? status,
    Object? nextReviewDate = _Undefined,
    int? repetitions,
    double? easinessFactor,
    int? intervalDays,
    int? errorCount,
    Object? lastReviewedAt = _Undefined,
    DateTime? updatedAt,
  }) {
    return UserVocabRecord(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      vocabWordId: vocabWordId ?? this.vocabWordId,
      status: status ?? this.status,
      nextReviewDate: nextReviewDate is DateTime?
          ? nextReviewDate
          : this.nextReviewDate,
      repetitions: repetitions ?? this.repetitions,
      easinessFactor: easinessFactor ?? this.easinessFactor,
      intervalDays: intervalDays ?? this.intervalDays,
      errorCount: errorCount ?? this.errorCount,
      lastReviewedAt: lastReviewedAt is DateTime?
          ? lastReviewedAt
          : this.lastReviewedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
