import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsState {
  final bool notificationsEnabled;
  final bool soundEnabled;

  const SettingsState({
    this.notificationsEnabled = true,
    this.soundEnabled = true,
  });

  SettingsState copyWith({
    bool? notificationsEnabled,
    bool? soundEnabled,
  }) {
    return SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() {
    // In a real app we would load from SharedPreferences here
    return const SettingsState();
  }

  void toggleNotifications(bool value) {
    state = state.copyWith(notificationsEnabled: value);
  }

  void toggleSound(bool value) {
    state = state.copyWith(soundEnabled: value);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(() {
  return SettingsNotifier();
});
