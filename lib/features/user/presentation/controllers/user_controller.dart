import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingu_ai/features/user/domain/repositories/user_repository.dart';
import 'package:lingu_ai/features/auth/presentation/controllers/auth_controller.dart';
class UserState {
  final bool isLoading;
  final String? error;

  const UserState({this.isLoading = false, this.error});
}

class UserController extends StateNotifier<UserState> {
  final UserRepository _repository;
  final Ref _ref;

  UserController(this._repository, this._ref) : super(const UserState());

  Future<void> updateProfile({String? username, String? avatarId, DateTime? dob, String? targetLanguage}) async {
    state = const UserState(isLoading: true);
    try {
      final user = await _repository.updateProfile(username: username, avatarId: avatarId, dob: dob, targetLanguage: targetLanguage);
      _ref.read(authControllerProvider.notifier).updateUser(user);
      state = const UserState(isLoading: false);
    } catch (e) {
      state = UserState(isLoading: false, error: e.toString().replaceAll('Exception: ', ''));
      rethrow;
    }
  }

  Future<void> submitSurvey({String? knowledgeLevel, int? fluencyScore, String? targetLanguage}) async {
    state = const UserState(isLoading: true);
    try {
      final user = await _repository.submitSurvey(
        knowledgeLevel: knowledgeLevel,
        fluencyScore: fluencyScore,
        targetLanguage: targetLanguage,
      );
      _ref.read(authControllerProvider.notifier).updateUser(user);
      state = const UserState(isLoading: false);
    } catch (e) {
      state = UserState(isLoading: false, error: e.toString().replaceAll('Exception: ', ''));
      rethrow;
    }
  }
}

final userControllerProvider = StateNotifierProvider<UserController, UserState>((ref) {
  return UserController(ref.watch(userRepositoryProvider), ref);
});
