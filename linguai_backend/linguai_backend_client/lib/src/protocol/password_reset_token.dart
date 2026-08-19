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

abstract class PasswordResetTokenRecord implements _i1.SerializableModel {
  PasswordResetTokenRecord._({
    this.id,
    required this.email,
    required this.tokenHash,
    required this.expiresAt,
    required this.createdAt,
  });

  factory PasswordResetTokenRecord({
    int? id,
    required String email,
    required String tokenHash,
    required DateTime expiresAt,
    required DateTime createdAt,
  }) = _PasswordResetTokenRecordImpl;

  factory PasswordResetTokenRecord.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return PasswordResetTokenRecord(
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String email;

  String tokenHash;

  DateTime expiresAt;

  DateTime createdAt;

  /// Returns a shallow copy of this [PasswordResetTokenRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PasswordResetTokenRecord copyWith({
    int? id,
    String? email,
    String? tokenHash,
    DateTime? expiresAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PasswordResetTokenRecord',
      if (id != null) 'id': id,
      'email': email,
      'tokenHash': tokenHash,
      'expiresAt': expiresAt.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PasswordResetTokenRecordImpl extends PasswordResetTokenRecord {
  _PasswordResetTokenRecordImpl({
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

  /// Returns a shallow copy of this [PasswordResetTokenRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PasswordResetTokenRecord copyWith({
    Object? id = _Undefined,
    String? email,
    String? tokenHash,
    DateTime? expiresAt,
    DateTime? createdAt,
  }) {
    return PasswordResetTokenRecord(
      id: id is int? ? id : this.id,
      email: email ?? this.email,
      tokenHash: tokenHash ?? this.tokenHash,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
