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

abstract class VocabWordRecord implements _i1.SerializableModel {
  VocabWordRecord._({
    this.id,
    required this.lessonId,
    required this.word,
    required this.translation,
    this.audioUrl,
    this.exampleSentence,
    this.exampleTranslation,
    String? partOfSpeech,
    this.ipa,
    String? cefrLevel,
    int? orderIndex,
  }) : partOfSpeech = partOfSpeech ?? 'phrase',
       cefrLevel = cefrLevel ?? 'A1',
       orderIndex = orderIndex ?? 0;

  factory VocabWordRecord({
    int? id,
    required int lessonId,
    required String word,
    required String translation,
    String? audioUrl,
    String? exampleSentence,
    String? exampleTranslation,
    String? partOfSpeech,
    String? ipa,
    String? cefrLevel,
    int? orderIndex,
  }) = _VocabWordRecordImpl;

  factory VocabWordRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return VocabWordRecord(
      id: jsonSerialization['id'] as int?,
      lessonId: jsonSerialization['lessonId'] as int,
      word: jsonSerialization['word'] as String,
      translation: jsonSerialization['translation'] as String,
      audioUrl: jsonSerialization['audioUrl'] as String?,
      exampleSentence: jsonSerialization['exampleSentence'] as String?,
      exampleTranslation: jsonSerialization['exampleTranslation'] as String?,
      partOfSpeech: jsonSerialization['partOfSpeech'] as String?,
      ipa: jsonSerialization['ipa'] as String?,
      cefrLevel: jsonSerialization['cefrLevel'] as String?,
      orderIndex: jsonSerialization['orderIndex'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int lessonId;

  String word;

  String translation;

  String? audioUrl;

  String? exampleSentence;

  String? exampleTranslation;

  String partOfSpeech;

  String? ipa;

  String cefrLevel;

  int orderIndex;

  /// Returns a shallow copy of this [VocabWordRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  VocabWordRecord copyWith({
    int? id,
    int? lessonId,
    String? word,
    String? translation,
    String? audioUrl,
    String? exampleSentence,
    String? exampleTranslation,
    String? partOfSpeech,
    String? ipa,
    String? cefrLevel,
    int? orderIndex,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VocabWordRecord',
      if (id != null) 'id': id,
      'lessonId': lessonId,
      'word': word,
      'translation': translation,
      if (audioUrl != null) 'audioUrl': audioUrl,
      if (exampleSentence != null) 'exampleSentence': exampleSentence,
      if (exampleTranslation != null) 'exampleTranslation': exampleTranslation,
      'partOfSpeech': partOfSpeech,
      if (ipa != null) 'ipa': ipa,
      'cefrLevel': cefrLevel,
      'orderIndex': orderIndex,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VocabWordRecordImpl extends VocabWordRecord {
  _VocabWordRecordImpl({
    int? id,
    required int lessonId,
    required String word,
    required String translation,
    String? audioUrl,
    String? exampleSentence,
    String? exampleTranslation,
    String? partOfSpeech,
    String? ipa,
    String? cefrLevel,
    int? orderIndex,
  }) : super._(
         id: id,
         lessonId: lessonId,
         word: word,
         translation: translation,
         audioUrl: audioUrl,
         exampleSentence: exampleSentence,
         exampleTranslation: exampleTranslation,
         partOfSpeech: partOfSpeech,
         ipa: ipa,
         cefrLevel: cefrLevel,
         orderIndex: orderIndex,
       );

  /// Returns a shallow copy of this [VocabWordRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  VocabWordRecord copyWith({
    Object? id = _Undefined,
    int? lessonId,
    String? word,
    String? translation,
    Object? audioUrl = _Undefined,
    Object? exampleSentence = _Undefined,
    Object? exampleTranslation = _Undefined,
    String? partOfSpeech,
    Object? ipa = _Undefined,
    String? cefrLevel,
    int? orderIndex,
  }) {
    return VocabWordRecord(
      id: id is int? ? id : this.id,
      lessonId: lessonId ?? this.lessonId,
      word: word ?? this.word,
      translation: translation ?? this.translation,
      audioUrl: audioUrl is String? ? audioUrl : this.audioUrl,
      exampleSentence: exampleSentence is String?
          ? exampleSentence
          : this.exampleSentence,
      exampleTranslation: exampleTranslation is String?
          ? exampleTranslation
          : this.exampleTranslation,
      partOfSpeech: partOfSpeech ?? this.partOfSpeech,
      ipa: ipa is String? ? ipa : this.ipa,
      cefrLevel: cefrLevel ?? this.cefrLevel,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }
}
