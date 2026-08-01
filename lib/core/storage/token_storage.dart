import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../local_storage/local_storage_provider.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  final box = ref.watch(localStorageProvider);
  return TokenStorage(box, const FlutterSecureStorage());
});

class TokenStorage {
  final Box _box;
  final FlutterSecureStorage _secureStorage;

  static const String _jwtKey = 'jwt_token';
  static const String _refreshKey = 'refresh_token';
  static const String _usernameKey = 'saved_username';

  TokenStorage(this._box, this._secureStorage);

  Future<void> saveTokens({required String jwt, required String refreshToken}) async {
    await _box.put(_jwtKey, jwt);
    await _secureStorage.write(key: _refreshKey, value: refreshToken);
  }

  String? get jwt => _box.get(_jwtKey) as String?;

  Future<String?> get refreshToken async {
    return await _secureStorage.read(key: _refreshKey);
  }

  Future<void> saveUsername(String username) async {
    await _box.put(_usernameKey, username);
  }

  String? get username => _box.get(_usernameKey) as String?;

  Future<void> clearTokens() async {
    await _box.delete(_jwtKey);
    await _box.delete(_usernameKey);
    await _secureStorage.delete(key: _refreshKey);
  }
}
