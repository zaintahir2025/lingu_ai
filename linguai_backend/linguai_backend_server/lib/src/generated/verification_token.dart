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

abstract class VerificationTokenRecord
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  VerificationTokenRecord._({
    this.id,
    required this.email,
    required this.tokenHash,
    required this.expiresAt,
    required this.createdAt,
  });

  factory VerificationTokenRecord({
    int? id,
    required String email,
    required String tokenHash,
    required DateTime expiresAt,
    required DateTime createdAt,
  }) = _VerificationTokenRecordImpl;

  factory VerificationTokenRecord.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return VerificationTokenRecord(
      id: jsonSerialization['id'] as int?,
      email: jsonSerialization['email'] as String,
      tokenHash: jsonSerialization['tokenHash'] as String,
      expiresAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = VerificationTokenRecordTable();

  static const db = VerificationTokenRecordRepository._();

  @override
  int? id;

  String email;

  String tokenHash;

  DateTime expiresAt;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [VerificationTokenRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  VerificationTokenRecord copyWith({
    int? id,
    String? email,
    String? tokenHash,
    DateTime? expiresAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VerificationTokenRecord',
      if (id != null) 'id': id,
      'email': email,
      'tokenHash': tokenHash,
      'expiresAt': expiresAt.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'VerificationTokenRecord',
      if (id != null) 'id': id,
      'email': email,
      'tokenHash': tokenHash,
      'expiresAt': expiresAt.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static VerificationTokenRecordInclude include() {
    return VerificationTokenRecordInclude._();
  }

  static VerificationTokenRecordIncludeList includeList({
    _i1.WhereExpressionBuilder<VerificationTokenRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<VerificationTokenRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<VerificationTokenRecordTable>? orderByList,
    VerificationTokenRecordInclude? include,
  }) {
    return VerificationTokenRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(VerificationTokenRecord.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(VerificationTokenRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VerificationTokenRecordImpl extends VerificationTokenRecord {
  _VerificationTokenRecordImpl({
    int? id,
    required String email,
    required String tokenHash,
    required DateTime expiresAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         email: email,
         tokenHash: tokenHash,
         expiresAt: expiresAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [VerificationTokenRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  VerificationTokenRecord copyWith({
    Object? id = _Undefined,
    String? email,
    String? tokenHash,
    DateTime? expiresAt,
    DateTime? createdAt,
  }) {
    return VerificationTokenRecord(
      id: id is int? ? id : this.id,
      email: email ?? this.email,
      tokenHash: tokenHash ?? this.tokenHash,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class VerificationTokenRecordUpdateTable
    extends _i1.UpdateTable<VerificationTokenRecordTable> {
  VerificationTokenRecordUpdateTable(super.table);

  _i1.ColumnValue<String, String> email(String value) => _i1.ColumnValue(
    table.email,
    value,
  );

  _i1.ColumnValue<String, String> tokenHash(String value) => _i1.ColumnValue(
    table.tokenHash,
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

class VerificationTokenRecordTable extends _i1.Table<int?> {
  VerificationTokenRecordTable({super.tableRelation})
    : super(tableName: 'verification_token') {
    updateTable = VerificationTokenRecordUpdateTable(this);
    email = _i1.ColumnString(
      'email',
      this,
    );
    tokenHash = _i1.ColumnString(
      'tokenHash',
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

  late final VerificationTokenRecordUpdateTable updateTable;

  late final _i1.ColumnString email;

  late final _i1.ColumnString tokenHash;

  late final _i1.ColumnDateTime expiresAt;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    email,
    tokenHash,
    expiresAt,
    createdAt,
  ];
}

class VerificationTokenRecordInclude extends _i1.IncludeObject {
  VerificationTokenRecordInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => VerificationTokenRecord.t;
}

class VerificationTokenRecordIncludeList extends _i1.IncludeList {
  VerificationTokenRecordIncludeList._({
    _i1.WhereExpressionBuilder<VerificationTokenRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(VerificationTokenRecord.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => VerificationTokenRecord.t;
}

class VerificationTokenRecordRepository {
  const VerificationTokenRecordRepository._();

  /// Returns a list of [VerificationTokenRecord]s matching the given query parameters.
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
  Future<List<VerificationTokenRecord>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<VerificationTokenRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<VerificationTokenRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<VerificationTokenRecordTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<VerificationTokenRecord>(
      where: where?.call(VerificationTokenRecord.t),
      orderBy: orderBy?.call(VerificationTokenRecord.t),
      orderByList: orderByList?.call(VerificationTokenRecord.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [VerificationTokenRecord] matching the given query parameters.
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
  Future<VerificationTokenRecord?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<VerificationTokenRecordTable>? where,
    int? offset,
    _i1.OrderByBuilder<VerificationTokenRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<VerificationTokenRecordTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<VerificationTokenRecord>(
      where: where?.call(VerificationTokenRecord.t),
      orderBy: orderBy?.call(VerificationTokenRecord.t),
      orderByList: orderByList?.call(VerificationTokenRecord.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [VerificationTokenRecord] by its [id] or null if no such row exists.
  Future<VerificationTokenRecord?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<VerificationTokenRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [VerificationTokenRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [VerificationTokenRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<VerificationTokenRecord>> insert(
    _i1.DatabaseSession session,
    List<VerificationTokenRecord> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<VerificationTokenRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [VerificationTokenRecord] and returns the inserted row.
  ///
  /// The returned [VerificationTokenRecord] will have its `id` field set.
  Future<VerificationTokenRecord> insertRow(
    _i1.DatabaseSession session,
    VerificationTokenRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<VerificationTokenRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [VerificationTokenRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<VerificationTokenRecord>> update(
    _i1.DatabaseSession session,
    List<VerificationTokenRecord> rows, {
    _i1.ColumnSelections<VerificationTokenRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<VerificationTokenRecord>(
      rows,
      columns: columns?.call(VerificationTokenRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [VerificationTokenRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<VerificationTokenRecord> updateRow(
    _i1.DatabaseSession session,
    VerificationTokenRecord row, {
    _i1.ColumnSelections<VerificationTokenRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<VerificationTokenRecord>(
      row,
      columns: columns?.call(VerificationTokenRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [VerificationTokenRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<VerificationTokenRecord?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<VerificationTokenRecordUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<VerificationTokenRecord>(
      id,
      columnValues: columnValues(VerificationTokenRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [VerificationTokenRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<VerificationTokenRecord>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<VerificationTokenRecordUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<VerificationTokenRecordTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<VerificationTokenRecordTable>? orderBy,
    _i1.OrderByListBuilder<VerificationTokenRecordTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<VerificationTokenRecord>(
      columnValues: columnValues(VerificationTokenRecord.t.updateTable),
      where: where(VerificationTokenRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(VerificationTokenRecord.t),
      orderByList: orderByList?.call(VerificationTokenRecord.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [VerificationTokenRecord]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<VerificationTokenRecord>> delete(
    _i1.DatabaseSession session,
    List<VerificationTokenRecord> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<VerificationTokenRecord>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [VerificationTokenRecord].
  Future<VerificationTokenRecord> deleteRow(
    _i1.DatabaseSession session,
    VerificationTokenRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<VerificationTokenRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<VerificationTokenRecord>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<VerificationTokenRecordTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<VerificationTokenRecord>(
      where: where(VerificationTokenRecord.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<VerificationTokenRecordTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<VerificationTokenRecord>(
      where: where?.call(VerificationTokenRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [VerificationTokenRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<VerificationTokenRecordTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<VerificationTokenRecord>(
      where: where(VerificationTokenRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
