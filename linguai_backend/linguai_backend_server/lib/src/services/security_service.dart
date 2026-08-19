import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class SecurityService {
  SecurityService._();

  static String get _jwtSecret {
    const fallback = 'development-only-change-me-linguai-serverpod-secret';
    final configured = Platform.environment['JWT_SECRET'];
    final runMode = Platform.environment['SERVERPOD_RUN_MODE'] ?? 'development';
    if (configured == null || configured.length < 32) {
      if (runMode == 'production') {
        throw StateError('JWT_SECRET must contain at least 32 characters.');
      }
      return fallback;
    }
    return configured;
  }

  static String randomToken([int bytes = 48]) {
    final random = Random.secure();
    return base64Url
        .encode(List<int>.generate(bytes, (_) => random.nextInt(256)))
        .replaceAll('=', '');
  }

  static String hashToken(String token) =>
      sha256.convert(utf8.encode(token)).toString();

  static String createAccessToken(int userId) =>
      JWT(
        {'userId': userId},
        issuer: 'linguai-serverpod',
      ).sign(
        SecretKey(_jwtSecret),
        expiresIn: const Duration(minutes: 15),
      );

  static int? verifyAccessToken(String? authorization) {
    if (authorization == null || !authorization.startsWith('Bearer ')) {
      return null;
    }
    try {
      final jwt = JWT.verify(authorization.substring(7), SecretKey(_jwtSecret));
      final value = jwt.payload['userId'];
      return value is int ? value : int.tryParse('$value');
    } catch (_) {
      return null;
    }
  }
}
