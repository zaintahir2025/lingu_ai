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

abstract class LessonRecord
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = LessonRecordTable();

  static const db = LessonRecordRepository._();

  @override
  int? id;

  String topic;

  String cefrLevel;

  int orderIndex;

  String languageCode;

  int unitNumber;

  String grammarNote;

  String status;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static LessonRecordInclude include() {
    return LessonRecordInclude._();
  }

  static LessonRecordIncludeList includeList({
    _i1.WhereExpressionBuilder<LessonRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LessonRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LessonRecordTable>? orderByList,
    LessonRecordInclude? include,
  }) {
    return LessonRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LessonRecord.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(LessonRecord.t),
      include: include,
    );
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

class LessonRecordUpdateTable extends _i1.UpdateTable<LessonRecordTable> {
  LessonRecordUpdateTable(super.table);

  _i1.ColumnValue<String, String> topic(String value) => _i1.ColumnValue(
    table.topic,
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

  _i1.ColumnValue<String, String> languageCode(String value) => _i1.ColumnValue(
    table.languageCode,
    value,
  );

  _i1.ColumnValue<int, int> unitNumber(int value) => _i1.ColumnValue(
    table.unitNumber,
    value,
  );

  _i1.ColumnValue<String, String> grammarNote(String value) => _i1.ColumnValue(
    table.grammarNote,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );
}

class LessonRecordTable extends _i1.Table<int?> {
  LessonRecordTable({super.tableRelation}) : super(tableName: 'lesson') {
    updateTable = LessonRecordUpdateTable(this);
    topic = _i1.ColumnString(
      'topic',
      this,
    );
    cefrLevel = _i1.ColumnString(
      'cefrLevel',
      this,
    );
    orderIndex = _i1.ColumnInt(
      'orderIndex',
      this,
    );
    languageCode = _i1.ColumnString(
      'languageCode',
      this,
      hasDefault: true,
    );
    unitNumber = _i1.ColumnInt(
      'unitNumber',
      this,
      hasDefault: true,
    );
    grammarNote = _i1.ColumnString(
      'grammarNote',
      this,
      hasDefault: true,
    );
    status = _i1.ColumnString(
      'status',
      this,
      hasDefault: true,
    );
  }

  late final LessonRecordUpdateTable updateTable;

  late final _i1.ColumnString topic;

  late final _i1.ColumnString cefrLevel;

  late final _i1.ColumnInt orderIndex;

  late final _i1.ColumnString languageCode;

  late final _i1.ColumnInt unitNumber;

  late final _i1.ColumnString grammarNote;

  late final _i1.ColumnString status;

  @override
  List<_i1.Column> get columns => [
    id,
    topic,
    cefrLevel,
    orderIndex,
    languageCode,
    unitNumber,
    grammarNote,
    status,
  ];
}

class LessonRecordInclude extends _i1.IncludeObject {
  LessonRecordInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => LessonRecord.t;
}

class LessonRecordIncludeList extends _i1.IncludeList {
  LessonRecordIncludeList._({
    _i1.WhereExpressionBuilder<LessonRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(LessonRecord.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => LessonRecord.t;
}

class LessonRecordRepository {
  const LessonRecordRepository._();

  /// Returns a list of [LessonRecord]s matching the given query parameters.
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
  Future<List<LessonRecord>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<LessonRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LessonRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LessonRecordTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<LessonRecord>(
      where: where?.call(LessonRecord.t),
      orderBy: orderBy?.call(LessonRecord.t),
      orderByList: orderByList?.call(LessonRecord.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [LessonRecord] matching the given query parameters.
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
  Future<LessonRecord?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<LessonRecordTable>? where,
    int? offset,
    _i1.OrderByBuilder<LessonRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LessonRecordTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<LessonRecord>(
      where: where?.call(LessonRecord.t),
      orderBy: orderBy?.call(LessonRecord.t),
      orderByList: orderByList?.call(LessonRecord.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [LessonRecord] by its [id] or null if no such row exists.
  Future<LessonRecord?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<LessonRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [LessonRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [LessonRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<LessonRecord>> insert(
    _i1.DatabaseSession session,
    List<LessonRecord> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<LessonRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [LessonRecord] and returns the inserted row.
  ///
  /// The returned [LessonRecord] will have its `id` field set.
  Future<LessonRecord> insertRow(
    _i1.DatabaseSession session,
    LessonRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<LessonRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [LessonRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<LessonRecord>> update(
    _i1.DatabaseSession session,
    List<LessonRecord> rows, {
    _i1.ColumnSelections<LessonRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<LessonRecord>(
      rows,
      columns: columns?.call(LessonRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LessonRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<LessonRecord> updateRow(
    _i1.DatabaseSession session,
    LessonRecord row, {
    _i1.ColumnSelections<LessonRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<LessonRecord>(
      row,
      columns: columns?.call(LessonRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LessonRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<LessonRecord?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<LessonRecordUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<LessonRecord>(
      id,
      columnValues: columnValues(LessonRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [LessonRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<LessonRecord>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<LessonRecordUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<LessonRecordTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LessonRecordTable>? orderBy,
    _i1.OrderByListBuilder<LessonRecordTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<LessonRecord>(
      columnValues: columnValues(LessonRecord.t.updateTable),
      where: where(LessonRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LessonRecord.t),
      orderByList: orderByList?.call(LessonRecord.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [LessonRecord]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<LessonRecord>> delete(
    _i1.DatabaseSession session,
    List<LessonRecord> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<LessonRecord>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [LessonRecord].
  Future<LessonRecord> deleteRow(
    _i1.DatabaseSession session,
    LessonRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<LessonRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<LessonRecord>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<LessonRecordTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<LessonRecord>(
      where: where(LessonRecord.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<LessonRecordTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<LessonRecord>(
      where: where?.call(LessonRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [LessonRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<LessonRecordTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<LessonRecord>(
      where: where(LessonRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
