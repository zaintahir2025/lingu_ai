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

abstract class SupportTicketRecord
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  SupportTicketRecord._({
    this.id,
    required this.userId,
    required this.category,
    required this.subject,
    required this.message,
    String? priority,
    String? status,
    this.reply,
    this.repliedAt,
    required this.createdAt,
    required this.updatedAt,
  }) : priority = priority ?? 'normal',
       status = status ?? 'open';

  factory SupportTicketRecord({
    int? id,
    required int userId,
    required String category,
    required String subject,
    required String message,
    String? priority,
    String? status,
    String? reply,
    DateTime? repliedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _SupportTicketRecordImpl;

  factory SupportTicketRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return SupportTicketRecord(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      category: jsonSerialization['category'] as String,
      subject: jsonSerialization['subject'] as String,
      message: jsonSerialization['message'] as String,
      priority: jsonSerialization['priority'] as String?,
      status: jsonSerialization['status'] as String?,
      reply: jsonSerialization['reply'] as String?,
      repliedAt: jsonSerialization['repliedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['repliedAt']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = SupportTicketRecordTable();

  static const db = SupportTicketRecordRepository._();

  @override
  int? id;

  int userId;

  String category;

  String subject;

  String message;

  String priority;

  String status;

  String? reply;

  DateTime? repliedAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [SupportTicketRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SupportTicketRecord copyWith({
    int? id,
    int? userId,
    String? category,
    String? subject,
    String? message,
    String? priority,
    String? status,
    String? reply,
    DateTime? repliedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SupportTicketRecord',
      if (id != null) 'id': id,
      'userId': userId,
      'category': category,
      'subject': subject,
      'message': message,
      'priority': priority,
      'status': status,
      if (reply != null) 'reply': reply,
      if (repliedAt != null) 'repliedAt': repliedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SupportTicketRecord',
      if (id != null) 'id': id,
      'userId': userId,
      'category': category,
      'subject': subject,
      'message': message,
      'priority': priority,
      'status': status,
      if (reply != null) 'reply': reply,
      if (repliedAt != null) 'repliedAt': repliedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static SupportTicketRecordInclude include() {
    return SupportTicketRecordInclude._();
  }

  static SupportTicketRecordIncludeList includeList({
    _i1.WhereExpressionBuilder<SupportTicketRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SupportTicketRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SupportTicketRecordTable>? orderByList,
    SupportTicketRecordInclude? include,
  }) {
    return SupportTicketRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SupportTicketRecord.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(SupportTicketRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SupportTicketRecordImpl extends SupportTicketRecord {
  _SupportTicketRecordImpl({
    int? id,
    required int userId,
    required String category,
    required String subject,
    required String message,
    String? priority,
    String? status,
    String? reply,
    DateTime? repliedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         category: category,
         subject: subject,
         message: message,
         priority: priority,
         status: status,
         reply: reply,
         repliedAt: repliedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [SupportTicketRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SupportTicketRecord copyWith({
    Object? id = _Undefined,
    int? userId,
    String? category,
    String? subject,
    String? message,
    String? priority,
    String? status,
    Object? reply = _Undefined,
    Object? repliedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SupportTicketRecord(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      category: category ?? this.category,
      subject: subject ?? this.subject,
      message: message ?? this.message,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      reply: reply is String? ? reply : this.reply,
      repliedAt: repliedAt is DateTime? ? repliedAt : this.repliedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class SupportTicketRecordUpdateTable
    extends _i1.UpdateTable<SupportTicketRecordTable> {
  SupportTicketRecordUpdateTable(super.table);

  _i1.ColumnValue<int, int> userId(int value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<String, String> category(String value) => _i1.ColumnValue(
    table.category,
    value,
  );

  _i1.ColumnValue<String, String> subject(String value) => _i1.ColumnValue(
    table.subject,
    value,
  );

  _i1.ColumnValue<String, String> message(String value) => _i1.ColumnValue(
    table.message,
    value,
  );

  _i1.ColumnValue<String, String> priority(String value) => _i1.ColumnValue(
    table.priority,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<String, String> reply(String? value) => _i1.ColumnValue(
    table.reply,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> repliedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.repliedAt,
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

class SupportTicketRecordTable extends _i1.Table<int?> {
  SupportTicketRecordTable({super.tableRelation})
    : super(tableName: 'support_ticket') {
    updateTable = SupportTicketRecordUpdateTable(this);
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    category = _i1.ColumnString(
      'category',
      this,
    );
    subject = _i1.ColumnString(
      'subject',
      this,
    );
    message = _i1.ColumnString(
      'message',
      this,
    );
    priority = _i1.ColumnString(
      'priority',
      this,
      hasDefault: true,
    );
    status = _i1.ColumnString(
      'status',
      this,
      hasDefault: true,
    );
    reply = _i1.ColumnString(
      'reply',
      this,
    );
    repliedAt = _i1.ColumnDateTime(
      'repliedAt',
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

  late final SupportTicketRecordUpdateTable updateTable;

  late final _i1.ColumnInt userId;

  late final _i1.ColumnString category;

  late final _i1.ColumnString subject;

  late final _i1.ColumnString message;

  late final _i1.ColumnString priority;

  late final _i1.ColumnString status;

  late final _i1.ColumnString reply;

  late final _i1.ColumnDateTime repliedAt;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    category,
    subject,
    message,
    priority,
    status,
    reply,
    repliedAt,
    createdAt,
    updatedAt,
  ];
}

class SupportTicketRecordInclude extends _i1.IncludeObject {
  SupportTicketRecordInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => SupportTicketRecord.t;
}

class SupportTicketRecordIncludeList extends _i1.IncludeList {
  SupportTicketRecordIncludeList._({
    _i1.WhereExpressionBuilder<SupportTicketRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SupportTicketRecord.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => SupportTicketRecord.t;
}

class SupportTicketRecordRepository {
  const SupportTicketRecordRepository._();

  /// Returns a list of [SupportTicketRecord]s matching the given query parameters.
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
  Future<List<SupportTicketRecord>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<SupportTicketRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SupportTicketRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SupportTicketRecordTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SupportTicketRecord>(
      where: where?.call(SupportTicketRecord.t),
      orderBy: orderBy?.call(SupportTicketRecord.t),
      orderByList: orderByList?.call(SupportTicketRecord.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [SupportTicketRecord] matching the given query parameters.
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
  Future<SupportTicketRecord?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<SupportTicketRecordTable>? where,
    int? offset,
    _i1.OrderByBuilder<SupportTicketRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SupportTicketRecordTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SupportTicketRecord>(
      where: where?.call(SupportTicketRecord.t),
      orderBy: orderBy?.call(SupportTicketRecord.t),
      orderByList: orderByList?.call(SupportTicketRecord.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SupportTicketRecord] by its [id] or null if no such row exists.
  Future<SupportTicketRecord?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SupportTicketRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SupportTicketRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [SupportTicketRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<SupportTicketRecord>> insert(
    _i1.DatabaseSession session,
    List<SupportTicketRecord> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<SupportTicketRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [SupportTicketRecord] and returns the inserted row.
  ///
  /// The returned [SupportTicketRecord] will have its `id` field set.
  Future<SupportTicketRecord> insertRow(
    _i1.DatabaseSession session,
    SupportTicketRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<SupportTicketRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [SupportTicketRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<SupportTicketRecord>> update(
    _i1.DatabaseSession session,
    List<SupportTicketRecord> rows, {
    _i1.ColumnSelections<SupportTicketRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<SupportTicketRecord>(
      rows,
      columns: columns?.call(SupportTicketRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SupportTicketRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SupportTicketRecord> updateRow(
    _i1.DatabaseSession session,
    SupportTicketRecord row, {
    _i1.ColumnSelections<SupportTicketRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<SupportTicketRecord>(
      row,
      columns: columns?.call(SupportTicketRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SupportTicketRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SupportTicketRecord?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<SupportTicketRecordUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<SupportTicketRecord>(
      id,
      columnValues: columnValues(SupportTicketRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SupportTicketRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<SupportTicketRecord>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<SupportTicketRecordUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<SupportTicketRecordTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SupportTicketRecordTable>? orderBy,
    _i1.OrderByListBuilder<SupportTicketRecordTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<SupportTicketRecord>(
      columnValues: columnValues(SupportTicketRecord.t.updateTable),
      where: where(SupportTicketRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SupportTicketRecord.t),
      orderByList: orderByList?.call(SupportTicketRecord.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [SupportTicketRecord]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<SupportTicketRecord>> delete(
    _i1.DatabaseSession session,
    List<SupportTicketRecord> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SupportTicketRecord>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [SupportTicketRecord].
  Future<SupportTicketRecord> deleteRow(
    _i1.DatabaseSession session,
    SupportTicketRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SupportTicketRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<SupportTicketRecord>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<SupportTicketRecordTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<SupportTicketRecord>(
      where: where(SupportTicketRecord.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<SupportTicketRecordTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SupportTicketRecord>(
      where: where?.call(SupportTicketRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SupportTicketRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<SupportTicketRecordTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SupportTicketRecord>(
      where: where(SupportTicketRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
