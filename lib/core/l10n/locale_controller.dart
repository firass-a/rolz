import 'package:flutter/material.dart';

/// Holds the active UI language. Updated by [SettingsNotifier] / language screen.
abstract final class LocaleController {
  static Locale _locale = const Locale('en');
  static bool get isArabic => _locale.languageCode == 'ar';
  static Locale get locale => _locale;
  static void setLocale(Locale locale) => _locale = locale;
  static void setArabic(bool arabic) => _locale = Locale(arabic ? 'ar' : 'en');
}
