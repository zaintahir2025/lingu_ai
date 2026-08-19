import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../local_storage/local_storage_provider.dart';

final studyGoalStorageProvider = Provider<StudyGoalStorage>((ref) {
  final box = ref.watch(localStorageProvider);
  return StudyGoalStorage(box);
});

class StudyGoalStorage {
  final Box? _boxInstance;
  static const String _dailyGoalKey = 'daily_goal_minutes';
  static const String _weeklyGoalKey = 'weekly_goal_hours';
  static const String _monthlyGoalKey = 'monthly_goal_hours';

  StudyGoalStorage([this._boxInstance]);

  Box? get _box {
    if (_boxInstance != null && _boxInstance.isOpen) return _boxInstance;
    if (Hive.isBoxOpen('lingu_ai_box')) return Hive.box('lingu_ai_box');
    return null;
  }

  int get dailyGoalMinutes =>
      (_box?.get(_dailyGoalKey, defaultValue: 15) as int?) ?? 15;
  int get weeklyGoalHours =>
      (_box?.get(_weeklyGoalKey, defaultValue: 2) as int?) ?? 2;
  int get monthlyGoalHours =>
      (_box?.get(_monthlyGoalKey, defaultValue: 10) as int?) ?? 10;

  Future<void> setDailyGoalMinutes(int minutes) async {
    final box = _box;
    if (box != null) {
      await box.put(_dailyGoalKey, minutes);
    }
  }

  Future<void> setWeeklyGoalHours(int hours) async {
    final box = _box;
    if (box != null) {
      await box.put(_weeklyGoalKey, hours);
    }
  }

  Future<void> setMonthlyGoalHours(int hours) async {
    final box = _box;
    if (box != null) {
      await box.put(_monthlyGoalKey, hours);
    }
  }
}
