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

abstract class SubscriptionRecord implements _i1.SerializableModel {
  SubscriptionRecord._({
    this.id,
    required this.userId,
    required this.provider,
    required this.externalId,
    this.customerId,
    required this.status,
    required this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubscriptionRecord({
    int? id,
    required int userId,
    required String provider,
    required String externalId,
    String? customerId,
    required String status,
    required DateTime expiresAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _SubscriptionRecordImpl;

  factory SubscriptionRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return SubscriptionRecord(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      provider: jsonSerialization['provider'] as String,
      externalId: jsonSerialization['externalId'] as String,
      customerId: jsonSerialization['customerId'] as String?,
      status: jsonSerialization['status'] as String,
      expiresAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
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

  int userId;

  String provider;

  String externalId;

  String? customerId;

  String status;

  DateTime expiresAt;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [SubscriptionRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SubscriptionRecord copyWith({
    int? id,
    int? userId,
    String? provider,
    String? externalId,
    String? customerId,
    String? status,
    DateTime? expiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SubscriptionRecord',
      if (id != null) 'id': id,
      'userId': userId,
      'provider': provider,
      'externalId': externalId,
      if (customerId != null) 'customerId': customerId,
      'status': status,
      'expiresAt': expiresAt.toJson(),
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

class _SubscriptionRecordImpl extends SubscriptionRecord {
  _SubscriptionRecordImpl({
    int? id,
    required int userId,
    required String provider,
    required String externalId,
    String? customerId,
    required String status,
    required DateTime expiresAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         provider: provider,
         externalId: externalId,
         customerId: customerId,
         status: status,
         expiresAt: expiresAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [SubscriptionRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SubscriptionRecord copyWith({
    Object? id = _Undefined,
    int? userId,
    String? provider,
    String? externalId,
    Object? customerId = _Undefined,
    String? status,
    DateTime? expiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubscriptionRecord(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      provider: provider ?? this.provider,
      externalId: externalId ?? this.externalId,
      customerId: customerId is String? ? customerId : this.customerId,
      status: status ?? this.status,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
