import 'package:flutter_test/flutter_test.dart';
import 'package:lingu_ai/features/auth/domain/registration_availability.dart';

void main() {
  group('registrationConfigurationMessage', () {
    test('allows registration when the backend is configured', () {
      expect(registrationConfigurationMessage(backendConfigured: true), isNull);
    });

    test('always allows registration regardless of backend configuration', () {
      expect(
        registrationConfigurationMessage(backendConfigured: false),
        isNull,
      );
    });
  });
}
