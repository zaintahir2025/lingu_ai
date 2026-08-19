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

abstract class DailyXpRecord
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = DailyXpRecordTable();

  static const db = DailyXpRecordRepository._();

  @override
  int? id;

  int userId;

  DateTime day;

  int xpEarned;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DailyXpRecord',
      if (id != null) 'id': id,
      'userId': userId,
      'day': day.toJson(),
      'xpEarned': xpEarned,
    };
  }

  static DailyXpRecordInclude include() {
    return DailyXpRecordInclude._();
  }

  static DailyXpRecordIncludeList includeList({
    _i1.WhereExpressionBuilder<DailyXpRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DailyXpRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DailyXpRecordTable>? orderByList,
    DailyXpRecordInclude? include,
  }) {
    return DailyXpRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DailyXpRecord.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(DailyXpRecord.t),
      include: include,
    );
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

class DailyXpRecordUpdateTable extends _i1.UpdateTable<DailyXpRecordTable> {
  DailyXpRecordUpdateTable(super.table);

  _i1.ColumnValue<int, int> userId(int value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> day(DateTime value) => _i1.ColumnValue(
    table.day,
    value,
  );

  _i1.ColumnValue<int, int> xpEarned(int value) => _i1.ColumnValue(
    table.xpEarned,
    value,
  );
}

class DailyXpRecordTable extends _i1.Table<int?> {
  DailyXpRecordTable({super.tableRelation}) : super(tableName: 'daily_xp') {
    updateTable = DailyXpRecordUpdateTable(this);
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    day = _i1.ColumnDateTime(
      'day',
      this,
    );
    xpEarned = _i1.ColumnInt(
      'xpEarned',
      this,
      hasDefault: true,
    );
  }

  late final DailyXpRecordUpdateTable updateTable;

  late final _i1.ColumnInt userId;

  late final _i1.ColumnDateTime day;

  late final _i1.ColumnInt xpEarned;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    day,
    xpEarned,
  ];
}

class DailyXpRecordInclude extends _i1.IncludeObject {
  DailyXpRecordInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => DailyXpRecord.t;
}

class DailyXpRecordIncludeList extends _i1.IncludeList {
  DailyXpRecordIncludeList._({
    _i1.WhereExpressionBuilder<DailyXpRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DailyXpRecord.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => DailyXpRecord.t;
}

class DailyXpRecordRepository {
  const DailyXpRecordRepository._();

  /// Returns a list of [DailyXpRecord]s matching the given query parameters.
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
  Future<List<DailyXpRecord>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DailyXpRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DailyXpRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DailyXpRecordTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DailyXpRecord>(
      where: where?.call(DailyXpRecord.t),
      orderBy: orderBy?.call(DailyXpRecord.t),
      orderByList: orderByList?.call(DailyXpRecord.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DailyXpRecord] matching the given query parameters.
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
  Future<DailyXpRecord?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DailyXpRecordTable>? where,
    int? offset,
    _i1.OrderByBuilder<DailyXpRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DailyXpRecordTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DailyXpRecord>(
      where: where?.call(DailyXpRecord.t),
      orderBy: orderBy?.call(DailyXpRecord.t),
      orderByList: orderByList?.call(DailyXpRecord.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DailyXpRecord] by its [id] or null if no such row exists.
  Future<DailyXpRecord?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DailyXpRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DailyXpRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [DailyXpRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<DailyXpRecord>> insert(
    _i1.DatabaseSession session,
    List<DailyXpRecord> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<DailyXpRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [DailyXpRecord] and returns the inserted row.
  ///
  /// The returned [DailyXpRecord] will have its `id` field set.
  Future<DailyXpRecord> insertRow(
    _i1.DatabaseSession session,
    DailyXpRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<DailyXpRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [DailyXpRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<DailyXpRecord>> update(
    _i1.DatabaseSession session,
    List<DailyXpRecord> rows, {
    _i1.ColumnSelections<DailyXpRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<DailyXpRecord>(
      rows,
      columns: columns?.call(DailyXpRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DailyXpRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DailyXpRecord> updateRow(
    _i1.DatabaseSession session,
    DailyXpRecord row, {
    _i1.ColumnSelections<DailyXpRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<DailyXpRecord>(
      row,
      columns: columns?.call(DailyXpRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DailyXpRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DailyXpRecord?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<DailyXpRecordUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<DailyXpRecord>(
      id,
      columnValues: columnValues(DailyXpRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DailyXpRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<DailyXpRecord>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<DailyXpRecordUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<DailyXpRecordTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DailyXpRecordTable>? orderBy,
    _i1.OrderByListBuilder<DailyXpRecordTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<DailyXpRecord>(
      columnValues: columnValues(DailyXpRecord.t.updateTable),
      where: where(DailyXpRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DailyXpRecord.t),
      orderByList: orderByList?.call(DailyXpRecord.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [DailyXpRecord]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<DailyXpRecord>> delete(
    _i1.DatabaseSession session,
    List<DailyXpRecord> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<DailyXpRecord>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [DailyXpRecord].
  Future<DailyXpRecord> deleteRow(
    _i1.DatabaseSession session,
    DailyXpRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DailyXpRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<DailyXpRecord>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<DailyXpRecordTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<DailyXpRecord>(
      where: where(DailyXpRecord.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DailyXpRecordTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DailyXpRecord>(
      where: where?.call(DailyXpRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DailyXpRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<DailyXpRecordTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DailyXpRecord>(
      where: where(DailyXpRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
