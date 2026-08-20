import 'dart:convert';
import 'dart:io';

import 'package:bcrypt/bcrypt.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../services/mail_service.dart';
import '../../services/security_service.dart';

class ApiRoute extends Route {
  ApiRoute()
    : super(
        methods: const {
          Method.get,
          Method.post,
          Method.put,
          Method.patch,
          Method.delete,
          Method.options,
        },
      );

  static final Map<String, List<DateTime>> _rateLimits = {};

  @override
  Future<Result> handleCall(Session session, Request request) async {
    if (request.method == Method.options) return Response.ok();
    try {
      final path = request.url.path.replaceFirst(RegExp(r'^/api(?:/v1)?'), '');
      final bodyText = request.isEmpty
          ? ''
          : await request.readAsString(maxLength: 1024 * 1024);
      final body = bodyText.isEmpty
          ? <String, dynamic>{}
          : Map<String, dynamic>.from(jsonDecode(bodyText) as Map);
      final auth = request.headers.authorization?.headerValue;

      if (path == '/health' && request.method == Method.get) {
        return _json(200, {
          'status': 'ok',
          'runtime': 'Dart/Serverpod',
          'timestamp': DateTime.now().toUtc().toIso8601String(),
        });
      }
      if (path == '/webhooks/stripe' && request.method == Method.post) {
        return await _stripeWebhook(session, request, bodyText, body);
      }
      if (path.startsWith('/auth/')) {
        _checkRateLimit(request.remoteInfo, 'auth', max: 50);
        return await _auth(session, request, path, body, auth);
      }

      final user = await _authenticatedUser(session, auth);
      if (user == null) return _error(401, 'Authentication is required.');

      if (path == '/user/profile' && request.method == Method.put) {
        return await _updateProfile(session, user, body);
      }
      if (path == '/user/profile' && request.method == Method.get) {
        return await _legacyProfile(session, user);
      }
      if (path == '/user/profile' && request.method == Method.patch) {
        return await _updateProfile(session, user, body);
      }
      if (path == '/user/survey' && request.method == Method.post) {
        return await _survey(session, user, body);
      }
      if (path == '/lessons' && request.method == Method.get) {
        return await _lessons(session, request, user);
      }
      if (path == '/progress' && request.method == Method.get) {
        return await _legacyProgress(session, user);
      }
      if (path == '/progress/sync' && request.method == Method.post) {
        return await _legacyProgressSync(session, user, body);
      }
      if (path == '/leaderboard' && request.method == Method.get) {
        return await _leaderboard(session, user);
      }
      if (path.startsWith('/support')) {
        return await _support(session, request, path, body, user);
      }
      if (path.startsWith('/admin')) {
        return await _admin(session, request, path, body, user);
      }
      if (path == '/ai/tutor' && request.method == Method.post) {
        return await _tutor(session, body, user);
      }
      if (path.startsWith('/payments')) {
        return await _payments(session, request, path, user);
      }
      if (path.startsWith('/sync')) {
        return await _sync(session, request, path, body, user);
      }
      return _error(404, 'Endpoint not found.');
    } on _RateLimitException catch (e) {
      return _error(429, e.message);
    } on FormatException {
      return _error(400, 'Invalid request body.');
    } catch (error, stackTrace) {
      session.log('REST API error: $error\n$stackTrace', level: LogLevel.error);
      return _error(500, 'Internal server error.');
    }
  }

