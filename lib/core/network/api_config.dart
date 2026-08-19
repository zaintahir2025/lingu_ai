import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl {
    const envUrl = String.fromEnvironment('API_URL');
    if (envUrl.isNotEmpty) {
      if (kReleaseMode && envUrl.startsWith('http://')) {
        return envUrl.replaceFirst('http://', 'https://');
      }
      return envUrl;
    }

    if (kReleaseMode) {
      throw StateError(
        'API_URL is required for release builds. Pass the deployed HTTPS API base with --dart-define.',
      );
    }

    if (kIsWeb) return 'http://localhost:3000/api/v1';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000/api/v1';
    }
    return 'http://localhost:3000/api/v1';
  }
}
