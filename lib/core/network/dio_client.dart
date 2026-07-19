import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/token_storage.dart';
import 'auth_interceptor.dart';
import 'e2ee_interceptor.dart';
import 'api_config.dart';

// The expected SHA-256 fingerprint of the server's SSL certificate.
// Replace this with the actual fingerprint of your production SSL cert.
const List<String> pinnedCertificates = [
  'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855', // Dummy Placeholder
];

final dioProvider = Provider<Dio>((ref) {
  final tokenStorage = ref.watch(tokenStorageProvider);
  
  final dio = Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));

  if (!kIsWeb) {
    dio.httpClientAdapter = IOHttpClientAdapter(
      validateCertificate: (cert, host, port) {
        // Skip pinning during local development
        if (host == 'localhost' || host == '10.0.2.2') return true;

        if (cert == null) return false;
        
        // Calculate SHA-256 fingerprint of the certificate
        final digest = sha256.convert(cert.der).toString();
        
        return pinnedCertificates.contains(digest);
      },
    );
  }

  dio.interceptors.add(E2EEInterceptor());
  dio.interceptors.add(AuthInterceptor(tokenStorage, dio));
  
  return dio;
});
