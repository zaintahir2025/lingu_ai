import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../../core/storage/premium_storage.dart';
import '../../../payment/data/payment_repository.dart';

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
    bool clearUser = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
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

  Future<void> _clearPremium() => _ref
      .read(premiumStorageProvider.notifier)
      .applyVerifiedSubscription(active: false);

  Future<void> _syncPremium() async {
    try {
      await _ref.read(paymentRepositoryProvider).refreshSubscription();
    } catch (_) {
      await _clearPremium();
    }
  }

  Future<bool> _hasNetwork() async {
    final results = await Connectivity().checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }

  Future<void> _init() async {
    try {
      final user = await _repository.getCurrentUser();
      await _syncPremium();
      state = state.copyWith(status: AuthStatus.authenticated, user: user);
    } catch (_) {
      await _tokenStorage.clearTokens();
      await _clearPremium();
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        clearUser: true,
      );
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(
      status: AuthStatus.authenticating,
      loginError: null,
      errorMessage: null,
      clearUser: true,
    );

    try {
      if (!await _hasNetwork()) {
        throw Exception('An internet connection is required to sign in.');
      }

      final user = await _repository.login(email.trim(), password);
      await _syncPremium();
      final displayName = user.username ?? user.name ?? email.split('@').first;
      await _tokenStorage.saveUsername(displayName);

      state = state.copyWith(status: AuthStatus.authenticated, user: user);
    } catch (error) {
      await _tokenStorage.clearTokens();
      await _clearPremium();
      final message = error.toString();
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        loginError: message.contains('Invalid login credentials')
            ? 'Invalid email or password.'
            : message.replaceFirst('Exception: ', ''),
        clearUser: true,
      );
    }
  }

  Future<void> register(String email, String password) async {
    state = state.copyWith(
      status: AuthStatus.authenticating,
      registerError: null,
      errorMessage: null,
      clearUser: true,
    );

    try {
      if (!await _hasNetwork()) {
        throw Exception('An internet connection is required to register.');
      }
      await _repository.register(email.trim(), password);

      // Supabase may require email confirmation. Do not create a fake login.
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        registerError: 'Account created. Check your email to verify it, then sign in.',
        clearUser: true,
      );
    } catch (error) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        registerError: error.toString().replaceFirst('Exception: ', ''),
        clearUser: true,
      );
    }
  }

  Future<void> logout() async {
    try {
      await _repository.logout();
    } finally {
      await _tokenStorage.clearTokens();
      await _clearPremium();
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        clearUser: true,
      );
    }
  }

  void updateUser(User user) {
    final nameToSave = user.username ?? user.name ?? 'Learner';
    _tokenStorage.saveUsername(nameToSave);
    state = state.copyWith(user: user);
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(
    ref.watch(authRepositoryProvider),
    ref.watch(tokenStorageProvider),
    ref,
  ),
);
