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

abstract class AiUsageRecord
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = AiUsageRecordTable();

  static const db = AiUsageRecordRepository._();

  @override
  int? id;

  int userId;

  int requestCount;

  int tokensUsed;

  DateTime lastReset;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AiUsageRecord',
      if (id != null) 'id': id,
      'userId': userId,
      'requestCount': requestCount,
      'tokensUsed': tokensUsed,
      'lastReset': lastReset.toJson(),
    };
  }

  static AiUsageRecordInclude include() {
    return AiUsageRecordInclude._();
  }

  static AiUsageRecordIncludeList includeList({
    _i1.WhereExpressionBuilder<AiUsageRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AiUsageRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AiUsageRecordTable>? orderByList,
    AiUsageRecordInclude? include,
  }) {
    return AiUsageRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AiUsageRecord.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AiUsageRecord.t),
      include: include,
    );
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

class AiUsageRecordUpdateTable extends _i1.UpdateTable<AiUsageRecordTable> {
  AiUsageRecordUpdateTable(super.table);

  _i1.ColumnValue<int, int> userId(int value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<int, int> requestCount(int value) => _i1.ColumnValue(
    table.requestCount,
    value,
  );

  _i1.ColumnValue<int, int> tokensUsed(int value) => _i1.ColumnValue(
    table.tokensUsed,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> lastReset(DateTime value) =>
      _i1.ColumnValue(
        table.lastReset,
        value,
      );
}

class AiUsageRecordTable extends _i1.Table<int?> {
  AiUsageRecordTable({super.tableRelation}) : super(tableName: 'ai_usage') {
    updateTable = AiUsageRecordUpdateTable(this);
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    requestCount = _i1.ColumnInt(
      'requestCount',
      this,
      hasDefault: true,
    );
    tokensUsed = _i1.ColumnInt(
      'tokensUsed',
      this,
      hasDefault: true,
    );
    lastReset = _i1.ColumnDateTime(
      'lastReset',
      this,
    );
  }

  late final AiUsageRecordUpdateTable updateTable;

  late final _i1.ColumnInt userId;

  late final _i1.ColumnInt requestCount;

  late final _i1.ColumnInt tokensUsed;

  late final _i1.ColumnDateTime lastReset;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    requestCount,
    tokensUsed,
    lastReset,
  ];
}

class AiUsageRecordInclude extends _i1.IncludeObject {
  AiUsageRecordInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AiUsageRecord.t;
}

class AiUsageRecordIncludeList extends _i1.IncludeList {
  AiUsageRecordIncludeList._({
    _i1.WhereExpressionBuilder<AiUsageRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AiUsageRecord.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AiUsageRecord.t;
}

class AiUsageRecordRepository {
  const AiUsageRecordRepository._();

  /// Returns a list of [AiUsageRecord]s matching the given query parameters.
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
  Future<List<AiUsageRecord>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AiUsageRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AiUsageRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AiUsageRecordTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AiUsageRecord>(
      where: where?.call(AiUsageRecord.t),
      orderBy: orderBy?.call(AiUsageRecord.t),
      orderByList: orderByList?.call(AiUsageRecord.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AiUsageRecord] matching the given query parameters.
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
  Future<AiUsageRecord?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AiUsageRecordTable>? where,
    int? offset,
    _i1.OrderByBuilder<AiUsageRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AiUsageRecordTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AiUsageRecord>(
      where: where?.call(AiUsageRecord.t),
      orderBy: orderBy?.call(AiUsageRecord.t),
      orderByList: orderByList?.call(AiUsageRecord.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AiUsageRecord] by its [id] or null if no such row exists.
  Future<AiUsageRecord?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AiUsageRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AiUsageRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [AiUsageRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<AiUsageRecord>> insert(
    _i1.DatabaseSession session,
    List<AiUsageRecord> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<AiUsageRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [AiUsageRecord] and returns the inserted row.
  ///
  /// The returned [AiUsageRecord] will have its `id` field set.
  Future<AiUsageRecord> insertRow(
    _i1.DatabaseSession session,
    AiUsageRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AiUsageRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AiUsageRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AiUsageRecord>> update(
    _i1.DatabaseSession session,
    List<AiUsageRecord> rows, {
    _i1.ColumnSelections<AiUsageRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AiUsageRecord>(
      rows,
      columns: columns?.call(AiUsageRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AiUsageRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AiUsageRecord> updateRow(
    _i1.DatabaseSession session,
    AiUsageRecord row, {
    _i1.ColumnSelections<AiUsageRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AiUsageRecord>(
      row,
      columns: columns?.call(AiUsageRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AiUsageRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AiUsageRecord?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<AiUsageRecordUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AiUsageRecord>(
      id,
      columnValues: columnValues(AiUsageRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AiUsageRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AiUsageRecord>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<AiUsageRecordUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<AiUsageRecordTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AiUsageRecordTable>? orderBy,
    _i1.OrderByListBuilder<AiUsageRecordTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AiUsageRecord>(
      columnValues: columnValues(AiUsageRecord.t.updateTable),
      where: where(AiUsageRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AiUsageRecord.t),
      orderByList: orderByList?.call(AiUsageRecord.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AiUsageRecord]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AiUsageRecord>> delete(
    _i1.DatabaseSession session,
    List<AiUsageRecord> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AiUsageRecord>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AiUsageRecord].
  Future<AiUsageRecord> deleteRow(
    _i1.DatabaseSession session,
    AiUsageRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AiUsageRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AiUsageRecord>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AiUsageRecordTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AiUsageRecord>(
      where: where(AiUsageRecord.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AiUsageRecordTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AiUsageRecord>(
      where: where?.call(AiUsageRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AiUsageRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AiUsageRecordTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AiUsageRecord>(
      where: where(AiUsageRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
