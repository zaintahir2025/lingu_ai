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

abstract class RefreshTokenRecord implements _i1.SerializableModel {
  RefreshTokenRecord._({
    this.id,
    required this.tokenHash,
    required this.userId,
    this.device,
    required this.expiresAt,
    required this.createdAt,
  });

  factory RefreshTokenRecord({
    int? id,
    required String tokenHash,
    required int userId,
    String? device,
    required DateTime expiresAt,
    required DateTime createdAt,
  }) = _RefreshTokenRecordImpl;

  factory RefreshTokenRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return RefreshTokenRecord(
      id: jsonSerialization['id'] as int?,
      tokenHash: jsonSerialization['tokenHash'] as String,
      userId: jsonSerialization['userId'] as int,
      device: jsonSerialization['device'] as String?,
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

  String tokenHash;

  int userId;

  String? device;

  DateTime expiresAt;

  DateTime createdAt;

  /// Returns a shallow copy of this [RefreshTokenRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RefreshTokenRecord copyWith({
    int? id,
    String? tokenHash,
    int? userId,
    String? device,
    DateTime? expiresAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RefreshTokenRecord',
      if (id != null) 'id': id,
      'tokenHash': tokenHash,
      'userId': userId,
      if (device != null) 'device': device,
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

class _RefreshTokenRecordImpl extends RefreshTokenRecord {
  _RefreshTokenRecordImpl({
    int? id,
    required String tokenHash,
    required int userId,
    String? device,
    required DateTime expiresAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         tokenHash: tokenHash,
         userId: userId,
         device: device,
         expiresAt: expiresAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [RefreshTokenRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RefreshTokenRecord copyWith({
    Object? id = _Undefined,
    String? tokenHash,
    int? userId,
    Object? device = _Undefined,
    DateTime? expiresAt,
    DateTime? createdAt,
  }) {
    return RefreshTokenRecord(
      id: id is int? ? id : this.id,
      tokenHash: tokenHash ?? this.tokenHash,
      userId: userId ?? this.userId,
      device: device is String? ? device : this.device,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
