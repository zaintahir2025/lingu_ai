import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../local_storage/local_storage_provider.dart';

final heartSettingsStorageProvider = Provider<HeartSettingsStorage>((ref) {
  final box = ref.watch(localStorageProvider);
  return HeartSettingsStorage(box);
});

class HeartSettingsStorage {
  final Box? _boxInstance;
  static const String _heartsModeKey = 'hearts_mode'; // 'unlimited' vs 'challenge'

  HeartSettingsStorage([this._boxInstance]);

  Box? get _box {
    if (_boxInstance != null && _boxInstance.isOpen) return _boxInstance;
    if (Hive.isBoxOpen('lingu_ai_box')) return Hive.box('lingu_ai_box');
    return null;
  }

  /// Default is 'unlimited' for beginner friendliness
  bool get isUnlimitedMode {
    final mode = (_box?.get(_heartsModeKey, defaultValue: 'unlimited') as String?) ?? 'unlimited';
    return mode == 'unlimited';
  }

  String get heartsMode => (_box?.get(_heartsModeKey, defaultValue: 'unlimited') as String?) ?? 'unlimited';

  Future<void> setHeartsMode(String mode) async {
    final box = _box;
    if (box != null) {
      await box.put(_heartsModeKey, mode);
    }
  }
}
