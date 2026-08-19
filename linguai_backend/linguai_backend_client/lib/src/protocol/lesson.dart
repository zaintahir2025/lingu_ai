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

abstract class LessonRecord implements _i1.SerializableModel {
  LessonRecord._({
    this.id,
    required this.topic,
    required this.cefrLevel,
    required this.orderIndex,
    String? languageCode,
    int? unitNumber,
    String? grammarNote,
    String? status,
  }) : languageCode = languageCode ?? 'es',
       unitNumber = unitNumber ?? 1,
       grammarNote = grammarNote ?? '',
       status = status ?? 'approved';

  factory LessonRecord({
    int? id,
    required String topic,
    required String cefrLevel,
    required int orderIndex,
    String? languageCode,
    int? unitNumber,
    String? grammarNote,
    String? status,
  }) = _LessonRecordImpl;

  factory LessonRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return LessonRecord(
      id: jsonSerialization['id'] as int?,
      topic: jsonSerialization['topic'] as String,
      cefrLevel: jsonSerialization['cefrLevel'] as String,
      orderIndex: jsonSerialization['orderIndex'] as int,
      languageCode: jsonSerialization['languageCode'] as String?,
      unitNumber: jsonSerialization['unitNumber'] as int?,
      grammarNote: jsonSerialization['grammarNote'] as String?,
      status: jsonSerialization['status'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String topic;

  String cefrLevel;

  int orderIndex;

  String languageCode;

  int unitNumber;

  String grammarNote;

  String status;

  /// Returns a shallow copy of this [LessonRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  LessonRecord copyWith({
    int? id,
    String? topic,
    String? cefrLevel,
    int? orderIndex,
    String? languageCode,
    int? unitNumber,
    String? grammarNote,
    String? status,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LessonRecord',
      if (id != null) 'id': id,
      'topic': topic,
      'cefrLevel': cefrLevel,
      'orderIndex': orderIndex,
      'languageCode': languageCode,
      'unitNumber': unitNumber,
      'grammarNote': grammarNote,
      'status': status,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LessonRecordImpl extends LessonRecord {
  _LessonRecordImpl({
    int? id,
    required String topic,
    required String cefrLevel,
    required int orderIndex,
    String? languageCode,
    int? unitNumber,
    String? grammarNote,
    String? status,
  }) : super._(
         id: id,
         topic: topic,
         cefrLevel: cefrLevel,
         orderIndex: orderIndex,
         languageCode: languageCode,
         unitNumber: unitNumber,
         grammarNote: grammarNote,
         status: status,
       );

  /// Returns a shallow copy of this [LessonRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  LessonRecord copyWith({
    Object? id = _Undefined,
    String? topic,
    String? cefrLevel,
    int? orderIndex,
    String? languageCode,
    int? unitNumber,
    String? grammarNote,
    String? status,
  }) {
    return LessonRecord(
      id: id is int? ? id : this.id,
      topic: topic ?? this.topic,
      cefrLevel: cefrLevel ?? this.cefrLevel,
      orderIndex: orderIndex ?? this.orderIndex,
      languageCode: languageCode ?? this.languageCode,
      unitNumber: unitNumber ?? this.unitNumber,
      grammarNote: grammarNote ?? this.grammarNote,
      status: status ?? this.status,
    );
  }
}
