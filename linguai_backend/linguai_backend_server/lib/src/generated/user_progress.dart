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

abstract class UserProgressRecord
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  UserProgressRecord._({
    this.id,
    required this.userId,
    int? totalXp,
    int? level,
    int? currentStreak,
    this.lastActivityDate,
    int? streakFreezes,
    int? gemsCount,
    int? longestStreak,
    this.activeRoute,
    this.activeStateJson,
    required this.updatedAt,
  }) : totalXp = totalXp ?? 0,
       level = level ?? 1,
       currentStreak = currentStreak ?? 0,
       streakFreezes = streakFreezes ?? 0,
       gemsCount = gemsCount ?? 100,
       longestStreak = longestStreak ?? 0;

  factory UserProgressRecord({
    int? id,
    required int userId,
    int? totalXp,
    int? level,
    int? currentStreak,
    DateTime? lastActivityDate,
    int? streakFreezes,
    int? gemsCount,
    int? longestStreak,
    String? activeRoute,
    String? activeStateJson,
    required DateTime updatedAt,
  }) = _UserProgressRecordImpl;

  factory UserProgressRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserProgressRecord(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      totalXp: jsonSerialization['totalXp'] as int?,
      level: jsonSerialization['level'] as int?,
      currentStreak: jsonSerialization['currentStreak'] as int?,
      lastActivityDate: jsonSerialization['lastActivityDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastActivityDate'],
            ),
      streakFreezes: jsonSerialization['streakFreezes'] as int?,
      gemsCount: jsonSerialization['gemsCount'] as int?,
      longestStreak: jsonSerialization['longestStreak'] as int?,
      activeRoute: jsonSerialization['activeRoute'] as String?,
      activeStateJson: jsonSerialization['activeStateJson'] as String?,
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = UserProgressRecordTable();

  static const db = UserProgressRecordRepository._();

  @override
  int? id;

  int userId;

  int totalXp;

  int level;

  int currentStreak;

  DateTime? lastActivityDate;

  int streakFreezes;

  int gemsCount;

  int longestStreak;

  String? activeRoute;

  String? activeStateJson;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [UserProgressRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserProgressRecord copyWith({
    int? id,
    int? userId,
    int? totalXp,
    int? level,
    int? currentStreak,
    DateTime? lastActivityDate,
    int? streakFreezes,
    int? gemsCount,
    int? longestStreak,
    String? activeRoute,
    String? activeStateJson,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserProgressRecord',
      if (id != null) 'id': id,
      'userId': userId,
      'totalXp': totalXp,
      'level': level,
      'currentStreak': currentStreak,
      if (lastActivityDate != null)
        'lastActivityDate': lastActivityDate?.toJson(),
      'streakFreezes': streakFreezes,
      'gemsCount': gemsCount,
      'longestStreak': longestStreak,
      if (activeRoute != null) 'activeRoute': activeRoute,
      if (activeStateJson != null) 'activeStateJson': activeStateJson,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserProgressRecord',
      if (id != null) 'id': id,
      'userId': userId,
      'totalXp': totalXp,
      'level': level,
      'currentStreak': currentStreak,
      if (lastActivityDate != null)
        'lastActivityDate': lastActivityDate?.toJson(),
      'streakFreezes': streakFreezes,
      'gemsCount': gemsCount,
      'longestStreak': longestStreak,
      if (activeRoute != null) 'activeRoute': activeRoute,
      if (activeStateJson != null) 'activeStateJson': activeStateJson,
      'updatedAt': updatedAt.toJson(),
    };
  }

  static UserProgressRecordInclude include() {
    return UserProgressRecordInclude._();
  }

  static UserProgressRecordIncludeList includeList({
    _i1.WhereExpressionBuilder<UserProgressRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserProgressRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserProgressRecordTable>? orderByList,
    UserProgressRecordInclude? include,
  }) {
    return UserProgressRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserProgressRecord.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserProgressRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserProgressRecordImpl extends UserProgressRecord {
  _UserProgressRecordImpl({
    int? id,
    required int userId,
    int? totalXp,
    int? level,
    int? currentStreak,
    DateTime? lastActivityDate,
    int? streakFreezes,
    int? gemsCount,
    int? longestStreak,
    String? activeRoute,
    String? activeStateJson,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         totalXp: totalXp,
         level: level,
         currentStreak: currentStreak,
         lastActivityDate: lastActivityDate,
         streakFreezes: streakFreezes,
         gemsCount: gemsCount,
         longestStreak: longestStreak,
         activeRoute: activeRoute,
         activeStateJson: activeStateJson,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [UserProgressRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserProgressRecord copyWith({
    Object? id = _Undefined,
    int? userId,
    int? totalXp,
    int? level,
    int? currentStreak,
    Object? lastActivityDate = _Undefined,
    int? streakFreezes,
    int? gemsCount,
    int? longestStreak,
    Object? activeRoute = _Undefined,
    Object? activeStateJson = _Undefined,
    DateTime? updatedAt,
  }) {
    return UserProgressRecord(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      totalXp: totalXp ?? this.totalXp,
      level: level ?? this.level,
      currentStreak: currentStreak ?? this.currentStreak,
      lastActivityDate: lastActivityDate is DateTime?
          ? lastActivityDate
          : this.lastActivityDate,
      streakFreezes: streakFreezes ?? this.streakFreezes,
      gemsCount: gemsCount ?? this.gemsCount,
      longestStreak: longestStreak ?? this.longestStreak,
      activeRoute: activeRoute is String? ? activeRoute : this.activeRoute,
      activeStateJson: activeStateJson is String?
          ? activeStateJson
          : this.activeStateJson,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class UserProgressRecordUpdateTable
    extends _i1.UpdateTable<UserProgressRecordTable> {
  UserProgressRecordUpdateTable(super.table);

  _i1.ColumnValue<int, int> userId(int value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<int, int> totalXp(int value) => _i1.ColumnValue(
    table.totalXp,
    value,
  );

  _i1.ColumnValue<int, int> level(int value) => _i1.ColumnValue(
    table.level,
    value,
  );

  _i1.ColumnValue<int, int> currentStreak(int value) => _i1.ColumnValue(
    table.currentStreak,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> lastActivityDate(DateTime? value) =>
      _i1.ColumnValue(
        table.lastActivityDate,
        value,
      );

  _i1.ColumnValue<int, int> streakFreezes(int value) => _i1.ColumnValue(
    table.streakFreezes,
    value,
  );

  _i1.ColumnValue<int, int> gemsCount(int value) => _i1.ColumnValue(
    table.gemsCount,
    value,
  );

  _i1.ColumnValue<int, int> longestStreak(int value) => _i1.ColumnValue(
    table.longestStreak,
    value,
  );

  _i1.ColumnValue<String, String> activeRoute(String? value) => _i1.ColumnValue(
    table.activeRoute,
    value,
  );

  _i1.ColumnValue<String, String> activeStateJson(String? value) =>
      _i1.ColumnValue(
        table.activeStateJson,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class UserProgressRecordTable extends _i1.Table<int?> {
  UserProgressRecordTable({super.tableRelation})
    : super(tableName: 'user_progress') {
    updateTable = UserProgressRecordUpdateTable(this);
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    totalXp = _i1.ColumnInt(
      'totalXp',
      this,
      hasDefault: true,
    );
    level = _i1.ColumnInt(
      'level',
      this,
      hasDefault: true,
    );
    currentStreak = _i1.ColumnInt(
      'currentStreak',
      this,
      hasDefault: true,
    );
    lastActivityDate = _i1.ColumnDateTime(
      'lastActivityDate',
      this,
    );
    streakFreezes = _i1.ColumnInt(
      'streakFreezes',
      this,
      hasDefault: true,
    );
    gemsCount = _i1.ColumnInt(
      'gemsCount',
      this,
      hasDefault: true,
    );
    longestStreak = _i1.ColumnInt(
      'longestStreak',
      this,
      hasDefault: true,
    );
    activeRoute = _i1.ColumnString(
      'activeRoute',
      this,
    );
    activeStateJson = _i1.ColumnString(
      'activeStateJson',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final UserProgressRecordUpdateTable updateTable;

  late final _i1.ColumnInt userId;

  late final _i1.ColumnInt totalXp;

  late final _i1.ColumnInt level;

  late final _i1.ColumnInt currentStreak;

  late final _i1.ColumnDateTime lastActivityDate;

  late final _i1.ColumnInt streakFreezes;

  late final _i1.ColumnInt gemsCount;

  late final _i1.ColumnInt longestStreak;

  late final _i1.ColumnString activeRoute;

  late final _i1.ColumnString activeStateJson;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    totalXp,
    level,
    currentStreak,
    lastActivityDate,
    streakFreezes,
    gemsCount,
    longestStreak,
    activeRoute,
    activeStateJson,
    updatedAt,
  ];
}

class UserProgressRecordInclude extends _i1.IncludeObject {
  UserProgressRecordInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => UserProgressRecord.t;
}

class UserProgressRecordIncludeList extends _i1.IncludeList {
  UserProgressRecordIncludeList._({
    _i1.WhereExpressionBuilder<UserProgressRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserProgressRecord.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => UserProgressRecord.t;
}

class UserProgressRecordRepository {
  const UserProgressRecordRepository._();

  /// Returns a list of [UserProgressRecord]s matching the given query parameters.
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
  Future<List<UserProgressRecord>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UserProgressRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserProgressRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserProgressRecordTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UserProgressRecord>(
      where: where?.call(UserProgressRecord.t),
      orderBy: orderBy?.call(UserProgressRecord.t),
      orderByList: orderByList?.call(UserProgressRecord.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UserProgressRecord] matching the given query parameters.
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
  Future<UserProgressRecord?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UserProgressRecordTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserProgressRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserProgressRecordTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UserProgressRecord>(
      where: where?.call(UserProgressRecord.t),
      orderBy: orderBy?.call(UserProgressRecord.t),
      orderByList: orderByList?.call(UserProgressRecord.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UserProgressRecord] by its [id] or null if no such row exists.
  Future<UserProgressRecord?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UserProgressRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UserProgressRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [UserProgressRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<UserProgressRecord>> insert(
    _i1.DatabaseSession session,
    List<UserProgressRecord> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<UserProgressRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [UserProgressRecord] and returns the inserted row.
  ///
  /// The returned [UserProgressRecord] will have its `id` field set.
  Future<UserProgressRecord> insertRow(
    _i1.DatabaseSession session,
    UserProgressRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserProgressRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserProgressRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserProgressRecord>> update(
    _i1.DatabaseSession session,
    List<UserProgressRecord> rows, {
    _i1.ColumnSelections<UserProgressRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserProgressRecord>(
      rows,
      columns: columns?.call(UserProgressRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserProgressRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserProgressRecord> updateRow(
    _i1.DatabaseSession session,
    UserProgressRecord row, {
    _i1.ColumnSelections<UserProgressRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserProgressRecord>(
      row,
      columns: columns?.call(UserProgressRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserProgressRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserProgressRecord?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<UserProgressRecordUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<UserProgressRecord>(
      id,
      columnValues: columnValues(UserProgressRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserProgressRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<UserProgressRecord>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<UserProgressRecordUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<UserProgressRecordTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserProgressRecordTable>? orderBy,
    _i1.OrderByListBuilder<UserProgressRecordTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<UserProgressRecord>(
      columnValues: columnValues(UserProgressRecord.t.updateTable),
      where: where(UserProgressRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserProgressRecord.t),
      orderByList: orderByList?.call(UserProgressRecord.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [UserProgressRecord]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserProgressRecord>> delete(
    _i1.DatabaseSession session,
    List<UserProgressRecord> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserProgressRecord>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserProgressRecord].
  Future<UserProgressRecord> deleteRow(
    _i1.DatabaseSession session,
    UserProgressRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserProgressRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserProgressRecord>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<UserProgressRecordTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserProgressRecord>(
      where: where(UserProgressRecord.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UserProgressRecordTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserProgressRecord>(
      where: where?.call(UserProgressRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UserProgressRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<UserProgressRecordTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UserProgressRecord>(
      where: where(UserProgressRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
