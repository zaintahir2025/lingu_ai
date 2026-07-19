import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl {
    const envUrl = String.fromEnvironment('API_URL');
    if (envUrl.isNotEmpty) {
      // Force HTTPS in production even if env was misconfigured
      if (kReleaseMode && envUrl.startsWith('http://')) {
        return envUrl.replaceFirst('http://', 'https://');
      }
      return envUrl;
    }
    
    if (kReleaseMode) {
      // Secure default for production builds
      return 'https://api.linguai.com/api';
    }

    if (kIsWeb) return 'http://localhost:3000/api';
    if (defaultTargetPlatform == TargetPlatform.android) return 'http://10.0.2.2:3000/api';
    return 'http://localhost:3000/api';
  }
}
