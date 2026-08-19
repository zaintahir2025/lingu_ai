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
import 'admin_audit_log.dart' as _i2;
import 'ai_usage.dart' as _i3;
import 'app_user.dart' as _i4;
import 'daily_xp.dart' as _i5;
import 'lesson.dart' as _i6;
import 'password_reset_token.dart' as _i7;
import 'refresh_token.dart' as _i8;
import 'subscription.dart' as _i9;
import 'support_ticket.dart' as _i10;
import 'user_lesson.dart' as _i11;
import 'user_progress.dart' as _i12;
import 'user_vocab.dart' as _i13;
import 'verification_token.dart' as _i14;
import 'vocab_word.dart' as _i15;
export 'admin_audit_log.dart';
export 'ai_usage.dart';
export 'app_user.dart';
export 'daily_xp.dart';
export 'lesson.dart';
export 'password_reset_token.dart';
export 'refresh_token.dart';
export 'subscription.dart';
export 'support_ticket.dart';
export 'user_lesson.dart';
export 'user_progress.dart';
export 'user_vocab.dart';
export 'verification_token.dart';
export 'vocab_word.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.AdminAuditLogRecord) {
      return _i2.AdminAuditLogRecord.fromJson(data) as T;
    }
    if (t == _i3.AiUsageRecord) {
      return _i3.AiUsageRecord.fromJson(data) as T;
    }
    if (t == _i4.AppUser) {
      return _i4.AppUser.fromJson(data) as T;
    }
    if (t == _i5.DailyXpRecord) {
      return _i5.DailyXpRecord.fromJson(data) as T;
    }
    if (t == _i6.LessonRecord) {
      return _i6.LessonRecord.fromJson(data) as T;
    }
    if (t == _i7.PasswordResetTokenRecord) {
      return _i7.PasswordResetTokenRecord.fromJson(data) as T;
    }
    if (t == _i8.RefreshTokenRecord) {
      return _i8.RefreshTokenRecord.fromJson(data) as T;
    }
    if (t == _i9.SubscriptionRecord) {
      return _i9.SubscriptionRecord.fromJson(data) as T;
    }
    if (t == _i10.SupportTicketRecord) {
      return _i10.SupportTicketRecord.fromJson(data) as T;
    }
    if (t == _i11.UserLessonRecord) {
      return _i11.UserLessonRecord.fromJson(data) as T;
    }
    if (t == _i12.UserProgressRecord) {
      return _i12.UserProgressRecord.fromJson(data) as T;
    }
    if (t == _i13.UserVocabRecord) {
      return _i13.UserVocabRecord.fromJson(data) as T;
    }
    if (t == _i14.VerificationTokenRecord) {
      return _i14.VerificationTokenRecord.fromJson(data) as T;
    }
    if (t == _i15.VocabWordRecord) {
      return _i15.VocabWordRecord.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.AdminAuditLogRecord?>()) {
      return (data != null ? _i2.AdminAuditLogRecord.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i3.AiUsageRecord?>()) {
      return (data != null ? _i3.AiUsageRecord.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.AppUser?>()) {
      return (data != null ? _i4.AppUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.DailyXpRecord?>()) {
      return (data != null ? _i5.DailyXpRecord.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.LessonRecord?>()) {
      return (data != null ? _i6.LessonRecord.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.PasswordResetTokenRecord?>()) {
      return (data != null ? _i7.PasswordResetTokenRecord.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i8.RefreshTokenRecord?>()) {
      return (data != null ? _i8.RefreshTokenRecord.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.SubscriptionRecord?>()) {
      return (data != null ? _i9.SubscriptionRecord.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.SupportTicketRecord?>()) {
      return (data != null ? _i10.SupportTicketRecord.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i11.UserLessonRecord?>()) {
      return (data != null ? _i11.UserLessonRecord.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.UserProgressRecord?>()) {
      return (data != null ? _i12.UserProgressRecord.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i13.UserVocabRecord?>()) {
      return (data != null ? _i13.UserVocabRecord.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.VerificationTokenRecord?>()) {
      return (data != null ? _i14.VerificationTokenRecord.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i15.VocabWordRecord?>()) {
      return (data != null ? _i15.VocabWordRecord.fromJson(data) : null) as T;
    }
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.AdminAuditLogRecord => 'AdminAuditLogRecord',
      _i3.AiUsageRecord => 'AiUsageRecord',
      _i4.AppUser => 'AppUser',
      _i5.DailyXpRecord => 'DailyXpRecord',
      _i6.LessonRecord => 'LessonRecord',
      _i7.PasswordResetTokenRecord => 'PasswordResetTokenRecord',
      _i8.RefreshTokenRecord => 'RefreshTokenRecord',
      _i9.SubscriptionRecord => 'SubscriptionRecord',
      _i10.SupportTicketRecord => 'SupportTicketRecord',
      _i11.UserLessonRecord => 'UserLessonRecord',
      _i12.UserProgressRecord => 'UserProgressRecord',
      _i13.UserVocabRecord => 'UserVocabRecord',
      _i14.VerificationTokenRecord => 'VerificationTokenRecord',
      _i15.VocabWordRecord => 'VocabWordRecord',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'linguai_backend.',
        '',
      );
    }

    switch (data) {
      case _i2.AdminAuditLogRecord():
        return 'AdminAuditLogRecord';
      case _i3.AiUsageRecord():
        return 'AiUsageRecord';
      case _i4.AppUser():
        return 'AppUser';
      case _i5.DailyXpRecord():
        return 'DailyXpRecord';
      case _i6.LessonRecord():
        return 'LessonRecord';
      case _i7.PasswordResetTokenRecord():
        return 'PasswordResetTokenRecord';
      case _i8.RefreshTokenRecord():
        return 'RefreshTokenRecord';
      case _i9.SubscriptionRecord():
        return 'SubscriptionRecord';
      case _i10.SupportTicketRecord():
        return 'SupportTicketRecord';
      case _i11.UserLessonRecord():
        return 'UserLessonRecord';
      case _i12.UserProgressRecord():
        return 'UserProgressRecord';
      case _i13.UserVocabRecord():
        return 'UserVocabRecord';
      case _i14.VerificationTokenRecord():
        return 'VerificationTokenRecord';
      case _i15.VocabWordRecord():
        return 'VocabWordRecord';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AdminAuditLogRecord') {
      return deserialize<_i2.AdminAuditLogRecord>(data['data']);
    }
    if (dataClassName == 'AiUsageRecord') {
      return deserialize<_i3.AiUsageRecord>(data['data']);
    }
    if (dataClassName == 'AppUser') {
      return deserialize<_i4.AppUser>(data['data']);
    }
    if (dataClassName == 'DailyXpRecord') {
      return deserialize<_i5.DailyXpRecord>(data['data']);
    }
    if (dataClassName == 'LessonRecord') {
      return deserialize<_i6.LessonRecord>(data['data']);
    }
    if (dataClassName == 'PasswordResetTokenRecord') {
      return deserialize<_i7.PasswordResetTokenRecord>(data['data']);
    }
    if (dataClassName == 'RefreshTokenRecord') {
      return deserialize<_i8.RefreshTokenRecord>(data['data']);
    }
    if (dataClassName == 'SubscriptionRecord') {
      return deserialize<_i9.SubscriptionRecord>(data['data']);
    }
    if (dataClassName == 'SupportTicketRecord') {
      return deserialize<_i10.SupportTicketRecord>(data['data']);
    }
    if (dataClassName == 'UserLessonRecord') {
      return deserialize<_i11.UserLessonRecord>(data['data']);
    }
    if (dataClassName == 'UserProgressRecord') {
      return deserialize<_i12.UserProgressRecord>(data['data']);
    }
    if (dataClassName == 'UserVocabRecord') {
      return deserialize<_i13.UserVocabRecord>(data['data']);
    }
    if (dataClassName == 'VerificationTokenRecord') {
      return deserialize<_i14.VerificationTokenRecord>(data['data']);
    }
    if (dataClassName == 'VocabWordRecord') {
      return deserialize<_i15.VocabWordRecord>(data['data']);
    }
    return super.deserializeByClassName(data);
  }

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