  Future<Result> _auth(
    Session session,
    Request request,
    String path,
    Map<String, dynamic> body,
    String? authorization,
  ) async {
    if (path == '/auth/register' && request.method == Method.post) {
      final email = '${body['email'] ?? ''}'.trim().toLowerCase();
      final password = '${body['password'] ?? ''}';
      if (body['ageConfirmed'] != true) {
        return _error(
          400,
          'You must confirm that you are at least 13 years old to register.',
        );
      }
      if (!_validEmail(email) || !_validPassword(password)) {
        return _error(400, 'A valid email and strong password are required.');
      }
      if (await AppUser.db.findFirstRow(
            session,
            where: (t) => t.email.equals(email),
          ) !=
          null) {
        return _error(409, 'An account with this email already exists.');
      }
      final now = DateTime.now().toUtc();
      final user = await AppUser.db.insertRow(
        session,
        AppUser(
          email: email,
          passwordHash: BCrypt.hashpw(password, BCrypt.gensalt(logRounds: 12)),
          createdAt: now,
          updatedAt: now,
        ),
      );
      await UserProgressRecord.db.insertRow(
        session,
        UserProgressRecord(userId: user.id!, updatedAt: now),
      );
      final token = SecurityService.randomToken(32);
      final verification = await VerificationTokenRecord.db.insertRow(
        session,
        VerificationTokenRecord(
          email: email,
          tokenHash: SecurityService.hashToken(token),
          expiresAt: now.add(const Duration(hours: 24)),
          createdAt: now,
        ),
      );
      try {
        await MailService.sendVerification(email, token);
      } catch (_) {
        await VerificationTokenRecord.db.deleteRow(session, verification);
        await UserProgressRecord.db.deleteWhere(
          session,
          where: (t) => t.userId.equals(user.id!),
        );
        await AppUser.db.deleteRow(session, user);
        rethrow;
      }
      return _json(201, {
        'message': 'User registered successfully. Please verify your email.',
      });
    }
    if (path == '/auth/verify-email' && request.method == Method.get) {
      final token = request.url.queryParameters['token'] ?? '';
      final record = await VerificationTokenRecord.db.findFirstRow(
        session,
        where: (t) => t.tokenHash.equals(SecurityService.hashToken(token)),
      );
      if (record == null || record.expiresAt.isBefore(DateTime.now().toUtc())) {
        return _error(400, 'Invalid or expired token.');
      }
      final user = await AppUser.db.findFirstRow(
        session,
        where: (t) => t.email.equals(record.email),
      );
      if (user == null) return _error(400, 'Account not found.');
      user.isEmailVerified = true;
      user.updatedAt = DateTime.now().toUtc();
      await AppUser.db.updateRow(session, user);
      await VerificationTokenRecord.db.deleteRow(session, record);
      return Response.ok(
        body: Body.fromString(
          '<html><body style="font-family:sans-serif;text-align:center;padding:48px"><h1>Email verified 🎉</h1><p>You can return to LinguAI and log in.</p></body></html>',
          mimeType: MimeType.html,
        ),
      );
    }
    if (path == '/auth/login' && request.method == Method.post) {
      final email = '${body['email'] ?? ''}'.trim().toLowerCase();
      final password = '${body['password'] ?? ''}';
      final user = await AppUser.db.findFirstRow(
        session,
        where: (t) => t.email.equals(email),
      );
      if (user == null || !BCrypt.checkpw(password, user.passwordHash)) {
        return _error(401, 'Invalid credentials');
      }
      if (user.isDisabled) {
        return _error(
          403,
          'This account has been suspended. Contact support for assistance.',
        );
      }
      if (!user.isEmailVerified) {
        return _error(403, 'Please verify your email first.');
      }
      final refresh = SecurityService.randomToken();
      await RefreshTokenRecord.db.insertRow(
        session,
        RefreshTokenRecord(
          tokenHash: SecurityService.hashToken(refresh),
          userId: user.id!,
          device: '${body['device'] ?? 'unknown'}',
          expiresAt: DateTime.now().toUtc().add(const Duration(days: 7)),
          createdAt: DateTime.now().toUtc(),
        ),
      );
      return _json(200, {
        'token': SecurityService.createAccessToken(user.id!),
        'refreshToken': refresh,
        'user': await _userJson(session, user),
      });
    }
    if ((path == '/auth/refresh-token' || path == '/auth/refresh') &&
        request.method == Method.post) {
      final raw = '${body['token'] ?? ''}';
      final stored = await RefreshTokenRecord.db.findFirstRow(
        session,
        where: (t) => t.tokenHash.equals(SecurityService.hashToken(raw)),
      );
      if (stored == null || stored.expiresAt.isBefore(DateTime.now().toUtc())) {
        return _error(401, 'Invalid or expired refresh token');
      }
      final user = await AppUser.db.findById(session, stored.userId);
      if (user == null || user.isDisabled) {
        return _error(403, 'This account is unavailable.');
      }
      await RefreshTokenRecord.db.deleteRow(session, stored);
      final refresh = SecurityService.randomToken();
      await RefreshTokenRecord.db.insertRow(
        session,
        RefreshTokenRecord(
          tokenHash: SecurityService.hashToken(refresh),
          userId: user.id!,
          device: stored.device,
          expiresAt: DateTime.now().toUtc().add(const Duration(days: 7)),
          createdAt: DateTime.now().toUtc(),
        ),
      );
      return _json(200, {
        'accessToken': SecurityService.createAccessToken(user.id!),
        'refreshToken': refresh,
      });
    }
    if (path == '/auth/logout' && request.method == Method.post) {
      final raw = '${body['refreshToken'] ?? ''}';
      final stored = await RefreshTokenRecord.db.findFirstRow(
        session,
        where: (t) => t.tokenHash.equals(SecurityService.hashToken(raw)),
      );
      if (stored == null) return _error(400, 'Invalid token');
      if (body['allDevices'] == true) {
        await RefreshTokenRecord.db.deleteWhere(
          session,
          where: (t) => t.userId.equals(stored.userId),
        );
      } else {
        await RefreshTokenRecord.db.deleteRow(session, stored);
      }
      return _json(200, {'message': 'Logged out successfully'});
    }
    if (path == '/auth/forgot-password' && request.method == Method.post) {
      final email = '${body['email'] ?? ''}'.trim().toLowerCase();
      final user = await AppUser.db.findFirstRow(
        session,
        where: (t) => t.email.equals(email),
      );
      if (user != null) {
        final token = SecurityService.randomToken(32);
        final now = DateTime.now().toUtc();
        await PasswordResetTokenRecord.db.insertRow(
          session,
          PasswordResetTokenRecord(
            email: email,
            tokenHash: SecurityService.hashToken(token),
            expiresAt: now.add(const Duration(hours: 1)),
            createdAt: now,
          ),
        );
        await MailService.sendPasswordReset(email, token);
      }
      return _json(200, {
        'message': 'If that email exists, we sent a password reset link.',
      });
    }
    if (path == '/auth/reset-password' && request.method == Method.post) {
      final token = '${body['token'] ?? ''}';
      final password = '${body['newPassword'] ?? ''}';
      if (!_validPassword(password)) {
        return _error(
          400,
          'The new password does not meet the security requirements.',
        );
      }
      final reset = await PasswordResetTokenRecord.db.findFirstRow(
        session,
        where: (t) => t.tokenHash.equals(SecurityService.hashToken(token)),
      );
      if (reset == null || reset.expiresAt.isBefore(DateTime.now().toUtc())) {
        return _error(400, 'Invalid or expired reset token');
      }
      final user = await AppUser.db.findFirstRow(
        session,
        where: (t) => t.email.equals(reset.email),
      );
      if (user == null) return _error(400, 'Invalid or expired reset token');
      user.passwordHash = BCrypt.hashpw(
        password,
        BCrypt.gensalt(logRounds: 12),
      );
      user.updatedAt = DateTime.now().toUtc();
      await AppUser.db.updateRow(session, user);
      await PasswordResetTokenRecord.db.deleteWhere(
        session,
        where: (t) => t.email.equals(reset.email),
      );
      await RefreshTokenRecord.db.deleteWhere(
        session,
        where: (t) => t.userId.equals(user.id!),
      );
      return _json(200, {'message': 'Password has been reset successfully'});
    }

    final user = await _authenticatedUser(session, authorization);
    if (user == null) return _error(401, 'Authentication is required.');
    if (path == '/auth/me' && request.method == Method.get) {
      return _json(200, {'user': await _userJson(session, user)});
    }
    if (path == '/auth/me' && request.method == Method.delete) {
      await _deleteUserData(session, user.id!);
      await AppUser.db.deleteRow(session, user);
      return _json(200, {'message': 'Account deleted successfully'});
    }
    return _error(404, 'Endpoint not found.');
  }

