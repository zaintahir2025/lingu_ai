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

abstract class RefreshTokenRecord
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  RefreshTokenRecord._({
    this.id,
    required this.tokenHash,
    required this.userId,
    this.device,
    required this.expiresAt,
    required this.createdAt,
  });

  factory RefreshTokenRecord({
    int? id,
    required String tokenHash,
    required int userId,
    String? device,
    required DateTime expiresAt,
    required DateTime createdAt,
  }) = _RefreshTokenRecordImpl;

  factory RefreshTokenRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return RefreshTokenRecord(
      id: jsonSerialization['id'] as int?,
      tokenHash: jsonSerialization['tokenHash'] as String,
      userId: jsonSerialization['userId'] as int,
      device: jsonSerialization['device'] as String?,
      expiresAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = RefreshTokenRecordTable();

  static const db = RefreshTokenRecordRepository._();

  @override
  int? id;

  String tokenHash;

  int userId;

  String? device;

  DateTime expiresAt;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [RefreshTokenRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RefreshTokenRecord copyWith({
    int? id,
    String? tokenHash,
    int? userId,
    String? device,
    DateTime? expiresAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RefreshTokenRecord',
      if (id != null) 'id': id,
      'tokenHash': tokenHash,
      'userId': userId,
      if (device != null) 'device': device,
      'expiresAt': expiresAt.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RefreshTokenRecord',
      if (id != null) 'id': id,
      'tokenHash': tokenHash,
      'userId': userId,
      if (device != null) 'device': device,
      'expiresAt': expiresAt.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static RefreshTokenRecordInclude include() {
    return RefreshTokenRecordInclude._();
  }

  static RefreshTokenRecordIncludeList includeList({
    _i1.WhereExpressionBuilder<RefreshTokenRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RefreshTokenRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RefreshTokenRecordTable>? orderByList,
    RefreshTokenRecordInclude? include,
  }) {
    return RefreshTokenRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RefreshTokenRecord.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(RefreshTokenRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RefreshTokenRecordImpl extends RefreshTokenRecord {
  _RefreshTokenRecordImpl({
    int? id,
    required String tokenHash,
    required int userId,
    String? device,
    required DateTime expiresAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         tokenHash: tokenHash,
         userId: userId,
         device: device,
         expiresAt: expiresAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [RefreshTokenRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RefreshTokenRecord copyWith({
    Object? id = _Undefined,
    String? tokenHash,
    int? userId,
    Object? device = _Undefined,
    DateTime? expiresAt,
    DateTime? createdAt,
  }) {
    return RefreshTokenRecord(
      id: id is int? ? id : this.id,
      tokenHash: tokenHash ?? this.tokenHash,
      userId: userId ?? this.userId,
      device: device is String? ? device : this.device,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class RefreshTokenRecordUpdateTable
    extends _i1.UpdateTable<RefreshTokenRecordTable> {
  RefreshTokenRecordUpdateTable(super.table);

  _i1.ColumnValue<String, String> tokenHash(String value) => _i1.ColumnValue(
    table.tokenHash,
    value,
  );

  _i1.ColumnValue<int, int> userId(int value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<String, String> device(String? value) => _i1.ColumnValue(
    table.device,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> expiresAt(DateTime value) =>
      _i1.ColumnValue(
        table.expiresAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class RefreshTokenRecordTable extends _i1.Table<int?> {
  RefreshTokenRecordTable({super.tableRelation})
    : super(tableName: 'refresh_token') {
    updateTable = RefreshTokenRecordUpdateTable(this);
    tokenHash = _i1.ColumnString(
      'tokenHash',
      this,
    );
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    device = _i1.ColumnString(
      'device',
      this,
    );
    expiresAt = _i1.ColumnDateTime(
      'expiresAt',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final RefreshTokenRecordUpdateTable updateTable;

  late final _i1.ColumnString tokenHash;

  late final _i1.ColumnInt userId;

  late final _i1.ColumnString device;

  late final _i1.ColumnDateTime expiresAt;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    tokenHash,
    userId,
    device,
    expiresAt,
    createdAt,
  ];
}

class RefreshTokenRecordInclude extends _i1.IncludeObject {
  RefreshTokenRecordInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => RefreshTokenRecord.t;
}

class RefreshTokenRecordIncludeList extends _i1.IncludeList {
  RefreshTokenRecordIncludeList._({
    _i1.WhereExpressionBuilder<RefreshTokenRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RefreshTokenRecord.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => RefreshTokenRecord.t;
}

class RefreshTokenRecordRepository {
  const RefreshTokenRecordRepository._();

  /// Returns a list of [RefreshTokenRecord]s matching the given query parameters.
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
  Future<List<RefreshTokenRecord>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RefreshTokenRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RefreshTokenRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RefreshTokenRecordTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RefreshTokenRecord>(
      where: where?.call(RefreshTokenRecord.t),
      orderBy: orderBy?.call(RefreshTokenRecord.t),
      orderByList: orderByList?.call(RefreshTokenRecord.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RefreshTokenRecord] matching the given query parameters.
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
  Future<RefreshTokenRecord?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RefreshTokenRecordTable>? where,
    int? offset,
    _i1.OrderByBuilder<RefreshTokenRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RefreshTokenRecordTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RefreshTokenRecord>(
      where: where?.call(RefreshTokenRecord.t),
      orderBy: orderBy?.call(RefreshTokenRecord.t),
      orderByList: orderByList?.call(RefreshTokenRecord.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RefreshTokenRecord] by its [id] or null if no such row exists.
  Future<RefreshTokenRecord?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RefreshTokenRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RefreshTokenRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [RefreshTokenRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<RefreshTokenRecord>> insert(
    _i1.DatabaseSession session,
    List<RefreshTokenRecord> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<RefreshTokenRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [RefreshTokenRecord] and returns the inserted row.
  ///
  /// The returned [RefreshTokenRecord] will have its `id` field set.
  Future<RefreshTokenRecord> insertRow(
    _i1.DatabaseSession session,
    RefreshTokenRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<RefreshTokenRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [RefreshTokenRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<RefreshTokenRecord>> update(
    _i1.DatabaseSession session,
    List<RefreshTokenRecord> rows, {
    _i1.ColumnSelections<RefreshTokenRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<RefreshTokenRecord>(
      rows,
      columns: columns?.call(RefreshTokenRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RefreshTokenRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RefreshTokenRecord> updateRow(
    _i1.DatabaseSession session,
    RefreshTokenRecord row, {
    _i1.ColumnSelections<RefreshTokenRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<RefreshTokenRecord>(
      row,
      columns: columns?.call(RefreshTokenRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RefreshTokenRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RefreshTokenRecord?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<RefreshTokenRecordUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<RefreshTokenRecord>(
      id,
      columnValues: columnValues(RefreshTokenRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RefreshTokenRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<RefreshTokenRecord>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<RefreshTokenRecordUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<RefreshTokenRecordTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RefreshTokenRecordTable>? orderBy,
    _i1.OrderByListBuilder<RefreshTokenRecordTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<RefreshTokenRecord>(
      columnValues: columnValues(RefreshTokenRecord.t.updateTable),
      where: where(RefreshTokenRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RefreshTokenRecord.t),
      orderByList: orderByList?.call(RefreshTokenRecord.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [RefreshTokenRecord]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<RefreshTokenRecord>> delete(
    _i1.DatabaseSession session,
    List<RefreshTokenRecord> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<RefreshTokenRecord>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [RefreshTokenRecord].
  Future<RefreshTokenRecord> deleteRow(
    _i1.DatabaseSession session,
    RefreshTokenRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RefreshTokenRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<RefreshTokenRecord>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RefreshTokenRecordTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<RefreshTokenRecord>(
      where: where(RefreshTokenRecord.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RefreshTokenRecordTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<RefreshTokenRecord>(
      where: where?.call(RefreshTokenRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RefreshTokenRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RefreshTokenRecordTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RefreshTokenRecord>(
      where: where(RefreshTokenRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
