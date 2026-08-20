import 'package:flutter_test/flutter_test.dart';
import 'package:lingu_ai/features/auth/domain/registration_availability.dart';

void main() {
  group('registrationConfigurationMessage', () {
    test('allows registration when the backend is configured', () {
      expect(registrationConfigurationMessage(backendConfigured: true), isNull);
    });

    test('reports a missing backend', () {
      expect(
        registrationConfigurationMessage(backendConfigured: false),
        'Registration is unavailable because the backend is not configured.',
      );
    });
  });
}
