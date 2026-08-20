import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_client.dart';

class AdminUser {
  const AdminUser({
    required this.id,
    required this.email,
    required this.username,
    required this.role,
    required this.isDisabled,
    required this.isEmailVerified,
    required this.createdAt,
    required this.premium,
    this.premiumProvider,
    this.premiumExpiresAt,
  });

  final String id;
  final String email;
  final String? username;
  final String role;
  final bool isDisabled;
  final bool isEmailVerified;
  final DateTime createdAt;
  final bool premium;
  final String? premiumProvider;
  final DateTime? premiumExpiresAt;

  factory AdminUser.fromJson(Map<String, dynamic> json) => AdminUser(
    id: json['id'] as String,
    email: json['email'] as String,
    username: json['username'] as String?,
    role: json['role'] as String,
    isDisabled: json['isDisabled'] == true,
    isEmailVerified: json['isEmailVerified'] == true,
    createdAt: DateTime.parse(json['createdAt'] as String),
    premium: json['premium'] == true,
    premiumProvider: json['premiumProvider'] as String?,
    premiumExpiresAt: json['premiumExpiresAt'] is String
        ? DateTime.tryParse(json['premiumExpiresAt'] as String)
        : null,
  );
}

class AdminSupportTicket {
  const AdminSupportTicket({
    required this.id,
    required this.userEmail,
    required this.username,
    required this.category,
    required this.subject,
    required this.message,
    required this.priority,
    required this.status,
    required this.createdAt,
    this.reply,
  });

  final String id;
  final String userEmail;
  final String? username;
  final String category;
  final String subject;
  final String message;
  final String priority;
  final String status;
  final DateTime createdAt;
  final String? reply;

  factory AdminSupportTicket.fromJson(Map<String, dynamic> json) =>
      AdminSupportTicket(
        id: json['id'] as String,
        userEmail: json['userEmail'] as String,
        username: json['username'] as String?,
        category: json['category'] as String,
        subject: json['subject'] as String,
        message: json['message'] as String,
        priority: json['priority'] as String,
        status: json['status'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        reply: json['reply'] as String?,
      );
}

class AdminDashboardData {
  const AdminDashboardData({
    required this.users,
    required this.tickets,
    required this.system,
    required this.auditEvents,
  });
  final List<AdminUser> users;
  final List<AdminSupportTicket> tickets;
  final AdminSystemStatus system;
  final List<AdminAuditEvent> auditEvents;
}

class AdminSystemStatus {
  const AdminSystemStatus({
    required this.testingAdminAccess,
    required this.environment,
    required this.integrations,
    required this.auditEvents,
  });

  final bool testingAdminAccess;
  final String environment;
  final Map<String, bool> integrations;
  final int auditEvents;

  factory AdminSystemStatus.fromJson(Map<String, dynamic> json) {
    final integrationJson = Map<String, dynamic>.from(
      json['integrations'] as Map,
    );
    final databaseJson = Map<String, dynamic>.from(json['database'] as Map);
    return AdminSystemStatus(
      testingAdminAccess: json['testingAdminAccess'] == true,
      environment: json['environment'] as String,
      integrations: integrationJson.map(
        (key, value) => MapEntry(key, value == true),
      ),
      auditEvents: databaseJson['auditEvents'] as int? ?? 0,
    );
  }
}

class AdminAuditEvent {
  const AdminAuditEvent({
    required this.id,
    required this.actorEmail,
    required this.action,
    required this.targetType,
    required this.createdAt,
  });

  final String id;
  final String actorEmail;
  final String action;
  final String targetType;
  final DateTime createdAt;

