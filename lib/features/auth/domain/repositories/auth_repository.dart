import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../../core/storage/onboarding_storage.dart';
import '../../../../core/network/api_config.dart';
import '../../../../core/network/dio_client.dart';

class User {
  final String id;
  final String email;
  final String? name;
  final String? username;
  final String? targetLanguage;
  final String? knowledgeLevel;

  User({
    required this.id, 
    required this.email, 
    this.name, 
    this.username, 
    this.targetLanguage, 
    this.knowledgeLevel,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      email: json['email'],
      name: json['name'],
      username: json['username'],
      targetLanguage: json['targetLanguage'],
      knowledgeLevel: json['knowledgeLevel'],
    );
  }
}

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<void> register(String email, String password);
  Future<void> forgotPassword(String email);
  Future<void> resetPassword(String token, String newPassword);
  Future<void> logout();
}

class NodeAuthRepository implements AuthRepository {
  final Dio _dio;
  final TokenStorage _storage;
  final OnboardingStorage _onboardingStorage;
  
  static String get baseUrl => '${ApiConfig.baseUrl}/auth';

  NodeAuthRepository(this._storage, this._onboardingStorage, this._dio);

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await _dio.post('$baseUrl/login', data: {
        'email': email.trim(),
        'password': password,
      });

      final token = response.data['token'];
      final refreshToken = response.data['refreshToken'];

      await _storage.saveTokens(jwt: token, refreshToken: refreshToken);

      final user = User.fromJson(response.data['user']);
      
      if (user.targetLanguage != null) {
        await _onboardingStorage.setTargetLanguage(user.targetLanguage!);
      }

      return user;
    } on DioException catch (e) {
      debugPrint('Login API Error [${e.response?.statusCode}]: ${e.response?.data}');
      debugPrint('DioException Details: message=${e.message}, type=${e.type}, error=${e.error}');
      throw Exception(e.response?.data['error'] ?? 'Login failed');
    }
  }

  @override
  Future<void> register(String email, String password) async {
    try {
      await _dio.post('$baseUrl/register', data: {
        'email': email,
        'password': password,
      });
    } on DioException catch (e) {
      debugPrint('Register API Error [${e.response?.statusCode}]: ${e.response?.data}');
      throw Exception(e.response?.data['error'] ?? 'Registration failed');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _dio.post('$baseUrl/forgot-password', data: {
        'email': email,
      });
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Failed to send reset email');
    }
  }

  @override
  Future<void> resetPassword(String token, String newPassword) async {
    try {
      await _dio.post('$baseUrl/reset-password', data: {
        'token': token,
        'newPassword': newPassword,
      });
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Failed to reset password');
    }
  }

  @override
  Future<void> logout() async {
    final refreshToken = await _storage.refreshToken;
    if (refreshToken != null) {
      try {
        await _dio.post('$baseUrl/logout', data: {
          'refreshToken': refreshToken,
          'allDevices': false,
        });
      } catch (e) {
        // ignore errors on logout network call
      }
    }
    await _storage.clearTokens();
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final tokenStorage = ref.watch(tokenStorageProvider);
  final onboardingStorage = ref.watch(onboardingStorageProvider);
  final dio = ref.watch(dioProvider);
  return NodeAuthRepository(tokenStorage, onboardingStorage, dio);
});
