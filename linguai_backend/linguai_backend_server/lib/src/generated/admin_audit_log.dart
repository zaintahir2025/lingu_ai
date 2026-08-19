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

abstract class AdminAuditLogRecord
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AdminAuditLogRecord._({
    this.id,
    this.actorUserId,
    required this.action,
    required this.targetType,
    this.targetId,
    this.details,
    required this.createdAt,
  });

  factory AdminAuditLogRecord({
    int? id,
    int? actorUserId,
    required String action,
    required String targetType,
    String? targetId,
    String? details,
    required DateTime createdAt,
  }) = _AdminAuditLogRecordImpl;

  factory AdminAuditLogRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminAuditLogRecord(
      id: jsonSerialization['id'] as int?,
      actorUserId: jsonSerialization['actorUserId'] as int?,
      action: jsonSerialization['action'] as String,
      targetType: jsonSerialization['targetType'] as String,
      targetId: jsonSerialization['targetId'] as String?,
      details: jsonSerialization['details'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = AdminAuditLogRecordTable();

  static const db = AdminAuditLogRecordRepository._();

  @override
  int? id;

  int? actorUserId;

  String action;

  String targetType;

  String? targetId;

  String? details;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AdminAuditLogRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AdminAuditLogRecord copyWith({
    int? id,
    int? actorUserId,
    String? action,
    String? targetType,
    String? targetId,
    String? details,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminAuditLogRecord',
      if (id != null) 'id': id,
      if (actorUserId != null) 'actorUserId': actorUserId,
      'action': action,
      'targetType': targetType,
      if (targetId != null) 'targetId': targetId,
      if (details != null) 'details': details,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminAuditLogRecord',
      if (id != null) 'id': id,
      if (actorUserId != null) 'actorUserId': actorUserId,
      'action': action,
      'targetType': targetType,
      if (targetId != null) 'targetId': targetId,
      if (details != null) 'details': details,
      'createdAt': createdAt.toJson(),
    };
  }

  static AdminAuditLogRecordInclude include() {
    return AdminAuditLogRecordInclude._();
  }

  static AdminAuditLogRecordIncludeList includeList({
    _i1.WhereExpressionBuilder<AdminAuditLogRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AdminAuditLogRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AdminAuditLogRecordTable>? orderByList,
    AdminAuditLogRecordInclude? include,
  }) {
    return AdminAuditLogRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AdminAuditLogRecord.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AdminAuditLogRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminAuditLogRecordImpl extends AdminAuditLogRecord {
  _AdminAuditLogRecordImpl({
    int? id,
    int? actorUserId,
    required String action,
    required String targetType,
    String? targetId,
    String? details,
    required DateTime createdAt,
  }) : super._(
         id: id,
         actorUserId: actorUserId,
         action: action,
         targetType: targetType,
         targetId: targetId,
         details: details,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AdminAuditLogRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AdminAuditLogRecord copyWith({
    Object? id = _Undefined,
    Object? actorUserId = _Undefined,
    String? action,
    String? targetType,
    Object? targetId = _Undefined,
    Object? details = _Undefined,
    DateTime? createdAt,
  }) {
    return AdminAuditLogRecord(
      id: id is int? ? id : this.id,
      actorUserId: actorUserId is int? ? actorUserId : this.actorUserId,
      action: action ?? this.action,
      targetType: targetType ?? this.targetType,
      targetId: targetId is String? ? targetId : this.targetId,
      details: details is String? ? details : this.details,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AdminAuditLogRecordUpdateTable
    extends _i1.UpdateTable<AdminAuditLogRecordTable> {
  AdminAuditLogRecordUpdateTable(super.table);

  _i1.ColumnValue<int, int> actorUserId(int? value) => _i1.ColumnValue(
    table.actorUserId,
    value,
  );

  _i1.ColumnValue<String, String> action(String value) => _i1.ColumnValue(
    table.action,
    value,
  );

  _i1.ColumnValue<String, String> targetType(String value) => _i1.ColumnValue(
    table.targetType,
    value,
  );

  _i1.ColumnValue<String, String> targetId(String? value) => _i1.ColumnValue(
    table.targetId,
    value,
  );

  _i1.ColumnValue<String, String> details(String? value) => _i1.ColumnValue(
    table.details,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class AdminAuditLogRecordTable extends _i1.Table<int?> {
  AdminAuditLogRecordTable({super.tableRelation})
    : super(tableName: 'admin_audit_log') {
    updateTable = AdminAuditLogRecordUpdateTable(this);
    actorUserId = _i1.ColumnInt(
      'actorUserId',
      this,
    );
    action = _i1.ColumnString(
      'action',
      this,
    );
    targetType = _i1.ColumnString(
      'targetType',
      this,
    );
    targetId = _i1.ColumnString(
      'targetId',
      this,
    );
    details = _i1.ColumnString(
      'details',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final AdminAuditLogRecordUpdateTable updateTable;

  late final _i1.ColumnInt actorUserId;

  late final _i1.ColumnString action;

  late final _i1.ColumnString targetType;

  late final _i1.ColumnString targetId;

  late final _i1.ColumnString details;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    actorUserId,
    action,
    targetType,
    targetId,
    details,
    createdAt,
  ];
}

class AdminAuditLogRecordInclude extends _i1.IncludeObject {
  AdminAuditLogRecordInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AdminAuditLogRecord.t;
}

class AdminAuditLogRecordIncludeList extends _i1.IncludeList {
  AdminAuditLogRecordIncludeList._({
    _i1.WhereExpressionBuilder<AdminAuditLogRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AdminAuditLogRecord.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AdminAuditLogRecord.t;
}

class AdminAuditLogRecordRepository {
  const AdminAuditLogRecordRepository._();

  /// Returns a list of [AdminAuditLogRecord]s matching the given query parameters.
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
  Future<List<AdminAuditLogRecord>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AdminAuditLogRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AdminAuditLogRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AdminAuditLogRecordTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AdminAuditLogRecord>(
      where: where?.call(AdminAuditLogRecord.t),
      orderBy: orderBy?.call(AdminAuditLogRecord.t),
      orderByList: orderByList?.call(AdminAuditLogRecord.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AdminAuditLogRecord] matching the given query parameters.
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
  Future<AdminAuditLogRecord?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AdminAuditLogRecordTable>? where,
    int? offset,
    _i1.OrderByBuilder<AdminAuditLogRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AdminAuditLogRecordTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AdminAuditLogRecord>(
      where: where?.call(AdminAuditLogRecord.t),
      orderBy: orderBy?.call(AdminAuditLogRecord.t),
      orderByList: orderByList?.call(AdminAuditLogRecord.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AdminAuditLogRecord] by its [id] or null if no such row exists.
  Future<AdminAuditLogRecord?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AdminAuditLogRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AdminAuditLogRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [AdminAuditLogRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<AdminAuditLogRecord>> insert(
    _i1.DatabaseSession session,
    List<AdminAuditLogRecord> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<AdminAuditLogRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [AdminAuditLogRecord] and returns the inserted row.
  ///
  /// The returned [AdminAuditLogRecord] will have its `id` field set.
  Future<AdminAuditLogRecord> insertRow(
    _i1.DatabaseSession session,
    AdminAuditLogRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AdminAuditLogRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AdminAuditLogRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AdminAuditLogRecord>> update(
    _i1.DatabaseSession session,
    List<AdminAuditLogRecord> rows, {
    _i1.ColumnSelections<AdminAuditLogRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AdminAuditLogRecord>(
      rows,
      columns: columns?.call(AdminAuditLogRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AdminAuditLogRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AdminAuditLogRecord> updateRow(
    _i1.DatabaseSession session,
    AdminAuditLogRecord row, {
    _i1.ColumnSelections<AdminAuditLogRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AdminAuditLogRecord>(
      row,
      columns: columns?.call(AdminAuditLogRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AdminAuditLogRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AdminAuditLogRecord?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<AdminAuditLogRecordUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AdminAuditLogRecord>(
      id,
      columnValues: columnValues(AdminAuditLogRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AdminAuditLogRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AdminAuditLogRecord>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<AdminAuditLogRecordUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<AdminAuditLogRecordTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AdminAuditLogRecordTable>? orderBy,
    _i1.OrderByListBuilder<AdminAuditLogRecordTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AdminAuditLogRecord>(
      columnValues: columnValues(AdminAuditLogRecord.t.updateTable),
      where: where(AdminAuditLogRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AdminAuditLogRecord.t),
      orderByList: orderByList?.call(AdminAuditLogRecord.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AdminAuditLogRecord]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AdminAuditLogRecord>> delete(
    _i1.DatabaseSession session,
    List<AdminAuditLogRecord> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AdminAuditLogRecord>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AdminAuditLogRecord].
  Future<AdminAuditLogRecord> deleteRow(
    _i1.DatabaseSession session,
    AdminAuditLogRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AdminAuditLogRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AdminAuditLogRecord>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AdminAuditLogRecordTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AdminAuditLogRecord>(
      where: where(AdminAuditLogRecord.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AdminAuditLogRecordTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AdminAuditLogRecord>(
      where: where?.call(AdminAuditLogRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AdminAuditLogRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AdminAuditLogRecordTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AdminAuditLogRecord>(
      where: where(AdminAuditLogRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
