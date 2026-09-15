import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import 'package:lingu_ai/features/auth/domain/repositories/auth_repository.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/api_config.dart';

import '../../../../core/supabase/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

abstract class UserRepository {
  Future<User> updateProfile({
    String? username,
    String? avatarId,
    DateTime? dob,
    String? targetLanguage,
  });
  Future<User> submitSurvey({
    String? knowledgeLevel,
    int? fluencyScore,
    String? targetLanguage,
  });
}

class SupabaseUserRepository implements UserRepository {
  final _supabase = supa.Supabase.instance.client;

  @override
  Future<User> updateProfile({
    String? username,
    String? avatarId,
    DateTime? dob,
    String? targetLanguage,
  }) async {
    final session = _supabase.auth.currentSession;
    if (session == null) throw Exception('Not logged in');

    final updates = <String, dynamic>{};
    if (username != null) updates['username'] = username;
    if (targetLanguage != null) updates['target_language'] = targetLanguage;

    if (updates.isNotEmpty) {
      await _supabase
          .from('profiles')
          .update(updates)
          .eq('id', session.user.id);
    }

    final profile = await _supabase
        .from('profiles')
        .select()
        .eq('id', session.user.id)
        .single();

    return User(
      id: session.user.id,
      email: session.user.email!,
      username: profile['username'],
      targetLanguage: profile['target_language'],
      knowledgeLevel: profile['knowledge_level'],
      role: profile['role'] ?? 'user',
    );
  }

  @override
  Future<User> submitSurvey({
    String? knowledgeLevel,
    int? fluencyScore,
    String? targetLanguage,
  }) async {
    final session = _supabase.auth.currentSession;
    if (session == null) throw Exception('Not logged in');

    final updates = <String, dynamic>{};
    if (knowledgeLevel != null) updates['knowledge_level'] = knowledgeLevel;
    if (targetLanguage != null) updates['target_language'] = targetLanguage;

    if (updates.isNotEmpty) {
      await _supabase
          .from('profiles')
          .update(updates)
          .eq('id', session.user.id);
    }

    final profile = await _supabase
        .from('profiles')
        .select()
        .eq('id', session.user.id)
        .single();

    return User(
      id: session.user.id,
      email: session.user.email!,
      username: profile['username'],
      targetLanguage: profile['target_language'],
      knowledgeLevel: profile['knowledge_level'],
      role: profile['role'] ?? 'user',
    );
  }
}

class UserRepositoryImpl implements UserRepository {
  final Dio _dio;

  UserRepositoryImpl(this._dio);

  @override
  Future<User> updateProfile({
    String? username,
    String? avatarId,
    DateTime? dob,
    String? targetLanguage,
  }) async {
    try {
      final response = await _dio.put(
        '${ApiConfig.baseUrl}/user/profile',
        data: {
          'username': username,
          'avatarId': avatarId,
          'dob': dob?.toIso8601String(),
          'targetLanguage': targetLanguage,
        },
      );
      return User.fromJson(response.data['user']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Failed to update profile');
    }
  }

  @override
  Future<User> submitSurvey({
    String? knowledgeLevel,
    int? fluencyScore,
    String? targetLanguage,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiConfig.baseUrl}/user/survey',
        data: {
          'knowledgeLevel': knowledgeLevel,
          'fluencyScore': fluencyScore,
          'targetLanguage': targetLanguage,
        },
      );
      return User.fromJson(response.data['user']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Failed to submit survey');
    }
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  if (SupabaseConfig.isConfigured) {
    return SupabaseUserRepository();
  }
  return UserRepositoryImpl(ref.watch(dioProvider));
});
