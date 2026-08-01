import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../local_storage/local_storage_provider.dart';

final userRegistryStorageProvider = Provider<UserRegistryStorage>((ref) {
  final box = ref.watch(localStorageProvider);
  return UserRegistryStorage(box);
});

class RegisteredUserAccount {
  final String id;
  final String email;
  final String username;
  final String registeredAt;
  final bool isPremium;
  final String? premiumExpiryDate;

  RegisteredUserAccount({
    required this.id,
    required this.email,
    required this.username,
    required this.registeredAt,
    required this.isPremium,
    this.premiumExpiryDate,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'username': username,
        'registeredAt': registeredAt,
        'isPremium': isPremium,
        'premiumExpiryDate': premiumExpiryDate,
      };

  factory RegisteredUserAccount.fromJson(Map<String, dynamic> json) => RegisteredUserAccount(
        id: json['id'] ?? 'usr_1',
        email: json['email'] ?? 'learner@linguai.com',
        username: json['username'] ?? 'Learner',
        registeredAt: json['registeredAt'] ?? '2026-08-01',
        isPremium: json['isPremium'] ?? false,
        premiumExpiryDate: json['premiumExpiryDate'],
      );

  RegisteredUserAccount copyWith({
    bool? isPremium,
    String? premiumExpiryDate,
    String? username,
  }) {
    return RegisteredUserAccount(
      id: id,
      email: email,
      username: username ?? this.username,
      registeredAt: registeredAt,
      isPremium: isPremium ?? this.isPremium,
      premiumExpiryDate: premiumExpiryDate ?? this.premiumExpiryDate,
    );
  }
}

class UserRegistryStorage {
  final Box _box;
  static const String _userRegistryKey = 'user_registry_accounts_v1';

  UserRegistryStorage(this._box);

  List<RegisteredUserAccount> getAllUsers() {
    final raw = _box.get(_userRegistryKey) as String?;
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> decoded = jsonDecode(raw);
      return decoded.map((item) => RegisteredUserAccount.fromJson(Map<String, dynamic>.from(item))).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveUsers(List<RegisteredUserAccount> users) async {
    final jsonStr = jsonEncode(users.map((u) => u.toJson()).toList());
    await _box.put(_userRegistryKey, jsonStr);
  }

  Future<void> registerOrUpdateUser(RegisteredUserAccount user) async {
    final list = getAllUsers();
    final index = list.indexWhere((u) => u.id == user.id || u.email == user.email);
    if (index >= 0) {
      list[index] = user;
    } else {
      list.add(user);
    }
    await saveUsers(list);
  }

  Future<void> setPremiumStatus(String email, bool isPremium) async {
    final list = getAllUsers();
    final index = list.indexWhere((u) => u.email.toLowerCase() == email.toLowerCase());
    final expiry = isPremium ? DateTime.now().add(const Duration(days: 30)).toIso8601String() : null;

    if (index >= 0) {
      list[index] = list[index].copyWith(isPremium: isPremium, premiumExpiryDate: expiry);
      await saveUsers(list);
    }
  }
}
