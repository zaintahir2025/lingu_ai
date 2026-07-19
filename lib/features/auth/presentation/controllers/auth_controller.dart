import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/storage/token_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

enum AuthStatus { initial, unauthenticated, authenticating, authenticated }

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? loginError;
  final String? registerError;
  final String? errorMessage; // kept for backwards compatibility if needed, but we'll use specific ones

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.loginError,
    this.registerError,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? loginError,
    String? registerError,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      loginError: loginError,
      registerError: registerError,
      errorMessage: errorMessage,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final TokenStorage _tokenStorage;

  AuthController(this._repository, this._tokenStorage) : super(const AuthState()) {
    _init();
  }

  Future<void> _init() async {
    final token = _tokenStorage.jwt;
    if (token != null) {
      // In a real app, you would hit the /me endpoint to validate token and get user
      // For now, if token exists, we consider them authenticated.
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: User(id: 'restored', email: 'user@example.com', name: 'User'),
      );
    } else {
      state = state.copyWith(status: AuthStatus.unauthenticated, user: null);
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.authenticating, loginError: null, errorMessage: null);
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        state = state.copyWith(status: AuthStatus.unauthenticated, loginError: 'You are offline. Please connect to the internet to login.');
        return;
      }
      final user = await _repository.login(email, password);
      state = state.copyWith(status: AuthStatus.authenticated, user: user);
    } catch (e) {
      state = state.copyWith(status: AuthStatus.unauthenticated, loginError: e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> register(String email, String password) async {
    state = state.copyWith(status: AuthStatus.authenticating, registerError: null, errorMessage: null);
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        state = state.copyWith(status: AuthStatus.unauthenticated, registerError: 'You are offline. Please connect to the internet to sign up.');
        return;
      }
      await _repository.register(email, password);
      state = state.copyWith(
        status: AuthStatus.unauthenticated, 
        user: null, 
        registerError: 'Registration successful! You can now log in.'
      );
    } catch (e) {
      state = state.copyWith(status: AuthStatus.unauthenticated, registerError: e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    await _tokenStorage.clearTokens();
    state = state.copyWith(status: AuthStatus.unauthenticated, user: null);
  }

  void updateUser(User user) {
    state = state.copyWith(user: user);
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  final tokenStorage = ref.watch(tokenStorageProvider);
  return AuthController(repository, tokenStorage);
});