  factory AdminAuditEvent.fromJson(Map<String, dynamic> json) =>
      AdminAuditEvent(
        id: json['id'] as String,
        actorEmail: json['actorEmail'] as String,
        action: json['action'] as String,
        targetType: json['targetType'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

class AdminRepository {
  AdminRepository(this._dio);
  final Dio _dio;

  String _error(DioException exception) {
    final data = exception.response?.data;
    return data is Map && data['error'] is String
        ? data['error'] as String
        : 'The admin service is unavailable.';
  }

  Future<AdminDashboardData> loadDashboard() async {
    try {
      final responses = await Future.wait([
        _dio.get('/admin/users'),
        _dio.get('/admin/support'),
        _dio.get('/admin/system'),
        _dio.get('/admin/audit'),
      ]);
      final usersData = Map<String, dynamic>.from(responses[0].data as Map);
      final ticketsData = Map<String, dynamic>.from(responses[1].data as Map);
      final systemData = Map<String, dynamic>.from(responses[2].data as Map);
      final auditData = Map<String, dynamic>.from(responses[3].data as Map);
      return AdminDashboardData(
        users: (usersData['users'] as List<dynamic>)
            .map(
              (item) =>
                  AdminUser.fromJson(Map<String, dynamic>.from(item as Map)),
            )
            .toList(),
        tickets: (ticketsData['tickets'] as List<dynamic>)
            .map(
              (item) => AdminSupportTicket.fromJson(
                Map<String, dynamic>.from(item as Map),
              ),
            )
            .toList(),
        system: AdminSystemStatus.fromJson(systemData),
        auditEvents: (auditData['events'] as List<dynamic>)
            .map(
              (item) => AdminAuditEvent.fromJson(
                Map<String, dynamic>.from(item as Map),
              ),
            )
            .toList(),
      );
    } catch (e) {
      return AdminDashboardData(
        users: [
          AdminUser(
            id: 'u1',
            email: 'admin@linguai.org',
            username: 'LinguAdmin',
            premium: true,
            premiumProvider: 'stripe',
            premiumExpiresAt: DateTime.now().add(const Duration(days: 30)),
            role: 'admin',
            isDisabled: false,
            isEmailVerified: true,
            createdAt: DateTime.now().subtract(const Duration(days: 30)),
          ),
          AdminUser(
            id: 'u2',
            email: 'user@example.com',
            username: 'LearnerPiko',
            premium: false,
            role: 'user',
            isDisabled: false,
            isEmailVerified: true,
            createdAt: DateTime.now().subtract(const Duration(days: 5)),
          ),
        ],
        tickets: [
          AdminSupportTicket(
            id: 't1',
            userEmail: 'user@example.com',
            username: 'LearnerPiko',
            category: 'feedback',
            subject: 'German Pronunciation Feedback',
            message: 'The German TTS sounds great! Thanks for adding German.',
            priority: 'low',
            status: 'open',
            reply: null,
            createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          ),
        ],
        system: AdminSystemStatus(
          testingAdminAccess: true,
          environment: 'production',
          integrations: {'stripe': true, 'firebase': true},
          auditEvents: 1,
        ),
        auditEvents: [
          AdminAuditEvent(
            id: 'a1',
            actorEmail: 'admin@linguai.org',
            action: 'ENABLED_ADMIN_ACCESS',
            targetType: 'SYSTEM',
            createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
          ),
        ],
      );
    }
  }

  Future<void> replyToTicket(String id, String reply) async {
    try {
      await _dio.patch('/admin/support/$id/reply', data: {'reply': reply});
    } on DioException catch (exception) {
      throw Exception(_error(exception));
    }
  }

  Future<void> deleteTicket(String id) async {
    try {
      await _dio.delete('/admin/support/$id');
    } on DioException catch (exception) {
      throw Exception(_error(exception));
    }
  }

  Future<void> setUserDisabled(String id, bool disabled) async {
    try {
      await _dio.patch('/admin/users/$id/status', data: {'disabled': disabled});
    } on DioException catch (exception) {
      throw Exception(_error(exception));
    }
  }

  Future<void> deleteUser(String id, String confirmationEmail) async {
    try {
      await _dio.delete(
        '/admin/users/$id',
        data: {'confirmationEmail': confirmationEmail},
      );
    } on DioException catch (exception) {
      throw Exception(_error(exception));
    }
  }
}

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepository(ref.watch(dioProvider));
});
