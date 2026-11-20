import 'package:supabase_flutter/supabase_flutter.dart' hide User;
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

  Future<Map<String, dynamic>> _readProfile(
    SupabaseClient client,
    String userId,
  ) async {
    try {
      final row = await client
          .from('profiles')
          .select('username, target_language, knowledge_level, role')
          .eq('id', userId)
          .maybeSingle();
      if (row != null) return Map<String, dynamic>.from(row);
    } catch (_) {
      // Missing profile is treated as a normal learner with incomplete setup.
    }
    return <String, dynamic>{};
  }

  Future<User> _toAppUser(
    SupabaseClient client,
    dynamic supaUser, {
    required String fallbackEmail,
  }) async {
    final profile = await _readProfile(client, supaUser.id as String);
    final metadata = supaUser.userMetadata;
    final metadataUsername =
        metadata is Map ? metadata['username'] as String? : null;
    final username = profile['username'] is String
        ? profile['username'] as String
        : metadataUsername ?? fallbackEmail.split('@').first;
    final role = profile['role'] == 'admin' ? 'admin' : 'user';

    return User(
      id: supaUser.id as String,
      email: supaUser.email as String? ?? fallbackEmail,
      name: username,
      username: username,
      targetLanguage: profile['target_language'] as String?,
      knowledgeLevel: profile['knowledge_level'] as String?,
      role: role,
      adminAccess: role == 'admin',
    );
  }

  @override
  Future<User> login(String email, String password) async {
    final client = _supabase;
    if (client == null) {
      throw Exception(
        'Supabase is not configured. Set SUPABASE_URL and '
        'SUPABASE_PUBLISHABLE_KEY (or SUPABASE_ANON_KEY).',
      );
    }

    final response = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    final supaUser = response.user;
    final session = response.session;
    if (supaUser == null || session == null) {
      throw Exception('Login did not create an authenticated session.');
    }

    await _tokenStorage.saveTokens(
      jwt: session.accessToken,
      refreshToken: session.refreshToken ?? '',
    );

    return _toAppUser(client, supaUser, fallbackEmail: email);
  }

  @override
  Future<void> register(String email, String password) async {
    final client = _supabase;
    if (client == null) {
      throw Exception(
        'Supabase is not configured. Set SUPABASE_URL and '
        'SUPABASE_PUBLISHABLE_KEY (or SUPABASE_ANON_KEY).',
      );
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

    return _toAppUser(
      client,
      supaUser,
      fallbackEmail: supaUser.email ?? 'user@linguai.local',
    );
  }

  @override
  Future<void> forgotPassword(String email) async {
    final client = _supabase;
    if (client != null) {
      await client.auth.resetPasswordForEmail(email);
    } else {
      throw Exception('Password reset is unavailable until Supabase is configured.');
    }
  }

  @override
  Future<void> resetPassword(String token, String newPassword) async {
    final client = _supabase;
    if (client != null) {
      await client.auth.updateUser(UserAttributes(password: newPassword));
    } else {
      throw Exception('Password reset is unavailable until Supabase is configured.');
    }
  }

  @override
  Future<void> logout() async {
    final client = _supabase;
    if (client != null) {
      await client.auth.signOut();
    }
    await _tokenStorage.clearTokens();
  }
}
