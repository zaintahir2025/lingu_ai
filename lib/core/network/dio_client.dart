import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/token_storage.dart';
import 'auth_interceptor.dart';

final dioProvider = Provider<Dio>((ref) {
  final tokenStorage = ref.watch(tokenStorageProvider);
  
  final dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:5000', // Temporary for testing
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));

  dio.interceptors.add(AuthInterceptor(tokenStorage, dio));
  
  return dio;
});
