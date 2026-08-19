import 'package:flutter_test/flutter_test.dart';
import 'package:lingu_ai/features/auth/domain/registration_availability.dart';

void main() {
  group('registrationConfigurationMessage', () {
    test('allows registration only when both dependencies are configured', () {
      expect(
        registrationConfigurationMessage(
          backendConfigured: true,
          captchaConfigured: true,
        ),
        isNull,
      );
    });

    test('reports both missing dependencies', () {
      expect(
        registrationConfigurationMessage(
          backendConfigured: false,
          captchaConfigured: false,
        ),
        'Registration needs a connected backend and CAPTCHA configuration.',
      );
    });

    test('reports a missing backend', () {
      expect(
        registrationConfigurationMessage(
          backendConfigured: false,
          captchaConfigured: true,
        ),
        'Registration is unavailable because the backend is not configured.',
      );
    });

    test('reports a missing CAPTCHA', () {
      expect(
        registrationConfigurationMessage(
          backendConfigured: true,
          captchaConfigured: false,
        ),
        'Registration is unavailable because CAPTCHA is not configured.',
      );
    });
  });
}
