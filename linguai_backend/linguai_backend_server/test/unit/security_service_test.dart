import 'package:linguai_backend_server/src/services/security_service.dart';
import 'package:test/test.dart';

void main() {
  group('SecurityService', () {
    test('issues and verifies an access token', () {
      final token = SecurityService.createAccessToken(42);
      expect(SecurityService.verifyAccessToken('Bearer $token'), 42);
      expect(SecurityService.verifyAccessToken(token), isNull);
      expect(SecurityService.verifyAccessToken('Bearer invalid'), isNull);
    });

    test('creates unique URL-safe refresh tokens and hashes them', () {
      final first = SecurityService.randomToken();
      final second = SecurityService.randomToken();
      expect(first, isNot(second));
      expect(first, isNot(contains('=')));
      expect(SecurityService.hashToken(first), hasLength(64));
      expect(SecurityService.hashToken(first), isNot(first));
    });
  });
}
