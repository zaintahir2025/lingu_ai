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

abstract class AppUser
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AppUser._({
    this.id,
    required this.email,
    required this.passwordHash,
    bool? isEmailVerified,
    bool? isDisabled,
    this.dateOfBirth,
    String? role,
    String? targetLanguage,
    this.username,
    this.avatarId,
    this.knowledgeLevel,
    this.fluencyScore,
    required this.createdAt,
    required this.updatedAt,
  }) : isEmailVerified = isEmailVerified ?? false,
       isDisabled = isDisabled ?? false,
       role = role ?? 'user',
       targetLanguage = targetLanguage ?? 'es';

  factory AppUser({
    int? id,
    required String email,
    required String passwordHash,
    bool? isEmailVerified,
    bool? isDisabled,
    DateTime? dateOfBirth,
    String? role,
    String? targetLanguage,
    String? username,
    String? avatarId,
    String? knowledgeLevel,
    int? fluencyScore,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AppUserImpl;

  factory AppUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppUser(
      id: jsonSerialization['id'] as int?,
      email: jsonSerialization['email'] as String,
      passwordHash: jsonSerialization['passwordHash'] as String,
      isEmailVerified: jsonSerialization['isEmailVerified'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['isEmailVerified'],
            ),
      isDisabled: jsonSerialization['isDisabled'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isDisabled']),
      dateOfBirth: jsonSerialization['dateOfBirth'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['dateOfBirth'],
            ),
      role: jsonSerialization['role'] as String?,
      targetLanguage: jsonSerialization['targetLanguage'] as String?,
      username: jsonSerialization['username'] as String?,
      avatarId: jsonSerialization['avatarId'] as String?,
      knowledgeLevel: jsonSerialization['knowledgeLevel'] as String?,
      fluencyScore: jsonSerialization['fluencyScore'] as int?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = AppUserTable();

  static const db = AppUserRepository._();

  @override
  int? id;

  String email;

  String passwordHash;

  bool isEmailVerified;

  bool isDisabled;

  DateTime? dateOfBirth;

  String role;

  String targetLanguage;

  String? username;

  String? avatarId;

  String? knowledgeLevel;

  int? fluencyScore;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AppUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AppUser copyWith({
    int? id,
    String? email,
    String? passwordHash,
    bool? isEmailVerified,
    bool? isDisabled,
    DateTime? dateOfBirth,
    String? role,
    String? targetLanguage,
    String? username,
    String? avatarId,
    String? knowledgeLevel,
    int? fluencyScore,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppUser',
      if (id != null) 'id': id,
      'email': email,
      'passwordHash': passwordHash,
      'isEmailVerified': isEmailVerified,
      'isDisabled': isDisabled,
      if (dateOfBirth != null) 'dateOfBirth': dateOfBirth?.toJson(),
      'role': role,
      'targetLanguage': targetLanguage,
      if (username != null) 'username': username,
      if (avatarId != null) 'avatarId': avatarId,
      if (knowledgeLevel != null) 'knowledgeLevel': knowledgeLevel,
      if (fluencyScore != null) 'fluencyScore': fluencyScore,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AppUser',
      if (id != null) 'id': id,
      'email': email,
      'passwordHash': passwordHash,
      'isEmailVerified': isEmailVerified,
      'isDisabled': isDisabled,
      if (dateOfBirth != null) 'dateOfBirth': dateOfBirth?.toJson(),
      'role': role,
      'targetLanguage': targetLanguage,
      if (username != null) 'username': username,
      if (avatarId != null) 'avatarId': avatarId,
      if (knowledgeLevel != null) 'knowledgeLevel': knowledgeLevel,
      if (fluencyScore != null) 'fluencyScore': fluencyScore,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static AppUserInclude include() {
    return AppUserInclude._();
  }

  static AppUserIncludeList includeList({
    _i1.WhereExpressionBuilder<AppUserTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppUserTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppUserTable>? orderByList,
    AppUserInclude? include,
  }) {
    return AppUserIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AppUser.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AppUser.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppUserImpl extends AppUser {
  _AppUserImpl({
    int? id,
    required String email,
    required String passwordHash,
    bool? isEmailVerified,
    bool? isDisabled,
    DateTime? dateOfBirth,
    String? role,
    String? targetLanguage,
    String? username,
    String? avatarId,
    String? knowledgeLevel,
    int? fluencyScore,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         email: email,
         passwordHash: passwordHash,
         isEmailVerified: isEmailVerified,
         isDisabled: isDisabled,
         dateOfBirth: dateOfBirth,
         role: role,
         targetLanguage: targetLanguage,
         username: username,
         avatarId: avatarId,
         knowledgeLevel: knowledgeLevel,
         fluencyScore: fluencyScore,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [AppUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AppUser copyWith({
    Object? id = _Undefined,
    String? email,
    String? passwordHash,
    bool? isEmailVerified,
    bool? isDisabled,
    Object? dateOfBirth = _Undefined,
    String? role,
    String? targetLanguage,
    Object? username = _Undefined,
    Object? avatarId = _Undefined,
    Object? knowledgeLevel = _Undefined,
    Object? fluencyScore = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppUser(
      id: id is int? ? id : this.id,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isDisabled: isDisabled ?? this.isDisabled,
      dateOfBirth: dateOfBirth is DateTime? ? dateOfBirth : this.dateOfBirth,
      role: role ?? this.role,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      username: username is String? ? username : this.username,
      avatarId: avatarId is String? ? avatarId : this.avatarId,
      knowledgeLevel: knowledgeLevel is String?
          ? knowledgeLevel
          : this.knowledgeLevel,
      fluencyScore: fluencyScore is int? ? fluencyScore : this.fluencyScore,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class AppUserUpdateTable extends _i1.UpdateTable<AppUserTable> {
  AppUserUpdateTable(super.table);

  _i1.ColumnValue<String, String> email(String value) => _i1.ColumnValue(
    table.email,
    value,
  );

  _i1.ColumnValue<String, String> passwordHash(String value) => _i1.ColumnValue(
    table.passwordHash,
    value,
  );

  _i1.ColumnValue<bool, bool> isEmailVerified(bool value) => _i1.ColumnValue(
    table.isEmailVerified,
    value,
  );

  _i1.ColumnValue<bool, bool> isDisabled(bool value) => _i1.ColumnValue(
    table.isDisabled,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> dateOfBirth(DateTime? value) =>
      _i1.ColumnValue(
        table.dateOfBirth,
        value,
      );

  _i1.ColumnValue<String, String> role(String value) => _i1.ColumnValue(
    table.role,
    value,
  );

  _i1.ColumnValue<String, String> targetLanguage(String value) =>
      _i1.ColumnValue(
        table.targetLanguage,
        value,
      );

  _i1.ColumnValue<String, String> username(String? value) => _i1.ColumnValue(
    table.username,
    value,
  );

  _i1.ColumnValue<String, String> avatarId(String? value) => _i1.ColumnValue(
    table.avatarId,
    value,
  );

  _i1.ColumnValue<String, String> knowledgeLevel(String? value) =>
      _i1.ColumnValue(
        table.knowledgeLevel,
        value,
      );

  _i1.ColumnValue<int, int> fluencyScore(int? value) => _i1.ColumnValue(
    table.fluencyScore,
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

class AppUserTable extends _i1.Table<int?> {
  AppUserTable({super.tableRelation}) : super(tableName: 'app_user') {
    updateTable = AppUserUpdateTable(this);
    email = _i1.ColumnString(
      'email',
      this,
    );
    passwordHash = _i1.ColumnString(
      'passwordHash',
      this,
    );
    isEmailVerified = _i1.ColumnBool(
      'isEmailVerified',
      this,
      hasDefault: true,
    );
    isDisabled = _i1.ColumnBool(
      'isDisabled',
      this,
      hasDefault: true,
    );
    dateOfBirth = _i1.ColumnDateTime(
      'dateOfBirth',
      this,
    );
    role = _i1.ColumnString(
      'role',
      this,
      hasDefault: true,
    );
    targetLanguage = _i1.ColumnString(
      'targetLanguage',
      this,
      hasDefault: true,
    );
    username = _i1.ColumnString(
      'username',
      this,
    );
    avatarId = _i1.ColumnString(
      'avatarId',
      this,
    );
    knowledgeLevel = _i1.ColumnString(
      'knowledgeLevel',
      this,
    );
    fluencyScore = _i1.ColumnInt(
      'fluencyScore',
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

  late final AppUserUpdateTable updateTable;

  late final _i1.ColumnString email;

  late final _i1.ColumnString passwordHash;

  late final _i1.ColumnBool isEmailVerified;

  late final _i1.ColumnBool isDisabled;

  late final _i1.ColumnDateTime dateOfBirth;

  late final _i1.ColumnString role;

  late final _i1.ColumnString targetLanguage;

  late final _i1.ColumnString username;

  late final _i1.ColumnString avatarId;

  late final _i1.ColumnString knowledgeLevel;

  late final _i1.ColumnInt fluencyScore;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    email,
    passwordHash,
    isEmailVerified,
    isDisabled,
    dateOfBirth,
    role,
    targetLanguage,
    username,
    avatarId,
    knowledgeLevel,
    fluencyScore,
    createdAt,
    updatedAt,
  ];
}

class AppUserInclude extends _i1.IncludeObject {
  AppUserInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AppUser.t;
}

class AppUserIncludeList extends _i1.IncludeList {
  AppUserIncludeList._({
    _i1.WhereExpressionBuilder<AppUserTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AppUser.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AppUser.t;
}

class AppUserRepository {
  const AppUserRepository._();

  /// Returns a list of [AppUser]s matching the given query parameters.
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
  Future<List<AppUser>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AppUserTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppUserTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppUserTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AppUser>(
      where: where?.call(AppUser.t),
      orderBy: orderBy?.call(AppUser.t),
      orderByList: orderByList?.call(AppUser.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AppUser] matching the given query parameters.
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
  Future<AppUser?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AppUserTable>? where,
    int? offset,
    _i1.OrderByBuilder<AppUserTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppUserTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AppUser>(
      where: where?.call(AppUser.t),
      orderBy: orderBy?.call(AppUser.t),
      orderByList: orderByList?.call(AppUser.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AppUser] by its [id] or null if no such row exists.
  Future<AppUser?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AppUser>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AppUser]s in the list and returns the inserted rows.
  ///
  /// The returned [AppUser]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<AppUser>> insert(
    _i1.DatabaseSession session,
    List<AppUser> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<AppUser>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [AppUser] and returns the inserted row.
  ///
  /// The returned [AppUser] will have its `id` field set.
  Future<AppUser> insertRow(
    _i1.DatabaseSession session,
    AppUser row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AppUser>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AppUser]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AppUser>> update(
    _i1.DatabaseSession session,
    List<AppUser> rows, {
    _i1.ColumnSelections<AppUserTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AppUser>(
      rows,
      columns: columns?.call(AppUser.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AppUser]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AppUser> updateRow(
    _i1.DatabaseSession session,
    AppUser row, {
    _i1.ColumnSelections<AppUserTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AppUser>(
      row,
      columns: columns?.call(AppUser.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AppUser] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AppUser?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<AppUserUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AppUser>(
      id,
      columnValues: columnValues(AppUser.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AppUser]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AppUser>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<AppUserUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<AppUserTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppUserTable>? orderBy,
    _i1.OrderByListBuilder<AppUserTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AppUser>(
      columnValues: columnValues(AppUser.t.updateTable),
      where: where(AppUser.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AppUser.t),
      orderByList: orderByList?.call(AppUser.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AppUser]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AppUser>> delete(
    _i1.DatabaseSession session,
    List<AppUser> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AppUser>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AppUser].
  Future<AppUser> deleteRow(
    _i1.DatabaseSession session,
    AppUser row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AppUser>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AppUser>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AppUserTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AppUser>(
      where: where(AppUser.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AppUserTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AppUser>(
      where: where?.call(AppUser.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AppUser] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AppUserTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AppUser>(
      where: where(AppUser.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
