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

abstract class UserVocabRecord
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  UserVocabRecord._({
    this.id,
    required this.userId,
    required this.vocabWordId,
    String? status,
    this.nextReviewDate,
    int? repetitions,
    double? easinessFactor,
    int? intervalDays,
    int? errorCount,
    this.lastReviewedAt,
    required this.updatedAt,
  }) : status = status ?? 'new',
       repetitions = repetitions ?? 0,
       easinessFactor = easinessFactor ?? 2.5,
       intervalDays = intervalDays ?? 0,
       errorCount = errorCount ?? 0;

  factory UserVocabRecord({
    int? id,
    required int userId,
    required int vocabWordId,
    String? status,
    DateTime? nextReviewDate,
    int? repetitions,
    double? easinessFactor,
    int? intervalDays,
    int? errorCount,
    DateTime? lastReviewedAt,
    required DateTime updatedAt,
  }) = _UserVocabRecordImpl;

  factory UserVocabRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserVocabRecord(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      vocabWordId: jsonSerialization['vocabWordId'] as int,
      status: jsonSerialization['status'] as String?,
      nextReviewDate: jsonSerialization['nextReviewDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['nextReviewDate'],
            ),
      repetitions: jsonSerialization['repetitions'] as int?,
      easinessFactor: (jsonSerialization['easinessFactor'] as num?)?.toDouble(),
      intervalDays: jsonSerialization['intervalDays'] as int?,
      errorCount: jsonSerialization['errorCount'] as int?,
      lastReviewedAt: jsonSerialization['lastReviewedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastReviewedAt'],
            ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = UserVocabRecordTable();

  static const db = UserVocabRecordRepository._();

  @override
  int? id;

  int userId;

  int vocabWordId;

  String status;

  DateTime? nextReviewDate;

  int repetitions;

  double easinessFactor;

  int intervalDays;

  int errorCount;

  DateTime? lastReviewedAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [UserVocabRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserVocabRecord copyWith({
    int? id,
    int? userId,
    int? vocabWordId,
    String? status,
    DateTime? nextReviewDate,
    int? repetitions,
    double? easinessFactor,
    int? intervalDays,
    int? errorCount,
    DateTime? lastReviewedAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserVocabRecord',
      if (id != null) 'id': id,
      'userId': userId,
      'vocabWordId': vocabWordId,
      'status': status,
      if (nextReviewDate != null) 'nextReviewDate': nextReviewDate?.toJson(),
      'repetitions': repetitions,
      'easinessFactor': easinessFactor,
      'intervalDays': intervalDays,
      'errorCount': errorCount,
      if (lastReviewedAt != null) 'lastReviewedAt': lastReviewedAt?.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserVocabRecord',
      if (id != null) 'id': id,
      'userId': userId,
      'vocabWordId': vocabWordId,
      'status': status,
      if (nextReviewDate != null) 'nextReviewDate': nextReviewDate?.toJson(),
      'repetitions': repetitions,
      'easinessFactor': easinessFactor,
      'intervalDays': intervalDays,
      'errorCount': errorCount,
      if (lastReviewedAt != null) 'lastReviewedAt': lastReviewedAt?.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static UserVocabRecordInclude include() {
    return UserVocabRecordInclude._();
  }

  static UserVocabRecordIncludeList includeList({
    _i1.WhereExpressionBuilder<UserVocabRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserVocabRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserVocabRecordTable>? orderByList,
    UserVocabRecordInclude? include,
  }) {
    return UserVocabRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserVocabRecord.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserVocabRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserVocabRecordImpl extends UserVocabRecord {
  _UserVocabRecordImpl({
    int? id,
    required int userId,
    required int vocabWordId,
    String? status,
    DateTime? nextReviewDate,
    int? repetitions,
    double? easinessFactor,
    int? intervalDays,
    int? errorCount,
    DateTime? lastReviewedAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         vocabWordId: vocabWordId,
         status: status,
         nextReviewDate: nextReviewDate,
         repetitions: repetitions,
         easinessFactor: easinessFactor,
         intervalDays: intervalDays,
         errorCount: errorCount,
         lastReviewedAt: lastReviewedAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [UserVocabRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserVocabRecord copyWith({
    Object? id = _Undefined,
    int? userId,
    int? vocabWordId,
    String? status,
    Object? nextReviewDate = _Undefined,
    int? repetitions,
    double? easinessFactor,
    int? intervalDays,
    int? errorCount,
    Object? lastReviewedAt = _Undefined,
    DateTime? updatedAt,
  }) {
    return UserVocabRecord(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      vocabWordId: vocabWordId ?? this.vocabWordId,
      status: status ?? this.status,
      nextReviewDate: nextReviewDate is DateTime?
          ? nextReviewDate
          : this.nextReviewDate,
      repetitions: repetitions ?? this.repetitions,
      easinessFactor: easinessFactor ?? this.easinessFactor,
      intervalDays: intervalDays ?? this.intervalDays,
      errorCount: errorCount ?? this.errorCount,
      lastReviewedAt: lastReviewedAt is DateTime?
          ? lastReviewedAt
          : this.lastReviewedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class UserVocabRecordUpdateTable extends _i1.UpdateTable<UserVocabRecordTable> {
  UserVocabRecordUpdateTable(super.table);

  _i1.ColumnValue<int, int> userId(int value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<int, int> vocabWordId(int value) => _i1.ColumnValue(
    table.vocabWordId,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> nextReviewDate(DateTime? value) =>
      _i1.ColumnValue(
        table.nextReviewDate,
        value,
      );

  _i1.ColumnValue<int, int> repetitions(int value) => _i1.ColumnValue(
    table.repetitions,
    value,
  );

  _i1.ColumnValue<double, double> easinessFactor(double value) =>
      _i1.ColumnValue(
        table.easinessFactor,
        value,
      );

  _i1.ColumnValue<int, int> intervalDays(int value) => _i1.ColumnValue(
    table.intervalDays,
    value,
  );

  _i1.ColumnValue<int, int> errorCount(int value) => _i1.ColumnValue(
    table.errorCount,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> lastReviewedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.lastReviewedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class UserVocabRecordTable extends _i1.Table<int?> {
  UserVocabRecordTable({super.tableRelation}) : super(tableName: 'user_vocab') {
    updateTable = UserVocabRecordUpdateTable(this);
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    vocabWordId = _i1.ColumnInt(
      'vocabWordId',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
      hasDefault: true,
    );
    nextReviewDate = _i1.ColumnDateTime(
      'nextReviewDate',
      this,
    );
    repetitions = _i1.ColumnInt(
      'repetitions',
      this,
      hasDefault: true,
    );
    easinessFactor = _i1.ColumnDouble(
      'easinessFactor',
      this,
      hasDefault: true,
    );
    intervalDays = _i1.ColumnInt(
      'intervalDays',
      this,
      hasDefault: true,
    );
    errorCount = _i1.ColumnInt(
      'errorCount',
      this,
      hasDefault: true,
    );
    lastReviewedAt = _i1.ColumnDateTime(
      'lastReviewedAt',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final UserVocabRecordUpdateTable updateTable;

  late final _i1.ColumnInt userId;

  late final _i1.ColumnInt vocabWordId;

  late final _i1.ColumnString status;

  late final _i1.ColumnDateTime nextReviewDate;

  late final _i1.ColumnInt repetitions;

  late final _i1.ColumnDouble easinessFactor;

  late final _i1.ColumnInt intervalDays;

  late final _i1.ColumnInt errorCount;

  late final _i1.ColumnDateTime lastReviewedAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    vocabWordId,
    status,
    nextReviewDate,
    repetitions,
    easinessFactor,
    intervalDays,
    errorCount,
    lastReviewedAt,
    updatedAt,
  ];
}

class UserVocabRecordInclude extends _i1.IncludeObject {
  UserVocabRecordInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => UserVocabRecord.t;
}

class UserVocabRecordIncludeList extends _i1.IncludeList {
  UserVocabRecordIncludeList._({
    _i1.WhereExpressionBuilder<UserVocabRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserVocabRecord.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => UserVocabRecord.t;
}

class UserVocabRecordRepository {
  const UserVocabRecordRepository._();

  /// Returns a list of [UserVocabRecord]s matching the given query parameters.
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
  Future<List<UserVocabRecord>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UserVocabRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserVocabRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserVocabRecordTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UserVocabRecord>(
      where: where?.call(UserVocabRecord.t),
      orderBy: orderBy?.call(UserVocabRecord.t),
      orderByList: orderByList?.call(UserVocabRecord.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UserVocabRecord] matching the given query parameters.
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
  Future<UserVocabRecord?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UserVocabRecordTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserVocabRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserVocabRecordTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UserVocabRecord>(
      where: where?.call(UserVocabRecord.t),
      orderBy: orderBy?.call(UserVocabRecord.t),
      orderByList: orderByList?.call(UserVocabRecord.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UserVocabRecord] by its [id] or null if no such row exists.
  Future<UserVocabRecord?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UserVocabRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UserVocabRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [UserVocabRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<UserVocabRecord>> insert(
    _i1.DatabaseSession session,
    List<UserVocabRecord> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<UserVocabRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [UserVocabRecord] and returns the inserted row.
  ///
  /// The returned [UserVocabRecord] will have its `id` field set.
  Future<UserVocabRecord> insertRow(
    _i1.DatabaseSession session,
    UserVocabRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserVocabRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserVocabRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserVocabRecord>> update(
    _i1.DatabaseSession session,
    List<UserVocabRecord> rows, {
    _i1.ColumnSelections<UserVocabRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserVocabRecord>(
      rows,
      columns: columns?.call(UserVocabRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserVocabRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserVocabRecord> updateRow(
    _i1.DatabaseSession session,
    UserVocabRecord row, {
    _i1.ColumnSelections<UserVocabRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserVocabRecord>(
      row,
      columns: columns?.call(UserVocabRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserVocabRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserVocabRecord?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<UserVocabRecordUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<UserVocabRecord>(
      id,
      columnValues: columnValues(UserVocabRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserVocabRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<UserVocabRecord>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<UserVocabRecordUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<UserVocabRecordTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserVocabRecordTable>? orderBy,
    _i1.OrderByListBuilder<UserVocabRecordTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<UserVocabRecord>(
      columnValues: columnValues(UserVocabRecord.t.updateTable),
      where: where(UserVocabRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserVocabRecord.t),
      orderByList: orderByList?.call(UserVocabRecord.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [UserVocabRecord]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserVocabRecord>> delete(
    _i1.DatabaseSession session,
    List<UserVocabRecord> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserVocabRecord>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserVocabRecord].
  Future<UserVocabRecord> deleteRow(
    _i1.DatabaseSession session,
    UserVocabRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserVocabRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserVocabRecord>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<UserVocabRecordTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserVocabRecord>(
      where: where(UserVocabRecord.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UserVocabRecordTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserVocabRecord>(
      where: where?.call(UserVocabRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UserVocabRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<UserVocabRecordTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UserVocabRecord>(
      where: where(UserVocabRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
