/// App-wide user preferences. Not seeded from [MockData] — these are local
/// device/app settings, not part of the simulated backend dataset.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppLanguage { en, fr }

extension AppLanguageX on AppLanguage {
  String get code => name;

  String get label {
    switch (this) {
      case AppLanguage.en:
        return 'English';
      case AppLanguage.fr:
        return 'Français';
    }
  }
}

class SettingsState {
  /// KAST-ROLZ ships as a dark-only MVP; the toggle exists for future
  /// light-theme support but defaults to (and is mostly pinned at) `true`.
  final bool darkTheme;
  final AppLanguage language;
  final bool notificationsEnabled;
  final bool privacyPrivateProfile;

  const SettingsState({
    this.darkTheme = true,
    this.language = AppLanguage.en,
    this.notificationsEnabled = true,
    this.privacyPrivateProfile = false,
  });

  SettingsState copyWith({
    bool? darkTheme,
    AppLanguage? language,
    bool? notificationsEnabled,
    bool? privacyPrivateProfile,
  }) {
    return SettingsState(
      darkTheme: darkTheme ?? this.darkTheme,
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      privacyPrivateProfile: privacyPrivateProfile ?? this.privacyPrivateProfile,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() => const SettingsState();

  void toggleDarkTheme() {
    state = state.copyWith(darkTheme: !state.darkTheme);
  }

  void setLanguage(AppLanguage language) {
    state = state.copyWith(language: language);
  }

  void toggleNotifications() {
    state = state.copyWith(notificationsEnabled: !state.notificationsEnabled);
  }

  void togglePrivateProfile() {
    state = state.copyWith(privacyPrivateProfile: !state.privacyPrivateProfile);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);
