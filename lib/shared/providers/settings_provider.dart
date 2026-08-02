/// App-wide user preferences with SharedPreferences persistence for language.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_strings.dart';
import '../../core/l10n/locale_controller.dart';

enum AppLanguage { en, ar }

extension AppLanguageX on AppLanguage {
  String get code => name;

  Locale get locale => Locale(code);

  String get label {
    switch (this) {
      case AppLanguage.en:
        return AppStrings.languageEnglish;
      case AppLanguage.ar:
        return AppStrings.languageArabic;
    }
  }
}

class SettingsState {
  final bool darkTheme;
  final AppLanguage language;
  final bool hasChosenLanguage;
  final bool notificationsEnabled;
  final bool privacyPrivateProfile;
  final bool hydrated;

  const SettingsState({
    this.darkTheme = true,
    this.language = AppLanguage.en,
    this.hasChosenLanguage = false,
    this.notificationsEnabled = true,
    this.privacyPrivateProfile = false,
    this.hydrated = false,
  });

  SettingsState copyWith({
    bool? darkTheme,
    AppLanguage? language,
    bool? hasChosenLanguage,
    bool? notificationsEnabled,
    bool? privacyPrivateProfile,
    bool? hydrated,
  }) {
    return SettingsState(
      darkTheme: darkTheme ?? this.darkTheme,
      language: language ?? this.language,
      hasChosenLanguage: hasChosenLanguage ?? this.hasChosenLanguage,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      privacyPrivateProfile: privacyPrivateProfile ?? this.privacyPrivateProfile,
      hydrated: hydrated ?? this.hydrated,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  static const _kLanguage = 'app_language';
  static const _kChosen = 'has_chosen_language';
  static const _kNotifications = 'notifications_enabled';
  static const _kPrivate = 'privacy_private_profile';

  @override
  SettingsState build() {
    Future.microtask(hydrate);
    return const SettingsState();
  }

  Future<void> hydrate() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_kLanguage) ?? 'en';
    final language = code == 'ar' ? AppLanguage.ar : AppLanguage.en;
    // Language picker is session-scoped: always re-prompt after app restart.
    await prefs.remove(_kChosen);
    LocaleController.setLocale(language.locale);
    state = SettingsState(
      language: language,
      hasChosenLanguage: false,
      notificationsEnabled: prefs.getBool(_kNotifications) ?? true,
      privacyPrivateProfile: prefs.getBool(_kPrivate) ?? false,
      hydrated: true,
    );
  }

  Future<void> setLanguage(AppLanguage language, {bool markChosen = true}) async {
    LocaleController.setLocale(language.locale);
    state = state.copyWith(
      language: language,
      hasChosenLanguage: markChosen ? true : state.hasChosenLanguage,
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLanguage, language.code);
    // Do not persist "chosen" — restart always shows the language screen again.
  }

  Future<void> chooseLanguage(AppLanguage language) => setLanguage(language, markChosen: true);

  void toggleDarkTheme() {
    state = state.copyWith(darkTheme: !state.darkTheme);
  }

  Future<void> toggleNotifications() async {
    final next = !state.notificationsEnabled;
    state = state.copyWith(notificationsEnabled: next);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kNotifications, next);
  }

  Future<void> togglePrivateProfile() async {
    final next = !state.privacyPrivateProfile;
    state = state.copyWith(privacyPrivateProfile: next);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kPrivate, next);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);
