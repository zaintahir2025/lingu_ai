import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/repositories/auth_repository.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../../core/supabase/supabase_config.dart';

class SupabaseAuthRepository implements AuthRepository {
  final TokenStorage _tokenStorage;

  SupabaseAuthRepository(this._tokenStorage);

  SupabaseClient? get _supabase {
    try {
      if (SupabaseConfig.isConfigured) {
        return Supabase.instance.client;
      }
    } catch (_) {}
    return null;
  }

  @override
  Future<User> login(String email, String password) async {
    final client = _supabase;
    if (client == null) {
      throw Exception('Supabase is not configured yet. Set SUPABASE_URL & SUPABASE_ANON_KEY.');
    }

    final response = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final supaUser = response.user;
    if (supaUser == null) {
      throw Exception('Login failed: Invalid credentials.');
    }

    if (response.session != null) {
      await _tokenStorage.saveTokens(
        jwt: response.session!.accessToken,
        refreshToken: response.session!.refreshToken ?? '',
      );
    }

    return User(
      id: supaUser.id,
      email: supaUser.email ?? email,
      name: supaUser.userMetadata?['username'] ?? email.split('@').first,
      username: supaUser.userMetadata?['username'] ?? email.split('@').first,
      role: supaUser.userMetadata?['role'] ?? 'user',
      adminAccess: supaUser.userMetadata?['role'] == 'admin',
    );
  }

  @override
  Future<void> register(String email, String password) async {
    final client = _supabase;
    if (client == null) {
      throw Exception('Supabase is not configured yet. Set SUPABASE_URL & SUPABASE_ANON_KEY.');
    }

    final response = await client.auth.signUp(
      email: email,
      password: password,
      data: {'username': email.split('@').first},
    );

    if (response.user == null) {
      throw Exception('Registration failed.');
    }
  }

  @override
  Future<User> getCurrentUser() async {
    final client = _supabase;
    final supaUser = client?.auth.currentUser;
    if (client == null || supaUser == null) {
      throw Exception('No authenticated user session.');
    }

    return User(
      id: supaUser.id,
      email: supaUser.email ?? 'user@linguai.local',
      name: supaUser.userMetadata?['username'] ?? supaUser.email?.split('@').first ?? 'Learner',
      username: supaUser.userMetadata?['username'] ?? supaUser.email?.split('@').first ?? 'Learner',
      role: supaUser.userMetadata?['role'] ?? 'user',
      adminAccess: supaUser.userMetadata?['role'] == 'admin',
    );
  }

  @override
  Future<void> forgotPassword(String email) async {
    final client = _supabase;
    if (client != null) {
      await client.auth.resetPasswordForEmail(email);
    }
  }

  @override
  Future<void> resetPassword(String token, String newPassword) async {
    final client = _supabase;
    if (client != null) {
      await client.auth.updateUser(UserAttributes(password: newPassword));
    }
  }

  @override
  Future<void> logout() async {
    final client = _supabase;
    if (client != null) {
      try {
        await client.auth.signOut();
      } catch (_) {}
    }
    await _tokenStorage.clearTokens();
  }
}
