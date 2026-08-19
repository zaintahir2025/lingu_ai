import 'package:flutter/foundation.dart';

class ApiConfig {
  static const _environmentUrl = String.fromEnvironment('API_URL');

  /// Whether this build points at a separately deployed LinguAI API.
  ///
  /// The UI must remain bootable without a backend so that static hosts such
  /// as GitHub Pages can show onboarding and offline learning content.
  static bool get isConfigured => _environmentUrl.trim().isNotEmpty;

  static String get baseUrl {
    final envUrl = _environmentUrl.trim();
    if (envUrl.isNotEmpty) {
      if (kReleaseMode && envUrl.startsWith('http://')) {
        return envUrl.replaceFirst('http://', 'https://');
      }
      return envUrl;
    }

    if (kReleaseMode && kIsWeb) {
      return '${Uri.base.origin}/api/v1';
    }
    if (kReleaseMode) {
      // `.invalid` is reserved and can never resolve. Requests fail normally
      // through Dio instead of crashing the application before its first
      // frame when a static/demo build has no API configured yet.
      return 'https://api.linguai.invalid/api/v1';
    }

    if (kIsWeb) return 'http://localhost:3000/api/v1';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000/api/v1';
    }
    return 'http://localhost:3000/api/v1';
  }
}
