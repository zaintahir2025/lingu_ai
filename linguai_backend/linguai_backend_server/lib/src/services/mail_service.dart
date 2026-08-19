import 'dart:io';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class MailService {
  MailService._();

  static Future<void> sendVerification(String email, String token) async {
    final apiUrl =
        Platform.environment['PUBLIC_API_URL'] ??
        'http://localhost:3000/api/v1';
    await _send(
      email,
      'Verify your LinguAI account',
      '<h2>Welcome to LinguAI!</h2><p>Verify your email to start learning.</p>'
          '<p><a href="$apiUrl/auth/verify-email?token=$token">Verify email</a></p>',
    );
  }

  static Future<void> sendPasswordReset(String email, String token) async {
    final appUrl =
        Platform.environment['PUBLIC_APP_URL'] ?? 'http://localhost:3000';
    await _send(
      email,
      'Reset your LinguAI password',
      '<h2>Password reset</h2><p>Use the link below within one hour.</p>'
          '<p><a href="$appUrl/#/auth/reset-password?token=$token">Reset password</a></p>',
    );
  }

  static Future<void> _send(
    String recipient,
    String subject,
    String html,
  ) async {
    final host = Platform.environment['SMTP_HOST'];
    final username = Platform.environment['SMTP_USER'];
    final password = Platform.environment['SMTP_PASS'];
    final from = Platform.environment['MAIL_FROM'];
    if (host == null || username == null || password == null || from == null) {
      if ((Platform.environment['SERVERPOD_RUN_MODE'] ?? 'development') ==
          'production') {
        throw StateError('SMTP is not configured.');
      }
      stderr.writeln('[Mail preview] $subject -> $recipient\n$html');
      return;
    }
    final port = int.tryParse(Platform.environment['SMTP_PORT'] ?? '') ?? 587;
    final server = SmtpServer(
      host,
      port: port,
      username: username,
      password: password,
      ssl: port == 465,
      allowInsecure: false,
    );
    final message = Message()
      ..from = Address(from, 'LinguAI')
      ..recipients.add(recipient)
      ..subject = subject
      ..html = html;
    await send(message, server);
  }
}
