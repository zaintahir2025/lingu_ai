import 'package:flutter_riverpod/flutter_riverpod.dart';

class User {
  final String id;
  final String email;
  final String name;
  User({required this.id, required this.email, required this.name});
}

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(String email, String password, String name);
  Future<void> forgotPassword(String email);
  Future<void> resetPassword(String token, String newPassword);
}

class MockAuthRepository implements AuthRepository {
  @override
  Future<User> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'error@test.com') throw Exception('Invalid credentials');
    return User(id: '1', email: email, name: 'Test User');
  }

  @override
  Future<User> register(String email, String password, String name) async {
    await Future.delayed(const Duration(seconds: 1));
    return User(id: '1', email: email, name: name);
  }

  @override
  Future<void> forgotPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> resetPassword(String token, String newPassword) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return MockAuthRepository();
});
