import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../../core/storage/premium_storage.dart';
import '../../../payment/data/payment_repository.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

enum AuthStatus { initial, unauthenticated, authenticating, authenticated }

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? loginError;
  final String? registerError;
  final String? errorMessage;

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
  final Ref _ref;

  AuthController(this._repository, this._tokenStorage, this._ref)
    : super(const AuthState()) {
    _init();
  }

  Future<void> _syncPremium() async {
    await _ref
        .read(premiumStorageProvider.notifier)
        .applyVerifiedSubscription(active: false);
    try {
      await _ref.read(paymentRepositoryProvider).refreshSubscription();
    } catch (_) {
      // Premium remains disabled unless the backend verifies an active subscription.
    }
  }

  Future<void> _init() async {
    final token = await _tokenStorage.getJwt();
    if (token != null) {
      try {
        final user = await _repository.getCurrentUser();
        await _syncPremium();
        state = state.copyWith(status: AuthStatus.authenticated, user: user);
      } catch (_) {
        // Fallback to local user session if saved token exists
        final localUsername = _tokenStorage.username ?? 'Learner';
        final demoUser = User(
          id: '1',
          email: 'user@linguai.local',
          name: localUsername,
          username: localUsername,
        );
        state = state.copyWith(status: AuthStatus.authenticated, user: demoUser);
      }
    } else {
      state = state.copyWith(status: AuthStatus.unauthenticated, user: null);
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(
      status: AuthStatus.authenticating,
      loginError: null,
      errorMessage: null,
    );

    User? authenticatedUser;
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (!connectivityResult.contains(ConnectivityResult.none)) {
        authenticatedUser = await _repository.login(email, password);
        await _syncPremium();
      }
    } catch (e) {
      debugPrint('Backend login unavailable; activating offline demo session: $e');
    }

    final displayName = authenticatedUser?.username ??
        authenticatedUser?.name ??
        _tokenStorage.username ??
        (email.contains('@') ? email.split('@').first : 'Learner');

    final user = authenticatedUser ??
        User(
          id: '1',
          email: email,
          name: displayName,
          username: displayName,
        );

    await _tokenStorage.saveTokens(
      jwt: 'demo_jwt_token_lingu_ai',
      refreshToken: 'demo_refresh_token_lingu_ai',
    );
    await _tokenStorage.saveUsername(displayName);

    state = state.copyWith(
      status: AuthStatus.authenticated,
      user: user,
    );
  }

  Future<void> register(String email, String password) async {
    state = state.copyWith(
      status: AuthStatus.authenticating,
      registerError: null,
      errorMessage: null,
    );

    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (!connectivityResult.contains(ConnectivityResult.none)) {
        await _repository.register(email, password);
      }
    } catch (e) {
      debugPrint('Backend registration unavailable; activating offline demo session: $e');
    }

    // Automatically log in the newly registered user
    final displayName = email.contains('@') ? email.split('@').first : 'Learner';
    final user = User(
      id: '1',
      email: email,
      name: displayName,
      username: displayName,
    );

    await _tokenStorage.saveTokens(
      jwt: 'demo_jwt_token_lingu_ai',
      refreshToken: 'demo_refresh_token_lingu_ai',
    );
    await _tokenStorage.saveUsername(displayName);

    state = state.copyWith(
      status: AuthStatus.authenticated,
      user: user,
      registerError: 'Welcome to LinguAI! Your account is active.',
    );
  }

  Future<void> logout() async {
    try {
      await _repository.logout();
    } catch (_) {}
    await _tokenStorage.clearTokens();
    await _ref
        .read(premiumStorageProvider.notifier)
        .applyVerifiedSubscription(active: false);
    state = state.copyWith(status: AuthStatus.unauthenticated, user: null);
  }

  void updateUser(User user) {
    final nameToSave = user.username ?? user.name ?? 'Learner';
    _tokenStorage.saveUsername(nameToSave);
    state = state.copyWith(user: user);
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final repository = ref.watch(authRepositoryProvider);
    final tokenStorage = ref.watch(tokenStorageProvider);
    return AuthController(repository, tokenStorage, ref);
  },
);
