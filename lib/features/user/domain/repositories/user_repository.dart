import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/network/dio_client.dart';
import 'package:lingu_ai/features/auth/domain/repositories/auth_repository.dart';
import 'package:dio/dio.dart';

abstract class UserRepository {
  Future<User> updateProfile({String? username, String? avatarId, DateTime? dob, String? targetLanguage});
  Future<User> submitSurvey({String? knowledgeLevel, int? fluencyScore, String? targetLanguage});
}

class UserRepositoryImpl implements UserRepository {
  final Dio _dio;

  UserRepositoryImpl(this._dio);

  @override
  Future<User> updateProfile({String? username, String? avatarId, DateTime? dob, String? targetLanguage}) async {
    try {
      final response = await _dio.put('/api/user/profile', data: {
        if (username != null) 'username': username,
        if (avatarId != null) 'avatarId': avatarId,
        if (dob != null) 'dob': dob.toIso8601String(),
        if (targetLanguage != null) 'targetLanguage': targetLanguage,
      });
      return User.fromJson(response.data['user']);
    } on DioException catch (e) {
      if (kIsWeb && kReleaseMode) {
        return User(
          id: 'demo_user_123',
          email: 'demo@example.com',
          name: 'Demo User',
          username: username ?? 'DemoUser',
          targetLanguage: targetLanguage,
          knowledgeLevel: 'beginner',
        );
      }
      throw Exception(e.response?.data['error'] ?? 'Failed to update profile');
    }
  }

  @override
  Future<User> submitSurvey({String? knowledgeLevel, int? fluencyScore, String? targetLanguage}) async {
    try {
      final response = await _dio.post('/api/user/survey', data: {
        if (knowledgeLevel != null) 'knowledgeLevel': knowledgeLevel,
        if (fluencyScore != null) 'fluencyScore': fluencyScore,
        if (targetLanguage != null) 'targetLanguage': targetLanguage,
      });
      return User.fromJson(response.data['user']);
    } on DioException catch (e) {
      if (kIsWeb && kReleaseMode) {
        return User(
          id: 'demo_user_123',
          email: 'demo@example.com',
          name: 'Demo User',
          username: 'DemoUser',
          targetLanguage: targetLanguage ?? 'es',
          knowledgeLevel: knowledgeLevel ?? 'beginner',
        );
      }
      throw Exception(e.response?.data['error'] ?? 'Failed to submit survey');
    }
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(ref.watch(dioProvider));
});
