import 'dart:async';
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
        await _tokenStorage.clearTokens();
        state = state.copyWith(status: AuthStatus.unauthenticated, user: null);
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
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          loginError:
              'You are offline. Please connect to the internet to login.',
        );
        return;
      }
      final user = await _repository.login(email, password);
      await _syncPremium();
      final savedName =
          _tokenStorage.username ??
          user.username ??
          user.name ??
          email.split('@').first;
      final updatedUser = User(
        id: user.id,
        email: user.email,
        name: savedName,
        username: savedName,
        targetLanguage: user.targetLanguage,
        knowledgeLevel: user.knowledgeLevel,
        role: user.role,
        adminAccess: user.adminAccess,
      );
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: updatedUser,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        loginError: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> register(
    String email,
    String password,
    String turnstileToken,
  ) async {
    state = state.copyWith(
      status: AuthStatus.authenticating,
      registerError: null,
      errorMessage: null,
    );
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          registerError:
              'You are offline. Please connect to the internet to sign up.',
        );
        return;
      }
      await _repository.register(
        email,
        password,
        turnstileToken: turnstileToken,
      );
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
        registerError:
            'Registration successful! Check your email to verify the account before logging in.',
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        registerError: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> logout() async {
    await _repository.logout();
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
