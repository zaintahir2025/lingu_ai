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
  final String role;
  final bool adminAccess;

  User({
    required this.id,
    required this.email,
    this.name,
    this.username,
    this.targetLanguage,
    this.knowledgeLevel,
    this.role = 'user',
    this.adminAccess = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      email: json['email'],
      name: json['name'],
      username: json['username'],
      targetLanguage: json['targetLanguage'],
      knowledgeLevel: json['knowledgeLevel'],
      role: json['role'] is String ? json['role'] as String : 'user',
      adminAccess: json['adminAccess'] == true || json['role'] == 'admin',
    );
  }
}

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> getCurrentUser();
  Future<void> register(String email, String password);
  Future<void> forgotPassword(String email);
  Future<void> resetPassword(String token, String newPassword);
  Future<void> logout();
}

class DartAuthRepository implements AuthRepository {
  final Dio _dio;
  final TokenStorage _storage;
  final OnboardingStorage _onboardingStorage;

  static String get baseUrl => '${ApiConfig.baseUrl}/auth';

  DartAuthRepository(this._storage, this._onboardingStorage, this._dio);

  String _dioErrorMessage(DioException error, String fallback) {
    final data = error.response?.data;
    if (data is Map && data['error'] is String) {
      return data['error'] as String;
    }
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }

    switch (error.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        if (kDebugMode && ApiConfig.baseUrl.contains('localhost')) {
          return 'The local authentication server is not running. Start the backend on port 3000, then try again.';
        }
        return 'The authentication service is temporarily unavailable. Check your connection and try again.';
      case DioExceptionType.badResponse:
        if (error.response?.statusCode == 404) {
          return 'The authentication endpoint was not found. Check the API_URL configuration.';
        }
        return fallback;
      case DioExceptionType.cancel:
        return 'The request was cancelled.';
      case DioExceptionType.badCertificate:
        return 'Could not verify the authentication server certificate.';
      case DioExceptionType.unknown:
        return fallback;
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '$baseUrl/login',
        data: {'email': email.trim(), 'password': password},
      );

      final token = response.data['token'];
      final refreshToken = response.data['refreshToken'];

      await _storage.saveTokens(jwt: token, refreshToken: refreshToken);

      final user = User.fromJson(response.data['user']);

      if (user.targetLanguage != null) {
        await _onboardingStorage.setTargetLanguage(user.targetLanguage!);
      }

      return user;
    } on DioException catch (e) {
      debugPrint(
        'Login API Error [${e.response?.statusCode}]: ${e.response?.data}',
      );
      debugPrint(
        'DioException Details: message=${e.message}, type=${e.type}, error=${e.error}',
      );

      throw Exception(_dioErrorMessage(e, 'Login failed. Please try again.'));
    }
  }

  @override
  Future<User> getCurrentUser() async {
    try {
      final response = await _dio.get('$baseUrl/me');
      final data = response.data;
      if (data is! Map || data['user'] is! Map) {
        throw const FormatException('Invalid account response');
      }
      return User.fromJson(Map<String, dynamic>.from(data['user'] as Map));
    } on DioException catch (e) {
      throw Exception(_dioErrorMessage(e, 'Could not restore your session.'));
    }
  }

  @override
  Future<void> register(String email, String password) async {
    try {
      await _dio.post(
        '$baseUrl/register',
        data: {'email': email, 'password': password, 'ageConfirmed': true},
      );
    } on DioException catch (e) {
      debugPrint(
        'Register API Error [${e.response?.statusCode}]: ${e.response?.data}',
      );

      throw Exception(
        _dioErrorMessage(e, 'Registration failed. Please try again.'),
      );
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _dio.post('$baseUrl/forgot-password', data: {'email': email});
    } on DioException catch (e) {
      throw Exception(_dioErrorMessage(e, 'Failed to send the reset email.'));
    }
  }

  @override
  Future<void> resetPassword(String token, String newPassword) async {
    try {
      await _dio.post(
        '$baseUrl/reset-password',
        data: {'token': token, 'newPassword': newPassword},
      );
    } on DioException catch (e) {
      throw Exception(_dioErrorMessage(e, 'Failed to reset the password.'));
    }
  }

  @override
  Future<void> logout() async {
    final refreshToken = await _storage.refreshToken;
    if (refreshToken != null) {
      try {
        await _dio.post(
          '$baseUrl/logout',
          data: {'refreshToken': refreshToken, 'allDevices': false},
        );
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
  return DartAuthRepository(tokenStorage, onboardingStorage, dio);
});