  Future<Result> _updateProfile(
    Session session,
    AppUser user,
    Map<String, dynamic> body,
  ) async {
    final username = body['username'];
    final avatarId = body['avatarId'];
    final language = body['targetLanguage'];
    if (username is String && username.trim().isNotEmpty) {
      user.username = username.trim();
    }
    if (avatarId is String && avatarId.trim().isNotEmpty) {
      user.avatarId = avatarId.trim();
    }
    if (language is String && language.trim().isNotEmpty) {
      user.targetLanguage = language.trim();
    }
    if (body['dob'] is String) {
      user.dateOfBirth = DateTime.tryParse(body['dob']);
    }
    user.updatedAt = DateTime.now().toUtc();
    await AppUser.db.updateRow(session, user);
    return _json(200, {
      'message': 'Profile updated successfully',
      'user': await _userJson(session, user),
    });
  }

  Future<Result> _legacyProfile(Session session, AppUser user) async {
    final progress = await UserProgressRecord.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(user.id!),
    );
    final subscription = await _activeSubscription(session, user.id!);
    return _json(200, {
      'id': '${user.id}',
      'email': user.email,
      'name': user.username,
      'username': user.username,
      'targetLanguage': user.targetLanguage,
      'streakCount': progress?.currentStreak ?? 0,
      'xpTotal': progress?.totalXp ?? 0,
      'gemsCount': progress?.gemsCount ?? 100,
      'isPremium': user.role == 'admin' || subscription != null,
      'createdAt': user.createdAt.toIso8601String(),
    });
  }

  Future<Result> _lessons(
    Session session,
    Request request,
    AppUser user,
  ) async {
    final language =
        request.url.queryParameters['language'] ??
        request.url.queryParameters['languageCode'] ??
        user.targetLanguage;
    final lessons = await LessonRecord.db.find(
      session,
      where: (t) =>
          t.languageCode.equals(language) & t.status.equals('approved'),
      orderBy: (t) => t.orderIndex,
    );
    final output = <Map<String, dynamic>>[];
    for (final lesson in lessons) {
      final words = await VocabWordRecord.db.find(
        session,
        where: (t) => t.lessonId.equals(lesson.id!),
        orderBy: (t) => t.orderIndex,
      );
      final progress = await UserLessonRecord.db.findFirstRow(
        session,
        where: (t) => t.userId.equals(user.id!) & t.lessonId.equals(lesson.id!),
      );
      output.add({
        'id': lesson.id,
        'title': lesson.topic,
        'topic': lesson.topic,
        'languageCode': lesson.languageCode,
        'unitNumber': lesson.unitNumber,
        'orderIndex': lesson.orderIndex,
        'cefrLevel': lesson.cefrLevel,
        'grammarNote': lesson.grammarNote,
        'isCompleted': progress?.isCompleted ?? false,
        'isLocked': progress?.isLocked ?? lesson.orderIndex > 1,
        'vocabWords': words.map(_wordJson).toList(),
      });
    }
    return _json(200, output);
  }

  Future<Result> _legacyProgress(Session session, AppUser user) async {
    final lessons = await UserLessonRecord.db.find(
      session,
      where: (t) => t.userId.equals(user.id!),
    );
    final words = await UserVocabRecord.db.find(
      session,
      where: (t) => t.userId.equals(user.id!),
    );
    return _json(200, {
      'progress': lessons
          .map(
            (entry) => {
              'lessonId': entry.lessonId,
              'isCompleted': entry.isCompleted,
              'score': entry.bestScore,
              'completedAt': entry.completedAt?.toIso8601String(),
              'currentStep': entry.currentStep,
              'draft': entry.draftJson == null
                  ? null
                  : jsonDecode(entry.draftJson!),
            },
          )
          .toList(),
      'wordMastery': words
          .map(
            (entry) => {
              'wordId': entry.vocabWordId,
              'masteryLevel': entry.repetitions.clamp(0, 5),
              'nextReviewAt': entry.nextReviewDate?.toIso8601String(),
              'easeFactor': entry.easinessFactor,
              'intervalDays': entry.intervalDays,
            },
          )
          .toList(),
    });
  }

  Future<Result> _legacyProgressSync(
    Session session,
    AppUser user,
    Map<String, dynamic> body,
  ) async {
    final now = DateTime.now().toUtc();
    final lessonId = (body['lessonId'] as num?)?.toInt();
    if (lessonId != null) {
      final score = ((body['score'] as num?)?.toInt() ?? 100).clamp(0, 100);
      var progress = await UserLessonRecord.db.findFirstRow(
        session,
        where: (t) => t.userId.equals(user.id!) & t.lessonId.equals(lessonId),
      );
      progress ??= await UserLessonRecord.db.insertRow(
        session,
        UserLessonRecord(
          userId: user.id!,
          lessonId: lessonId,
          isLocked: false,
          updatedAt: now,
        ),
      );
      progress.attempts += 1;
      if (score > progress.bestScore) progress.bestScore = score;
      if (score >= 60) {
        progress.isCompleted = true;
        progress.completedAt ??= now;
      }
      progress.updatedAt = now;
      await UserLessonRecord.db.updateRow(session, progress);
    }
    final updates = body['wordUpdates'] is List
        ? body['wordUpdates'] as List
        : const [];
    for (final value in updates) {
      final item = value as Map;
      final wordId = (item['wordId'] as num?)?.toInt();
      if (wordId == null) continue;
      await _rateWord(
        session,
        user.id!,
        wordId,
        item['isCorrect'] == true ? 4 : 1,
        now,
      );
    }
    return _json(200, {'success': true});
  }

  Future<Result> _leaderboard(Session session, AppUser currentUser) async {
    final users = await AppUser.db.find(session);
    final entries = <Map<String, dynamic>>[];
    for (final user in users) {
      final progress = await UserProgressRecord.db.findFirstRow(
        session,
        where: (t) => t.userId.equals(user.id!),
      );
      entries.add({
        'id': '${user.id}',
        'name': user.username ?? 'Learner',
        'xpTotal': progress?.totalXp ?? 0,
        'streakCount': progress?.currentStreak ?? 0,
        'targetLanguage': user.targetLanguage,
        'isCurrentUser': user.id == currentUser.id,
      });
    }
    entries.sort(
      (a, b) => (b['xpTotal'] as int).compareTo(a['xpTotal'] as int),
    );
    return _json(
      200,
      entries
          .take(50)
          .toList()
          .asMap()
          .entries
          .map((entry) => {'rank': entry.key + 1, ...entry.value})
          .toList(),
    );
  }

  Future<Result> _survey(
    Session session,
    AppUser user,
    Map<String, dynamic> body,
  ) async {
    if (body['knowledgeLevel'] is String) {
      user.knowledgeLevel = body['knowledgeLevel'];
    }
    if (body['fluencyScore'] is int) user.fluencyScore = body['fluencyScore'];
    if (body['targetLanguage'] is String) {
      user.targetLanguage = body['targetLanguage'];
    }
    user.updatedAt = DateTime.now().toUtc();
    await AppUser.db.updateRow(session, user);
    final lessons = await LessonRecord.db.find(
      session,
      orderBy: (t) => t.orderIndex,
    );
    final unlockCount = user.knowledgeLevel == 'advanced'
        ? 5
        : user.knowledgeLevel == 'intermediate'
        ? 3
        : 1;
    for (final lesson in lessons.take(unlockCount)) {
      final current = await UserLessonRecord.db.findFirstRow(
        session,
        where: (t) => t.userId.equals(user.id!) & t.lessonId.equals(lesson.id!),
      );
      if (current == null) {
        await UserLessonRecord.db.insertRow(
          session,
          UserLessonRecord(
            userId: user.id!,
            lessonId: lesson.id!,
            isLocked: false,
            updatedAt: DateTime.now().toUtc(),
          ),
        );
      } else {
        current.isLocked = false;
        current.updatedAt = DateTime.now().toUtc();
        await UserLessonRecord.db.updateRow(session, current);
      }
    }
    return _json(200, {
      'message': 'Survey submitted and lessons assigned',
      'user': await _userJson(session, user),
    });
  }

  Future<Result> _support(
    Session session,
    Request request,
    String path,
    Map<String, dynamic> body,
    AppUser user,
  ) async {
    if (path == '/support' && request.method == Method.get) {
      final tickets = await SupportTicketRecord.db.find(
        session,
        where: (t) => t.userId.equals(user.id!),
        orderBy: (t) => t.createdAt,
        orderDescending: true,
      );
      return _json(200, {'tickets': tickets.map(_ticketJson).toList()});
    }
    if (path == '/support' && request.method == Method.post) {
      _checkRateLimit('${user.id}', 'support', max: 20);
      final category = '${body['category'] ?? ''}'.trim();
      final subject = '${body['subject'] ?? ''}'.trim();
      final message = '${body['message'] ?? ''}'.trim();
      if (category.isEmpty ||
          subject.length < 3 ||
          subject.length > 120 ||
          message.length < 10 ||
          message.length > 5000) {
        return _error(
          400,
          'Please provide a category, a 3–120 character subject, and a 10–5000 character message.',
        );
      }
      final premium = await _activeSubscription(session, user.id!) != null;
      final now = DateTime.now().toUtc();
      final ticket = await SupportTicketRecord.db.insertRow(
        session,
        SupportTicketRecord(
          userId: user.id!,
          category: category,
          subject: subject,
          message: message,
          priority: premium ? 'priority' : 'normal',
          createdAt: now,
          updatedAt: now,
        ),
      );
      return _json(201, {'ticket': _ticketJson(ticket)});
    }
    return _error(404, 'Endpoint not found.');
  }

  Future<Result> _admin(
    Session session,
    Request request,
    String path,
    Map<String, dynamic> body,
    AppUser actor,
  ) async {
    if (!_adminAccess(actor)) {
      return _error(403, 'Administrator access is required.');
    }
    if (path == '/admin/users' && request.method == Method.get) {
      final users = await AppUser.db.find(
        session,
        orderBy: (t) => t.createdAt,
        orderDescending: true,
      );
      final output = <Map<String, dynamic>>[];
      for (final user in users) {
        final sub = await _activeSubscription(session, user.id!);
        output.add({
          ...await _userJson(session, user),
          'isDisabled': user.isDisabled,
          'isEmailVerified': user.isEmailVerified,
          'createdAt': user.createdAt.toIso8601String(),
          'premium': sub != null,
          'premiumProvider': sub?.provider,
          'premiumExpiresAt': sub?.expiresAt.toIso8601String(),
        });
      }
      return _json(200, {'users': output});
    }
    final statusMatch = RegExp(r'^/admin/users/(\d+)/status$').firstMatch(path);
    if (statusMatch != null && request.method == Method.patch) {
      final id = int.parse(statusMatch.group(1)!);
      if (id == actor.id) {
        return _error(400, 'You cannot suspend your own account.');
      }
      final target = await AppUser.db.findById(session, id);
      if (target == null || body['disabled'] is! bool) {
        return _error(400, 'A valid account and disabled status are required.');
      }
      target.isDisabled = body['disabled'];
      target.updatedAt = DateTime.now().toUtc();
      await AppUser.db.updateRow(session, target);
      if (target.isDisabled) {
        await RefreshTokenRecord.db.deleteWhere(
          session,
          where: (t) => t.userId.equals(id),
        );
      }
      await _audit(
        session,
        actor.id!,
        target.isDisabled ? 'user.suspended' : 'user.restored',
        'user',
        '$id',
        {'email': target.email},
      );
      return _json(200, {'id': '$id', 'isDisabled': target.isDisabled});
    }
    final userMatch = RegExp(r'^/admin/users/(\d+)$').firstMatch(path);
    if (userMatch != null && request.method == Method.delete) {
      final id = int.parse(userMatch.group(1)!);
      if (id == actor.id) {
        return _error(
          400,
          'Use the profile account-deletion flow for your own account.',
        );
      }
      final target = await AppUser.db.findById(session, id);
      if (target == null) return _error(404, 'Account not found.');
      if ('${body['confirmationEmail'] ?? ''}'.trim().toLowerCase() !=
          target.email) {
        return _error(400, 'The confirmation email does not match.');
      }
      await _audit(session, actor.id!, 'user.deleted', 'user', '$id', {
        'email': target.email,
      });
      await _deleteUserData(session, id);
      await AppUser.db.deleteRow(session, target);
      return Response.noContent();
    }
    if (path == '/admin/system' && request.method == Method.get) {
      final users = await AppUser.db.count(session);
      final subscriptions = await SubscriptionRecord.db.count(
        session,
        where: (t) =>
            t.status.equals('active') & (t.expiresAt > DateTime.now().toUtc()),
      );
      final openTickets = await SupportTicketRecord.db.count(
        session,
        where: (t) => t.status.equals('open'),
      );
      final audits = await AdminAuditLogRecord.db.count(session);
      bool env(String name) => (Platform.environment[name] ?? '').isNotEmpty;
      return _json(200, {
        'testingAdminAccess': _testingAdmin,
        'environment':
            Platform.environment['SERVERPOD_RUN_MODE'] ?? 'development',
        'database': {
          'connected': true,
          'users': users,
          'activeSubscriptions': subscriptions,
          'openTickets': openTickets,
          'auditEvents': audits,
        },
        'integrations': {
          'stripe':
              env('STRIPE_SECRET_KEY') &&
              env('STRIPE_WEBHOOK_SECRET') &&
              env('STRIPE_PREMIUM_PRICE_ID'),
          'smtp':
              env('SMTP_HOST') &&
              env('SMTP_USER') &&
              env('SMTP_PASS') &&
              env('MAIL_FROM'),
          'gemini': env('GEMINI_API_KEY'),
        },
      });
    }
    if (path == '/admin/audit' && request.method == Method.get) {
      final events = await AdminAuditLogRecord.db.find(
        session,
        orderBy: (t) => t.createdAt,
        orderDescending: true,
        limit: 100,
      );
      final output = <Map<String, dynamic>>[];
      for (final event in events) {
        final actorUser = event.actorUserId == null
            ? null
            : await AppUser.db.findById(session, event.actorUserId!);
        output.add({
          'id': '${event.id}',
          'actorEmail': actorUser?.email ?? 'Deleted account',
          'action': event.action,
          'targetType': event.targetType,
          'targetId': event.targetId,
          'details': event.details,
          'createdAt': event.createdAt.toIso8601String(),
        });
      }
      return _json(200, {'events': output});
    }
    if (path == '/admin/support' && request.method == Method.get) {
      final tickets = await SupportTicketRecord.db.find(
        session,
        orderBy: (t) => t.createdAt,
      );
      final output = <Map<String, dynamic>>[];
      for (final ticket in tickets) {
        final owner = await AppUser.db.findById(session, ticket.userId);
        output.add({
          ..._ticketJson(ticket),
          'userEmail': owner?.email ?? 'Deleted account',
          'username': owner?.username,
        });
      }
      return _json(200, {'tickets': output});
    }
    final replyMatch = RegExp(r'^/admin/support/(\d+)/reply$').firstMatch(path);
    if (replyMatch != null && request.method == Method.patch) {
      final id = int.parse(replyMatch.group(1)!);
      final reply = '${body['reply'] ?? ''}'.trim();
      final ticket = await SupportTicketRecord.db.findById(session, id);
      if (ticket == null) return _error(404, 'Support ticket not found.');
      if (reply.length < 2 || reply.length > 5000) {
        return _error(400, 'A 2–5000 character reply is required.');
      }
      ticket.reply = reply;
      ticket.status = 'answered';
      ticket.repliedAt = DateTime.now().toUtc();
      ticket.updatedAt = ticket.repliedAt!;
      await SupportTicketRecord.db.updateRow(session, ticket);
      await _audit(
        session,
        actor.id!,
        'support.replied',
        'supportTicket',
        '$id',
        {'userId': ticket.userId},
      );
      return _json(200, {'id': '$id', 'status': ticket.status});
    }
    final ticketMatch = RegExp(r'^/admin/support/(\d+)$').firstMatch(path);
    if (ticketMatch != null && request.method == Method.delete) {
      final ticket = await SupportTicketRecord.db.findById(
        session,
        int.parse(ticketMatch.group(1)!),
      );
      if (ticket == null) return _error(404, 'Support ticket not found.');
      await _audit(
        session,
        actor.id!,
        'support.deleted',
        'supportTicket',
        '${ticket.id}',
        {'subject': ticket.subject},
      );
      await SupportTicketRecord.db.deleteRow(session, ticket);
      return Response.noContent();
    }
    return _error(404, 'Endpoint not found.');
  }

  Future<Result> _tutor(
    Session session,
    Map<String, dynamic> body,
    AppUser user,
  ) async {
    final prompt = '${body['prompt'] ?? ''}'.trim();
    if (prompt.isEmpty) return _error(400, 'Prompt is required.');
    final suppliedKey = '${body['apiKey'] ?? ''}'.trim();
    final apiKey = suppliedKey.isNotEmpty
        ? suppliedKey
        : Platform.environment['GEMINI_API_KEY'];
    final premium =
        user.role == 'admin' ||
        await _activeSubscription(session, user.id!) != null;
    if (suppliedKey.isEmpty && !premium) {
      return _json(403, {
        'error':
            'AI Tutor is a premium feature. Add your own API key or upgrade to unlock.',
        'premiumRequired': true,
      });
    }
    if (apiKey == null || apiKey.isEmpty) {
      return _error(
        503,
        'The built-in AI Tutor is not configured. Add your own Gemini API key in AI Settings.',
      );
    }
    _checkRateLimit('${user.id}', 'ai', max: 30);
    final words = body['contextWords'] is List
        ? (body['contextWords'] as List).join(', ')
        : '';
    final system =
        'You are Piko, a warm, playful, encouraging language tutor. The learner studies ${body['targetLanguage'] ?? user.targetLanguage}, level ${user.knowledgeLevel ?? 'beginner'}. ${words.isEmpty ? '' : 'Recently difficult words: $words.'} Give concise, accurate explanations, gently correct mistakes, and preserve quiz context.';
    final model = Platform.environment['GEMINI_MODEL'] ?? 'gemini-2.5-flash';
    final response = await http.post(
      Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=${Uri.encodeQueryComponent(apiKey)}',
      ),
      headers: {'content-type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'role': 'user',
            'parts': [
              {'text': '$system\n\nLearner: $prompt'},
            ],
          },
        ],
      }),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      return _error(
        502,
        'The AI provider rejected the request. Check the API key and try again.',
      );
    }
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final candidates = decoded['candidates'] as List?;
    final text = candidates?.isNotEmpty == true
        ? (((candidates!.first as Map)['content'] as Map)['parts'] as List)
              .map((p) => (p as Map)['text'] ?? '')
              .join()
        : '';
    if (text.isEmpty) {
      return _error(502, 'The AI tutor returned an empty response.');
    }
    return _json(200, {'response': text});
  }

  Future<Result> _payments(
    Session session,
    Request request,
    String path,
    AppUser user,
  ) async {
    if (path == '/payments/subscription' && request.method == Method.get) {
      final sub = await _activeSubscription(session, user.id!);
      return _json(200, {
        'active': sub != null,
        'expiresAt': sub?.expiresAt.toIso8601String(),
        'provider': sub?.provider,
      });
    }
    final secret = Platform.environment['STRIPE_SECRET_KEY'];
    final appUrl = Platform.environment['PUBLIC_APP_URL'];
    if (secret == null || appUrl == null) {
      return _error(503, 'Billing is not configured yet.');
    }
    if (path == '/payments/checkout-session' && request.method == Method.post) {
      final price = Platform.environment['STRIPE_PREMIUM_PRICE_ID'];
      if (price == null) return _error(503, 'Billing is not configured yet.');
      final result = await _stripePost(secret, '/v1/checkout/sessions', {
        'mode': 'subscription',
        'customer_email': user.email,
        'client_reference_id': '${user.id}',
        'line_items[0][price]': price,
        'line_items[0][quantity]': '1',
        'subscription_data[metadata][userId]': '${user.id}',
        'success_url': '$appUrl/#/payment?checkout=success',
        'cancel_url': '$appUrl/#/payment?checkout=cancelled',
        'allow_promotion_codes': 'true',
      });
      return result['url'] is String
          ? _json(201, {'url': result['url']})
          : _error(502, 'Stripe did not return a checkout URL.');
    }
    if (path == '/payments/portal-session' && request.method == Method.post) {
      final subs = await SubscriptionRecord.db.find(
        session,
        where: (t) => t.userId.equals(user.id!) & t.provider.equals('stripe'),
        orderBy: (t) => t.updatedAt,
        orderDescending: true,
        limit: 1,
      );
      final customer = subs.firstOrNull?.customerId;
      if (customer == null) {
        return _error(404, 'No Stripe subscription was found.');
      }
      final result = await _stripePost(secret, '/v1/billing_portal/sessions', {
        'customer': customer,
        'return_url': '$appUrl/#/payment',
      });
      return _json(201, {'url': result['url']});
    }
    return _error(404, 'Endpoint not found.');
  }

  Future<Result> _stripeWebhook(
    Session session,
    Request request,
    String rawBody,
    Map<String, dynamic> event,
  ) async {
    final secret = Platform.environment['STRIPE_WEBHOOK_SECRET'];
    final signature = request.headers['stripe-signature']?.firstOrNull;
    if (secret == null || signature == null) {
      return _error(503, 'Stripe webhook is not configured.');
    }
    final parts = <String, List<String>>{};
    for (final item in signature.split(',')) {
      final split = item.split('=');
      if (split.length == 2) {
        parts.putIfAbsent(split[0], () => []).add(split[1]);
      }
    }
    final timestamp = int.tryParse(parts['t']?.firstOrNull ?? '');
    final signatures = parts['v1'] ?? const <String>[];
    if (timestamp == null ||
        DateTime.now().millisecondsSinceEpoch ~/ 1000 - timestamp > 300) {
      return _error(400, 'Invalid Stripe webhook signature.');
    }
    final expected = Hmac(
      sha256,
      utf8.encode(secret),
    ).convert(utf8.encode('$timestamp.$rawBody')).toString();
    if (!signatures.any((value) => _constantTimeEquals(value, expected))) {
      return _error(400, 'Invalid Stripe webhook signature.');
    }
    final type = event['type'];
    final object = ((event['data'] as Map?)?['object'] as Map?)
        ?.cast<String, dynamic>();
    if (object == null) return _error(400, 'Invalid Stripe event.');
    if (type == 'customer.subscription.created' ||
        type == 'customer.subscription.updated' ||
        type == 'customer.subscription.deleted') {
      await _persistStripeSubscription(session, object);
    } else if (type == 'checkout.session.completed' &&
        object['subscription'] is String) {
      final stripeSecret = Platform.environment['STRIPE_SECRET_KEY'];
      if (stripeSecret == null) return _error(503, 'Stripe is not configured.');
      final response = await http.get(
        Uri.parse(
          'https://api.stripe.com/v1/subscriptions/${object['subscription']}',
        ),
        headers: {'authorization': 'Bearer $stripeSecret'},
      );
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return _error(502, 'Could not retrieve the Stripe subscription.');
      }
      await _persistStripeSubscription(
        session,
        Map<String, dynamic>.from(jsonDecode(response.body) as Map),
      );
    }
    return _json(200, {'received': true});
  }

  Future<void> _persistStripeSubscription(
    Session session,
    Map<String, dynamic> subscription,
  ) async {
    final metadata = (subscription['metadata'] as Map?)
        ?.cast<String, dynamic>();
    final userId = int.tryParse('${metadata?['userId'] ?? ''}');
    final externalId = '${subscription['id'] ?? ''}';
    if (userId == null ||
        externalId.isEmpty ||
        await AppUser.db.findById(session, userId) == null) {
      throw StateError('Stripe subscription has no valid LinguAI user.');
    }
    final statusValue = '${subscription['status'] ?? 'incomplete'}';
    final active = statusValue == 'active' || statusValue == 'trialing';
    var periodEnd = (subscription['current_period_end'] as num?)?.toInt();
    final items =
        ((subscription['items'] as Map?)?['data'] as List?) ?? const [];
    for (final item in items) {
      final value = ((item as Map)['current_period_end'] as num?)?.toInt();
      if (value != null && (periodEnd == null || value > periodEnd)) {
        periodEnd = value;
      }
    }
    final customerValue = subscription['customer'];
    final customer = customerValue is String
        ? customerValue
        : customerValue is Map
        ? '${customerValue['id']}'
        : null;
    final now = DateTime.now().toUtc();
    final expiresAt = DateTime.fromMillisecondsSinceEpoch(
      (periodEnd ?? now.millisecondsSinceEpoch ~/ 1000) * 1000,
      isUtc: true,
    );
    final current = await SubscriptionRecord.db.findFirstRow(
      session,
      where: (t) => t.externalId.equals(externalId),
    );
    if (current == null) {
      await SubscriptionRecord.db.insertRow(
        session,
        SubscriptionRecord(
          userId: userId,
          provider: 'stripe',
          externalId: externalId,
          customerId: customer,
          status: active ? 'active' : statusValue,
          expiresAt: expiresAt,
          createdAt: now,
          updatedAt: now,
        ),
      );
    } else {
      current.customerId = customer;
      current.status = active ? 'active' : statusValue;
      current.expiresAt = expiresAt;
      current.updatedAt = now;
      await SubscriptionRecord.db.updateRow(session, current);
    }
  }

  Future<Result> _sync(
    Session session,
    Request request,
    String path,
    Map<String, dynamic> body,
    AppUser user,
  ) async {
    final now = DateTime.now().toUtc();
    if (path == '/sync/xp' && request.method == Method.post) {
      final logs = body['logs'] is List ? body['logs'] as List : const [];
      final amount = logs.fold<int>(
        0,
        (sum, item) =>
            sum +
            (((item as Map)['amount'] as num?)?.toInt() ?? 0).clamp(0, 10000),
      );
      var progress = await UserProgressRecord.db.findFirstRow(
        session,
        where: (t) => t.userId.equals(user.id!),
      );
      progress ??= await UserProgressRecord.db.insertRow(
        session,
        UserProgressRecord(userId: user.id!, updatedAt: now),
      );
      progress.totalXp += amount;
      progress.level = 1 + progress.totalXp ~/ 1000;
      progress.lastActivityDate = now;
      progress.updatedAt = now;
      await UserProgressRecord.db.updateRow(session, progress);
      return _json(200, {
        'accepted': logs.length,
        'totalXp': progress.totalXp,
        'level': progress.level,
      });
    }
    if (path == '/sync/reviews' && request.method == Method.post) {
      final logs = body['logs'] is List ? body['logs'] as List : const [];
      for (final value in logs) {
        final item = value as Map;
        final wordId = (item['vocabWordId'] as num?)?.toInt();
        final quality = ((item['quality'] as num?)?.toInt() ?? 0).clamp(0, 5);
        if (wordId == null) continue;
        var review = await UserVocabRecord.db.findFirstRow(
          session,
          where: (t) =>
              t.userId.equals(user.id!) & t.vocabWordId.equals(wordId),
        );
        review ??= await UserVocabRecord.db.insertRow(
          session,
          UserVocabRecord(
            userId: user.id!,
            vocabWordId: wordId,
            updatedAt: now,
          ),
        );
        if (quality < 3) {
          review.repetitions = 0;
          review.intervalDays = 1;
        } else {
          review.repetitions += 1;
          review.intervalDays = review.repetitions == 1
              ? 1
              : review.repetitions == 2
              ? 6
              : (review.intervalDays * review.easinessFactor).round();
          review.easinessFactor =
              (review.easinessFactor +
                      (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02)))
                  .clamp(1.3, 3.0);
        }
        review.status = review.repetitions >= 5 ? 'mastered' : 'learning';
        review.nextReviewDate = now.add(Duration(days: review.intervalDays));
        review.updatedAt = now;
        await UserVocabRecord.db.updateRow(session, review);
      }
      return _json(200, {'accepted': logs.length});
    }
    if (path == '/sync/state' && request.method == Method.put) {
      var progress = await UserProgressRecord.db.findFirstRow(
        session,
        where: (t) => t.userId.equals(user.id!),
      );
      progress ??= await UserProgressRecord.db.insertRow(
        session,
        UserProgressRecord(userId: user.id!, updatedAt: now),
      );
      progress.activeRoute = body['route'] as String?;
      progress.activeStateJson = body['state'] == null
          ? null
          : jsonEncode(body['state']);
      progress.updatedAt = now;
      await UserProgressRecord.db.updateRow(session, progress);
      return _json(200, {'saved': true});
    }
    if (path == '/sync/state' && request.method == Method.get) {
      final progress = await UserProgressRecord.db.findFirstRow(
        session,
        where: (t) => t.userId.equals(user.id!),
      );
      return _json(200, {
        'route': progress?.activeRoute,
        'state': progress?.activeStateJson == null
            ? null
            : jsonDecode(progress!.activeStateJson!),
        'updatedAt': progress?.updatedAt.toIso8601String(),
      });
    }
    return _error(404, 'Endpoint not found.');
  }

  Future<AppUser?> _authenticatedUser(
    Session session,
    String? authorization,
  ) async {
    final userId = SecurityService.verifyAccessToken(authorization);
    if (userId == null) return null;
    final user = await AppUser.db.findById(session, userId);
    return user == null || user.isDisabled ? null : user;
  }

  Future<Map<String, dynamic>> _userJson(Session session, AppUser user) async {
    final sub = await _activeSubscription(session, user.id!);
    return {
      'id': '${user.id}',
      'email': user.email,
      'username': user.username,
      'targetLanguage': user.targetLanguage,
      'knowledgeLevel': user.knowledgeLevel,
      'role': user.role,
      'adminAccess': _adminAccess(user),
      'isPremium': user.role == 'admin' || sub != null,
      'premiumExpiresAt': sub?.expiresAt.toIso8601String(),
    };
  }

  Future<SubscriptionRecord?> _activeSubscription(
    Session session,
    int userId,
  ) => SubscriptionRecord.db.findFirstRow(
    session,
    where: (t) =>
        t.userId.equals(userId) &
        t.status.equals('active') &
        (t.expiresAt > DateTime.now().toUtc()),
    orderBy: (t) => t.expiresAt,
    orderDescending: true,
  );

  Future<void> _audit(
    Session session,
    int actor,
    String action,
    String targetType,
    String? targetId,
    Map<String, dynamic>? details,
  ) => AdminAuditLogRecord.db
      .insertRow(
        session,
        AdminAuditLogRecord(
          actorUserId: actor,
          action: action,
          targetType: targetType,
          targetId: targetId,
          details: details == null ? null : jsonEncode(details),
          createdAt: DateTime.now().toUtc(),
        ),
      )
      .then((_) {});

  Future<void> _deleteUserData(Session session, int userId) async {
    await RefreshTokenRecord.db.deleteWhere(
      session,
      where: (t) => t.userId.equals(userId),
    );
    await SubscriptionRecord.db.deleteWhere(
      session,
      where: (t) => t.userId.equals(userId),
    );
    await SupportTicketRecord.db.deleteWhere(
      session,
      where: (t) => t.userId.equals(userId),
    );
    await UserLessonRecord.db.deleteWhere(
      session,
      where: (t) => t.userId.equals(userId),
    );
    await UserVocabRecord.db.deleteWhere(
      session,
      where: (t) => t.userId.equals(userId),
    );
    await UserProgressRecord.db.deleteWhere(
      session,
      where: (t) => t.userId.equals(userId),
    );
    await DailyXpRecord.db.deleteWhere(
      session,
      where: (t) => t.userId.equals(userId),
    );
    await AiUsageRecord.db.deleteWhere(
      session,
      where: (t) => t.userId.equals(userId),
    );
  }

  Map<String, dynamic> _ticketJson(SupportTicketRecord ticket) => {
    'id': '${ticket.id}',
    'category': ticket.category,
    'subject': ticket.subject,
    'message': ticket.message,
    'priority': ticket.priority,
    'status': ticket.status,
    'reply': ticket.reply,
    'repliedAt': ticket.repliedAt?.toIso8601String(),
    'createdAt': ticket.createdAt.toIso8601String(),
  };

  Map<String, dynamic> _wordJson(VocabWordRecord word) => {
    'id': word.id,
    'lessonId': word.lessonId,
    'word': word.word,
    'translation': word.translation,
    'audioUrl': word.audioUrl,
    'exampleSentence': word.exampleSentence,
    'exampleTranslation': word.exampleTranslation,
    'partOfSpeech': word.partOfSpeech,
    'ipa': word.ipa,
    'cefrLevel': word.cefrLevel,
    'orderIndex': word.orderIndex,
  };

  Future<UserVocabRecord> _rateWord(
    Session session,
    int userId,
    int wordId,
    int quality,
    DateTime ratedAt,
  ) async {
    final normalizedQuality = quality.clamp(0, 5);
    var review = await UserVocabRecord.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId) & t.vocabWordId.equals(wordId),
    );
    review ??= await UserVocabRecord.db.insertRow(
      session,
      UserVocabRecord(
        userId: userId,
        vocabWordId: wordId,
        updatedAt: ratedAt,
      ),
    );
    if (normalizedQuality < 3) {
      review.repetitions = 0;
      review.intervalDays = 1;
      review.errorCount += 1;
    } else {
      review.intervalDays = review.repetitions == 0
          ? 1
          : review.repetitions == 1
          ? 6
          : (review.intervalDays * review.easinessFactor).round();
      review.repetitions += 1;
      review.easinessFactor =
          (review.easinessFactor +
                  (0.1 -
                      (5 - normalizedQuality) *
                          (0.08 + (5 - normalizedQuality) * 0.02)))
              .clamp(1.3, 3.0);
    }
    review.status = review.repetitions >= 5 ? 'mastered' : 'learning';
    review.nextReviewDate = ratedAt.add(Duration(days: review.intervalDays));
    review.lastReviewedAt = ratedAt;
    review.updatedAt = ratedAt;
    return UserVocabRecord.db.updateRow(session, review);
  }

  Future<Map<String, dynamic>> _stripePost(
    String secret,
    String path,
    Map<String, String> fields,
  ) async {
    final response = await http.post(
      Uri.parse('https://api.stripe.com$path'),
      headers: {
        'authorization': 'Bearer $secret',
        'content-type': 'application/x-www-form-urlencoded',
      },
      body: fields,
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError('Stripe request failed: ${response.body}');
    }
    return Map<String, dynamic>.from(jsonDecode(response.body) as Map);
  }

  void _checkRateLimit(String subject, String bucket, {required int max}) {
    final now = DateTime.now();
    final key = '$bucket:$subject';
    final entries = _rateLimits.putIfAbsent(key, () => []);
    entries.removeWhere(
      (time) => now.difference(time) > const Duration(minutes: 15),
    );
    if (entries.length >= max) {
      throw const _RateLimitException(
        'Too many requests. Please try again later.',
      );
    }
    entries.add(now);
  }

  bool get _testingAdmin =>
      (Platform.environment['TESTING_ADMIN_ACCESS'] ?? 'true').toLowerCase() ==
      'true';
  bool _adminAccess(AppUser user) => _testingAdmin || user.role == 'admin';
  bool _validEmail(String email) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  bool _validPassword(String password) =>
      password.length >= 8 &&
      RegExp('[A-Z]').hasMatch(password) &&
      RegExp('[0-9]').hasMatch(password) &&
      RegExp(r'[^A-Za-z0-9]').hasMatch(password);

  bool _constantTimeEquals(String left, String right) {
    if (left.length != right.length) return false;
    var result = 0;
    for (var i = 0; i < left.length; i++) {
      result |= left.codeUnitAt(i) ^ right.codeUnitAt(i);
    }
    return result == 0;
  }

  Response _json(int status, Object value) => Response(
    status,
    body: Body.fromString(jsonEncode(value), mimeType: MimeType.json),
  );
  Response _error(int status, String message) =>
      _json(status, {'error': message});
}

class _RateLimitException implements Exception {
  const _RateLimitException(this.message);
  final String message;
}
