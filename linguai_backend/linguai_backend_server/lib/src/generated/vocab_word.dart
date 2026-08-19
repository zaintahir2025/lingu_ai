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
import 'package:serverpod/serverpod.dart' as _i1;

abstract class VocabWordRecord
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = VocabWordRecordTable();

  static const db = VocabWordRecordRepository._();

  @override
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

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static VocabWordRecordInclude include() {
    return VocabWordRecordInclude._();
  }

  static VocabWordRecordIncludeList includeList({
    _i1.WhereExpressionBuilder<VocabWordRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<VocabWordRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<VocabWordRecordTable>? orderByList,
    VocabWordRecordInclude? include,
  }) {
    return VocabWordRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(VocabWordRecord.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(VocabWordRecord.t),
      include: include,
    );
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

class VocabWordRecordUpdateTable extends _i1.UpdateTable<VocabWordRecordTable> {
  VocabWordRecordUpdateTable(super.table);

  _i1.ColumnValue<int, int> lessonId(int value) => _i1.ColumnValue(
    table.lessonId,
    value,
  );

  _i1.ColumnValue<String, String> word(String value) => _i1.ColumnValue(
    table.word,
    value,
  );

  _i1.ColumnValue<String, String> translation(String value) => _i1.ColumnValue(
    table.translation,
    value,
  );

  _i1.ColumnValue<String, String> audioUrl(String? value) => _i1.ColumnValue(
    table.audioUrl,
    value,
  );

  _i1.ColumnValue<String, String> exampleSentence(String? value) =>
      _i1.ColumnValue(
        table.exampleSentence,
        value,
      );

  _i1.ColumnValue<String, String> exampleTranslation(String? value) =>
      _i1.ColumnValue(
        table.exampleTranslation,
        value,
      );

  _i1.ColumnValue<String, String> partOfSpeech(String value) => _i1.ColumnValue(
    table.partOfSpeech,
    value,
  );

  _i1.ColumnValue<String, String> ipa(String? value) => _i1.ColumnValue(
    table.ipa,
    value,
  );

  _i1.ColumnValue<String, String> cefrLevel(String value) => _i1.ColumnValue(
    table.cefrLevel,
    value,
  );

  _i1.ColumnValue<int, int> orderIndex(int value) => _i1.ColumnValue(
    table.orderIndex,
    value,
  );
}

class VocabWordRecordTable extends _i1.Table<int?> {
  VocabWordRecordTable({super.tableRelation}) : super(tableName: 'vocab_word') {
    updateTable = VocabWordRecordUpdateTable(this);
    lessonId = _i1.ColumnInt(
      'lessonId',
      this,
    );
    word = _i1.ColumnString(
      'word',
      this,
    );
    translation = _i1.ColumnString(
      'translation',
      this,
    );
    audioUrl = _i1.ColumnString(
      'audioUrl',
      this,
    );
    exampleSentence = _i1.ColumnString(
      'exampleSentence',
      this,
    );
    exampleTranslation = _i1.ColumnString(
      'exampleTranslation',
      this,
    );
    partOfSpeech = _i1.ColumnString(
      'partOfSpeech',
      this,
      hasDefault: true,
    );
    ipa = _i1.ColumnString(
      'ipa',
      this,
    );
    cefrLevel = _i1.ColumnString(
      'cefrLevel',
      this,
      hasDefault: true,
    );
    orderIndex = _i1.ColumnInt(
      'orderIndex',
      this,
      hasDefault: true,
    );
  }

  late final VocabWordRecordUpdateTable updateTable;

  late final _i1.ColumnInt lessonId;

  late final _i1.ColumnString word;

  late final _i1.ColumnString translation;

  late final _i1.ColumnString audioUrl;

  late final _i1.ColumnString exampleSentence;

  late final _i1.ColumnString exampleTranslation;

  late final _i1.ColumnString partOfSpeech;

  late final _i1.ColumnString ipa;

  late final _i1.ColumnString cefrLevel;

  late final _i1.ColumnInt orderIndex;

  @override
  List<_i1.Column> get columns => [
    id,
    lessonId,
    word,
    translation,
    audioUrl,
    exampleSentence,
    exampleTranslation,
    partOfSpeech,
    ipa,
    cefrLevel,
    orderIndex,
  ];
}

class VocabWordRecordInclude extends _i1.IncludeObject {
  VocabWordRecordInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => VocabWordRecord.t;
}

class VocabWordRecordIncludeList extends _i1.IncludeList {
  VocabWordRecordIncludeList._({
    _i1.WhereExpressionBuilder<VocabWordRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(VocabWordRecord.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => VocabWordRecord.t;
}

class VocabWordRecordRepository {
  const VocabWordRecordRepository._();

  /// Returns a list of [VocabWordRecord]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<VocabWordRecord>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<VocabWordRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<VocabWordRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<VocabWordRecordTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<VocabWordRecord>(
      where: where?.call(VocabWordRecord.t),
      orderBy: orderBy?.call(VocabWordRecord.t),
      orderByList: orderByList?.call(VocabWordRecord.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [VocabWordRecord] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<VocabWordRecord?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<VocabWordRecordTable>? where,
    int? offset,
    _i1.OrderByBuilder<VocabWordRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<VocabWordRecordTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<VocabWordRecord>(
      where: where?.call(VocabWordRecord.t),
      orderBy: orderBy?.call(VocabWordRecord.t),
      orderByList: orderByList?.call(VocabWordRecord.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [VocabWordRecord] by its [id] or null if no such row exists.
  Future<VocabWordRecord?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<VocabWordRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [VocabWordRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [VocabWordRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<VocabWordRecord>> insert(
    _i1.DatabaseSession session,
    List<VocabWordRecord> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<VocabWordRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [VocabWordRecord] and returns the inserted row.
  ///
  /// The returned [VocabWordRecord] will have its `id` field set.
  Future<VocabWordRecord> insertRow(
    _i1.DatabaseSession session,
    VocabWordRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<VocabWordRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [VocabWordRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<VocabWordRecord>> update(
    _i1.DatabaseSession session,
    List<VocabWordRecord> rows, {
    _i1.ColumnSelections<VocabWordRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<VocabWordRecord>(
      rows,
      columns: columns?.call(VocabWordRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [VocabWordRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<VocabWordRecord> updateRow(
    _i1.DatabaseSession session,
    VocabWordRecord row, {
    _i1.ColumnSelections<VocabWordRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<VocabWordRecord>(
      row,
      columns: columns?.call(VocabWordRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [VocabWordRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<VocabWordRecord?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<VocabWordRecordUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<VocabWordRecord>(
      id,
      columnValues: columnValues(VocabWordRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [VocabWordRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<VocabWordRecord>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<VocabWordRecordUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<VocabWordRecordTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<VocabWordRecordTable>? orderBy,
    _i1.OrderByListBuilder<VocabWordRecordTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<VocabWordRecord>(
      columnValues: columnValues(VocabWordRecord.t.updateTable),
      where: where(VocabWordRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(VocabWordRecord.t),
      orderByList: orderByList?.call(VocabWordRecord.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [VocabWordRecord]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<VocabWordRecord>> delete(
    _i1.DatabaseSession session,
    List<VocabWordRecord> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<VocabWordRecord>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [VocabWordRecord].
  Future<VocabWordRecord> deleteRow(
    _i1.DatabaseSession session,
    VocabWordRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<VocabWordRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<VocabWordRecord>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<VocabWordRecordTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<VocabWordRecord>(
      where: where(VocabWordRecord.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<VocabWordRecordTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<VocabWordRecord>(
      where: where?.call(VocabWordRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [VocabWordRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<VocabWordRecordTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<VocabWordRecord>(
      where: where(VocabWordRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
