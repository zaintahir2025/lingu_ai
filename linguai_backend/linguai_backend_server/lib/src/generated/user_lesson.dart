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

abstract class UserLessonRecord
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  UserLessonRecord._({
    this.id,
    required this.userId,
    required this.lessonId,
    bool? isLocked,
    bool? isCompleted,
    int? currentStep,
    this.draftJson,
    int? bestScore,
    int? attempts,
    this.completedAt,
    required this.updatedAt,
  }) : isLocked = isLocked ?? true,
       isCompleted = isCompleted ?? false,
       currentStep = currentStep ?? 0,
       bestScore = bestScore ?? 0,
       attempts = attempts ?? 0;

  factory UserLessonRecord({
    int? id,
    required int userId,
    required int lessonId,
    bool? isLocked,
    bool? isCompleted,
    int? currentStep,
    String? draftJson,
    int? bestScore,
    int? attempts,
    DateTime? completedAt,
    required DateTime updatedAt,
  }) = _UserLessonRecordImpl;

  factory UserLessonRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserLessonRecord(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      lessonId: jsonSerialization['lessonId'] as int,
      isLocked: jsonSerialization['isLocked'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isLocked']),
      isCompleted: jsonSerialization['isCompleted'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isCompleted']),
      currentStep: jsonSerialization['currentStep'] as int?,
      draftJson: jsonSerialization['draftJson'] as String?,
      bestScore: jsonSerialization['bestScore'] as int?,
      attempts: jsonSerialization['attempts'] as int?,
      completedAt: jsonSerialization['completedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['completedAt'],
            ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = UserLessonRecordTable();

  static const db = UserLessonRecordRepository._();

  @override
  int? id;

  int userId;

  int lessonId;

  bool isLocked;

  bool isCompleted;

  int currentStep;

  String? draftJson;

  int bestScore;

  int attempts;

  DateTime? completedAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [UserLessonRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserLessonRecord copyWith({
    int? id,
    int? userId,
    int? lessonId,
    bool? isLocked,
    bool? isCompleted,
    int? currentStep,
    String? draftJson,
    int? bestScore,
    int? attempts,
    DateTime? completedAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserLessonRecord',
      if (id != null) 'id': id,
      'userId': userId,
      'lessonId': lessonId,
      'isLocked': isLocked,
      'isCompleted': isCompleted,
      'currentStep': currentStep,
      if (draftJson != null) 'draftJson': draftJson,
      'bestScore': bestScore,
      'attempts': attempts,
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserLessonRecord',
      if (id != null) 'id': id,
      'userId': userId,
      'lessonId': lessonId,
      'isLocked': isLocked,
      'isCompleted': isCompleted,
      'currentStep': currentStep,
      if (draftJson != null) 'draftJson': draftJson,
      'bestScore': bestScore,
      'attempts': attempts,
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static UserLessonRecordInclude include() {
    return UserLessonRecordInclude._();
  }

  static UserLessonRecordIncludeList includeList({
    _i1.WhereExpressionBuilder<UserLessonRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserLessonRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserLessonRecordTable>? orderByList,
    UserLessonRecordInclude? include,
  }) {
    return UserLessonRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserLessonRecord.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserLessonRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserLessonRecordImpl extends UserLessonRecord {
  _UserLessonRecordImpl({
    int? id,
    required int userId,
    required int lessonId,
    bool? isLocked,
    bool? isCompleted,
    int? currentStep,
    String? draftJson,
    int? bestScore,
    int? attempts,
    DateTime? completedAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         lessonId: lessonId,
         isLocked: isLocked,
         isCompleted: isCompleted,
         currentStep: currentStep,
         draftJson: draftJson,
         bestScore: bestScore,
         attempts: attempts,
         completedAt: completedAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [UserLessonRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserLessonRecord copyWith({
    Object? id = _Undefined,
    int? userId,
    int? lessonId,
    bool? isLocked,
    bool? isCompleted,
    int? currentStep,
    Object? draftJson = _Undefined,
    int? bestScore,
    int? attempts,
    Object? completedAt = _Undefined,
    DateTime? updatedAt,
  }) {
    return UserLessonRecord(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      lessonId: lessonId ?? this.lessonId,
      isLocked: isLocked ?? this.isLocked,
      isCompleted: isCompleted ?? this.isCompleted,
      currentStep: currentStep ?? this.currentStep,
      draftJson: draftJson is String? ? draftJson : this.draftJson,
      bestScore: bestScore ?? this.bestScore,
      attempts: attempts ?? this.attempts,
      completedAt: completedAt is DateTime? ? completedAt : this.completedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class UserLessonRecordUpdateTable
    extends _i1.UpdateTable<UserLessonRecordTable> {
  UserLessonRecordUpdateTable(super.table);

  _i1.ColumnValue<int, int> userId(int value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<int, int> lessonId(int value) => _i1.ColumnValue(
    table.lessonId,
    value,
  );

  _i1.ColumnValue<bool, bool> isLocked(bool value) => _i1.ColumnValue(
    table.isLocked,
    value,
  );

  _i1.ColumnValue<bool, bool> isCompleted(bool value) => _i1.ColumnValue(
    table.isCompleted,
    value,
  );

  _i1.ColumnValue<int, int> currentStep(int value) => _i1.ColumnValue(
    table.currentStep,
    value,
  );

  _i1.ColumnValue<String, String> draftJson(String? value) => _i1.ColumnValue(
    table.draftJson,
    value,
  );

  _i1.ColumnValue<int, int> bestScore(int value) => _i1.ColumnValue(
    table.bestScore,
    value,
  );

  _i1.ColumnValue<int, int> attempts(int value) => _i1.ColumnValue(
    table.attempts,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> completedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.completedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class UserLessonRecordTable extends _i1.Table<int?> {
  UserLessonRecordTable({super.tableRelation})
    : super(tableName: 'user_lesson') {
    updateTable = UserLessonRecordUpdateTable(this);
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    lessonId = _i1.ColumnInt(
      'lessonId',
      this,
    );
    isLocked = _i1.ColumnBool(
      'isLocked',
      this,
      hasDefault: true,
    );
    isCompleted = _i1.ColumnBool(
      'isCompleted',
      this,
      hasDefault: true,
    );
    currentStep = _i1.ColumnInt(
      'currentStep',
      this,
      hasDefault: true,
    );
    draftJson = _i1.ColumnString(
      'draftJson',
      this,
    );
    bestScore = _i1.ColumnInt(
      'bestScore',
      this,
      hasDefault: true,
    );
    attempts = _i1.ColumnInt(
      'attempts',
      this,
      hasDefault: true,
    );
    completedAt = _i1.ColumnDateTime(
      'completedAt',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final UserLessonRecordUpdateTable updateTable;

  late final _i1.ColumnInt userId;

  late final _i1.ColumnInt lessonId;

  late final _i1.ColumnBool isLocked;

  late final _i1.ColumnBool isCompleted;

  late final _i1.ColumnInt currentStep;

  late final _i1.ColumnString draftJson;

  late final _i1.ColumnInt bestScore;

  late final _i1.ColumnInt attempts;

  late final _i1.ColumnDateTime completedAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    lessonId,
    isLocked,
    isCompleted,
    currentStep,
    draftJson,
    bestScore,
    attempts,
    completedAt,
    updatedAt,
  ];
}

class UserLessonRecordInclude extends _i1.IncludeObject {
  UserLessonRecordInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => UserLessonRecord.t;
}

class UserLessonRecordIncludeList extends _i1.IncludeList {
  UserLessonRecordIncludeList._({
    _i1.WhereExpressionBuilder<UserLessonRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserLessonRecord.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => UserLessonRecord.t;
}

class UserLessonRecordRepository {
  const UserLessonRecordRepository._();

  /// Returns a list of [UserLessonRecord]s matching the given query parameters.
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
  Future<List<UserLessonRecord>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UserLessonRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserLessonRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserLessonRecordTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UserLessonRecord>(
      where: where?.call(UserLessonRecord.t),
      orderBy: orderBy?.call(UserLessonRecord.t),
      orderByList: orderByList?.call(UserLessonRecord.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UserLessonRecord] matching the given query parameters.
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
  Future<UserLessonRecord?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UserLessonRecordTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserLessonRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserLessonRecordTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UserLessonRecord>(
      where: where?.call(UserLessonRecord.t),
      orderBy: orderBy?.call(UserLessonRecord.t),
      orderByList: orderByList?.call(UserLessonRecord.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UserLessonRecord] by its [id] or null if no such row exists.
  Future<UserLessonRecord?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UserLessonRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UserLessonRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [UserLessonRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<UserLessonRecord>> insert(
    _i1.DatabaseSession session,
    List<UserLessonRecord> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<UserLessonRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [UserLessonRecord] and returns the inserted row.
  ///
  /// The returned [UserLessonRecord] will have its `id` field set.
  Future<UserLessonRecord> insertRow(
    _i1.DatabaseSession session,
    UserLessonRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserLessonRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserLessonRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserLessonRecord>> update(
    _i1.DatabaseSession session,
    List<UserLessonRecord> rows, {
    _i1.ColumnSelections<UserLessonRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserLessonRecord>(
      rows,
      columns: columns?.call(UserLessonRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserLessonRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserLessonRecord> updateRow(
    _i1.DatabaseSession session,
    UserLessonRecord row, {
    _i1.ColumnSelections<UserLessonRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserLessonRecord>(
      row,
      columns: columns?.call(UserLessonRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserLessonRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserLessonRecord?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<UserLessonRecordUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<UserLessonRecord>(
      id,
      columnValues: columnValues(UserLessonRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserLessonRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<UserLessonRecord>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<UserLessonRecordUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<UserLessonRecordTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserLessonRecordTable>? orderBy,
    _i1.OrderByListBuilder<UserLessonRecordTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<UserLessonRecord>(
      columnValues: columnValues(UserLessonRecord.t.updateTable),
      where: where(UserLessonRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserLessonRecord.t),
      orderByList: orderByList?.call(UserLessonRecord.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [UserLessonRecord]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserLessonRecord>> delete(
    _i1.DatabaseSession session,
    List<UserLessonRecord> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserLessonRecord>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserLessonRecord].
  Future<UserLessonRecord> deleteRow(
    _i1.DatabaseSession session,
    UserLessonRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserLessonRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserLessonRecord>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<UserLessonRecordTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserLessonRecord>(
      where: where(UserLessonRecord.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UserLessonRecordTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserLessonRecord>(
      where: where?.call(UserLessonRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UserLessonRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<UserLessonRecordTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UserLessonRecord>(
      where: where(UserLessonRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
