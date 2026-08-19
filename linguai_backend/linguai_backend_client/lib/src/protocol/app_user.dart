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

abstract class AppUser implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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
