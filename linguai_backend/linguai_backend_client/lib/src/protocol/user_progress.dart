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
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class UserProgressRecord implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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
