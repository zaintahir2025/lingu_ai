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

abstract class UserLessonRecord implements _i1.SerializableModel {
  UserLessonRecord._({
    this.id,
    required this.userId,
    required this.lessonId,
    bool? isLocked,
    bool? isCompleted,
    int? currentStep,
    this.draftJson,
    int? bestScore,
    int? attempts,
    this.completedAt,
    required this.updatedAt,
  }) : isLocked = isLocked ?? true,
       isCompleted = isCompleted ?? false,
       currentStep = currentStep ?? 0,
       bestScore = bestScore ?? 0,
       attempts = attempts ?? 0;

  factory UserLessonRecord({
    int? id,
    required int userId,
    required int lessonId,
    bool? isLocked,
    bool? isCompleted,
    int? currentStep,
    String? draftJson,
    int? bestScore,
    int? attempts,
    DateTime? completedAt,
    required DateTime updatedAt,
  }) = _UserLessonRecordImpl;

  factory UserLessonRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserLessonRecord(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      lessonId: jsonSerialization['lessonId'] as int,
      isLocked: jsonSerialization['isLocked'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isLocked']),
      isCompleted: jsonSerialization['isCompleted'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isCompleted']),
      currentStep: jsonSerialization['currentStep'] as int?,
      draftJson: jsonSerialization['draftJson'] as String?,
      bestScore: jsonSerialization['bestScore'] as int?,
      attempts: jsonSerialization['attempts'] as int?,
      completedAt: jsonSerialization['completedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['completedAt'],
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

  int lessonId;

  bool isLocked;

  bool isCompleted;

  int currentStep;

  String? draftJson;

  int bestScore;

  int attempts;

  DateTime? completedAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [UserLessonRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserLessonRecord copyWith({
    int? id,
    int? userId,
    int? lessonId,
    bool? isLocked,
    bool? isCompleted,
    int? currentStep,
    String? draftJson,
    int? bestScore,
    int? attempts,
    DateTime? completedAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserLessonRecord',
      if (id != null) 'id': id,
      'userId': userId,
      'lessonId': lessonId,
      'isLocked': isLocked,
      'isCompleted': isCompleted,
      'currentStep': currentStep,
      if (draftJson != null) 'draftJson': draftJson,
      'bestScore': bestScore,
      'attempts': attempts,
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserLessonRecordImpl extends UserLessonRecord {
  _UserLessonRecordImpl({
    int? id,
    required int userId,
    required int lessonId,
    bool? isLocked,
    bool? isCompleted,
    int? currentStep,
    String? draftJson,
    int? bestScore,
    int? attempts,
    DateTime? completedAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         lessonId: lessonId,
         isLocked: isLocked,
         isCompleted: isCompleted,
         currentStep: currentStep,
         draftJson: draftJson,
         bestScore: bestScore,
         attempts: attempts,
         completedAt: completedAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [UserLessonRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserLessonRecord copyWith({
    Object? id = _Undefined,
    int? userId,
    int? lessonId,
    bool? isLocked,
    bool? isCompleted,
    int? currentStep,
    Object? draftJson = _Undefined,
    int? bestScore,
    int? attempts,
    Object? completedAt = _Undefined,
    DateTime? updatedAt,
  }) {
    return UserLessonRecord(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      lessonId: lessonId ?? this.lessonId,
      isLocked: isLocked ?? this.isLocked,
      isCompleted: isCompleted ?? this.isCompleted,
      currentStep: currentStep ?? this.currentStep,
      draftJson: draftJson is String? ? draftJson : this.draftJson,
      bestScore: bestScore ?? this.bestScore,
      attempts: attempts ?? this.attempts,
      completedAt: completedAt is DateTime? ? completedAt : this.completedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
