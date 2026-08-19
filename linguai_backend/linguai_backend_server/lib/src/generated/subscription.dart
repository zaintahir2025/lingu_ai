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

abstract class SubscriptionRecord
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  SubscriptionRecord._({
    this.id,
    required this.userId,
    required this.provider,
    required this.externalId,
    this.customerId,
    required this.status,
    required this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubscriptionRecord({
    int? id,
    required int userId,
    required String provider,
    required String externalId,
    String? customerId,
    required String status,
    required DateTime expiresAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _SubscriptionRecordImpl;

  factory SubscriptionRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return SubscriptionRecord(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      provider: jsonSerialization['provider'] as String,
      externalId: jsonSerialization['externalId'] as String,
      customerId: jsonSerialization['customerId'] as String?,
      status: jsonSerialization['status'] as String,
      expiresAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = SubscriptionRecordTable();

  static const db = SubscriptionRecordRepository._();

  @override
  int? id;

  int userId;

  String provider;

  String externalId;

  String? customerId;

  String status;

  DateTime expiresAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [SubscriptionRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SubscriptionRecord copyWith({
    int? id,
    int? userId,
    String? provider,
    String? externalId,
    String? customerId,
    String? status,
    DateTime? expiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SubscriptionRecord',
      if (id != null) 'id': id,
      'userId': userId,
      'provider': provider,
      'externalId': externalId,
      if (customerId != null) 'customerId': customerId,
      'status': status,
      'expiresAt': expiresAt.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SubscriptionRecord',
      if (id != null) 'id': id,
      'userId': userId,
      'provider': provider,
      'externalId': externalId,
      if (customerId != null) 'customerId': customerId,
      'status': status,
      'expiresAt': expiresAt.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static SubscriptionRecordInclude include() {
    return SubscriptionRecordInclude._();
  }

  static SubscriptionRecordIncludeList includeList({
    _i1.WhereExpressionBuilder<SubscriptionRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SubscriptionRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SubscriptionRecordTable>? orderByList,
    SubscriptionRecordInclude? include,
  }) {
    return SubscriptionRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SubscriptionRecord.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(SubscriptionRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SubscriptionRecordImpl extends SubscriptionRecord {
  _SubscriptionRecordImpl({
    int? id,
    required int userId,
    required String provider,
    required String externalId,
    String? customerId,
    required String status,
    required DateTime expiresAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         provider: provider,
         externalId: externalId,
         customerId: customerId,
         status: status,
         expiresAt: expiresAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [SubscriptionRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SubscriptionRecord copyWith({
    Object? id = _Undefined,
    int? userId,
    String? provider,
    String? externalId,
    Object? customerId = _Undefined,
    String? status,
    DateTime? expiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubscriptionRecord(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      provider: provider ?? this.provider,
      externalId: externalId ?? this.externalId,
      customerId: customerId is String? ? customerId : this.customerId,
      status: status ?? this.status,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class SubscriptionRecordUpdateTable
    extends _i1.UpdateTable<SubscriptionRecordTable> {
  SubscriptionRecordUpdateTable(super.table);

  _i1.ColumnValue<int, int> userId(int value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<String, String> provider(String value) => _i1.ColumnValue(
    table.provider,
    value,
  );

  _i1.ColumnValue<String, String> externalId(String value) => _i1.ColumnValue(
    table.externalId,
    value,
  );

  _i1.ColumnValue<String, String> customerId(String? value) => _i1.ColumnValue(
    table.customerId,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
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

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class SubscriptionRecordTable extends _i1.Table<int?> {
  SubscriptionRecordTable({super.tableRelation})
    : super(tableName: 'subscription') {
    updateTable = SubscriptionRecordUpdateTable(this);
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    provider = _i1.ColumnString(
      'provider',
      this,
    );
    externalId = _i1.ColumnString(
      'externalId',
      this,
    );
    customerId = _i1.ColumnString(
      'customerId',
      this,
    );
    status = _i1.ColumnString(
      'status',
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
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final SubscriptionRecordUpdateTable updateTable;

  late final _i1.ColumnInt userId;

  late final _i1.ColumnString provider;

  late final _i1.ColumnString externalId;

  late final _i1.ColumnString customerId;

  late final _i1.ColumnString status;

  late final _i1.ColumnDateTime expiresAt;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    provider,
    externalId,
    customerId,
    status,
    expiresAt,
    createdAt,
    updatedAt,
  ];
}

class SubscriptionRecordInclude extends _i1.IncludeObject {
  SubscriptionRecordInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => SubscriptionRecord.t;
}

class SubscriptionRecordIncludeList extends _i1.IncludeList {
  SubscriptionRecordIncludeList._({
    _i1.WhereExpressionBuilder<SubscriptionRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SubscriptionRecord.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => SubscriptionRecord.t;
}

class SubscriptionRecordRepository {
  const SubscriptionRecordRepository._();

  /// Returns a list of [SubscriptionRecord]s matching the given query parameters.
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
  Future<List<SubscriptionRecord>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<SubscriptionRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SubscriptionRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SubscriptionRecordTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SubscriptionRecord>(
      where: where?.call(SubscriptionRecord.t),
      orderBy: orderBy?.call(SubscriptionRecord.t),
      orderByList: orderByList?.call(SubscriptionRecord.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [SubscriptionRecord] matching the given query parameters.
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
  Future<SubscriptionRecord?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<SubscriptionRecordTable>? where,
    int? offset,
    _i1.OrderByBuilder<SubscriptionRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SubscriptionRecordTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SubscriptionRecord>(
      where: where?.call(SubscriptionRecord.t),
      orderBy: orderBy?.call(SubscriptionRecord.t),
      orderByList: orderByList?.call(SubscriptionRecord.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SubscriptionRecord] by its [id] or null if no such row exists.
  Future<SubscriptionRecord?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SubscriptionRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SubscriptionRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [SubscriptionRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<SubscriptionRecord>> insert(
    _i1.DatabaseSession session,
    List<SubscriptionRecord> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<SubscriptionRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [SubscriptionRecord] and returns the inserted row.
  ///
  /// The returned [SubscriptionRecord] will have its `id` field set.
  Future<SubscriptionRecord> insertRow(
    _i1.DatabaseSession session,
    SubscriptionRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<SubscriptionRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [SubscriptionRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<SubscriptionRecord>> update(
    _i1.DatabaseSession session,
    List<SubscriptionRecord> rows, {
    _i1.ColumnSelections<SubscriptionRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<SubscriptionRecord>(
      rows,
      columns: columns?.call(SubscriptionRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SubscriptionRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SubscriptionRecord> updateRow(
    _i1.DatabaseSession session,
    SubscriptionRecord row, {
    _i1.ColumnSelections<SubscriptionRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<SubscriptionRecord>(
      row,
      columns: columns?.call(SubscriptionRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SubscriptionRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SubscriptionRecord?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<SubscriptionRecordUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<SubscriptionRecord>(
      id,
      columnValues: columnValues(SubscriptionRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SubscriptionRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<SubscriptionRecord>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<SubscriptionRecordUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<SubscriptionRecordTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SubscriptionRecordTable>? orderBy,
    _i1.OrderByListBuilder<SubscriptionRecordTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<SubscriptionRecord>(
      columnValues: columnValues(SubscriptionRecord.t.updateTable),
      where: where(SubscriptionRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SubscriptionRecord.t),
      orderByList: orderByList?.call(SubscriptionRecord.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [SubscriptionRecord]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<SubscriptionRecord>> delete(
    _i1.DatabaseSession session,
    List<SubscriptionRecord> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SubscriptionRecord>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [SubscriptionRecord].
  Future<SubscriptionRecord> deleteRow(
    _i1.DatabaseSession session,
    SubscriptionRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SubscriptionRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<SubscriptionRecord>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<SubscriptionRecordTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<SubscriptionRecord>(
      where: where(SubscriptionRecord.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<SubscriptionRecordTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SubscriptionRecord>(
      where: where?.call(SubscriptionRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SubscriptionRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<SubscriptionRecordTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SubscriptionRecord>(
      where: where(SubscriptionRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
