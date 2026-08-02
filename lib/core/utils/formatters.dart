import 'package:intl/intl.dart';

import '../constants/app_strings.dart';

/// Small, dependency-free formatting helpers shared across every screen
/// that displays talent, casting or agency data.
///
/// Number/date digits always stay Latin (en patterns). Word labels go through
/// [AppStrings] so they follow the active language.
abstract final class Formatters {
  static final NumberFormat _compactCurrency = NumberFormat.compactCurrency(
    locale: 'en',
    decimalDigits: 0,
    symbol: '',
  );

  static final NumberFormat _thousands = NumberFormat.decimalPattern('en');

  /// Formats a salary/budget value with a currency code, e.g.
  /// `formatSalary(150000, currency: 'DZD')` -> "150,000 DZD".
  static String formatSalary(
    num? amount, {
    String currency = 'DZD',
    bool compact = false,
  }) {
    if (amount == null) return AppStrings.undisclosed;
    if (amount <= 0) return AppStrings.unpaidTfp;
    final value = compact ? _compactCurrency.format(amount) : _thousands.format(amount);
    return '$value $currency';
  }

  /// Formats a salary range, e.g. `formatSalaryRange(80000, 150000)` ->
  /// "80,000 – 150,000 DZD".
  static String formatSalaryRange(
    num? min,
    num? max, {
    String currency = 'DZD',
  }) {
    if (min == null && max == null) return AppStrings.undisclosed;
    if (min != null && max != null) {
      if (min == max) return formatSalary(min, currency: currency);
      return '${_thousands.format(min)} – ${_thousands.format(max)} $currency';
    }
    final value = min ?? max;
    return AppStrings.fromSalaryAmount(formatSalary(value, currency: currency));
  }

  /// Formats height in centimeters, e.g. `formatHeight(178)` -> '178 cm'.
  static String formatHeight(num? cm) {
    if (cm == null || cm <= 0) return '—';
    return '${cm.round()} ${AppStrings.unitCm}';
  }

  /// Converts centimeters to a feet/inches label, e.g. 178 -> `5'10"`.
  static String formatHeightImperial(num? cm) {
    if (cm == null || cm <= 0) return '—';
    final totalInches = cm / 2.54;
    final feet = (totalInches / 12).floor();
    final inches = (totalInches % 12).round();
    return "$feet'$inches\"";
  }

  /// Formats a single age, e.g. `formatAge(24)` -> "24 yrs".
  static String formatAge(int? age) {
    if (age == null || age <= 0) return '—';
    return '$age ${AppStrings.yrsSuffix}';
  }

  /// Formats an age range, e.g. `formatAgeRange(18, 25)` -> "18–25 yrs".
  static String formatAgeRange(int? min, int? max) {
    if (min == null && max == null) return AppStrings.anyAge;
    if (min != null && max != null) {
      if (min == max) return formatAge(min);
      return '$min–$max ${AppStrings.yrsSuffix}';
    }
    if (min != null) return '$min+ ${AppStrings.yrsSuffix}';
    return AppStrings.upToAgeValue(max!);
  }

  /// Computes age in years from a birth date.
  static int ageFromBirthDate(DateTime birthDate) {
    final now = DateTime.now();
    var age = now.year - birthDate.year;
    final hasHadBirthdayThisYear = (now.month > birthDate.month) ||
        (now.month == birthDate.month && now.day >= birthDate.day);
    if (!hasHadBirthdayThisYear) age--;
    return age;
  }

  /// Standard medium date with Latin digits, e.g. "27 Jul 2026".
  static String formatDate(DateTime? date) {
    if (date == null) return '—';
    return DateFormat('d MMM y', 'en').format(date);
  }

  /// Date + time with Latin digits, e.g. "27 Jul 2026, 14:32".
  static String formatDateTime(DateTime? date) {
    if (date == null) return '—';
    return DateFormat('d MMM y, HH:mm', 'en').format(date);
  }

  /// Deadline label with urgency awareness.
  static String formatDeadline(DateTime? deadline) {
    if (deadline == null) return AppStrings.noDeadline;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(deadline.year, deadline.month, deadline.day);
    final days = due.difference(today).inDays;

    if (days < 0) return AppStrings.closedDaysAgo(-days);
    if (days == 0) return AppStrings.closesToday;
    if (days == 1) return AppStrings.closesTomorrow;
    if (days <= 30) return AppStrings.closesInDays(days);
    return AppStrings.closesOn(formatDate(deadline));
  }

  /// Formats a generic count with K/M suffixes, e.g. 1200 -> "1.2K".
  static String formatCount(num count) {
    if (count < 1000) return count.toInt().toString();
    if (count < 1000000) {
      final k = count / 1000;
      return '${k.toStringAsFixed(k.truncateToDouble() == k ? 0 : 1)}K';
    }
    final m = count / 1000000;
    return '${m.toStringAsFixed(m.truncateToDouble() == m ? 0 : 1)}M';
  }

  /// Formats a rating value to a single decimal, e.g. 4.567 -> "4.6".
  static String formatRating(num? rating) {
    if (rating == null) return AppStrings.ratingNew;
    return rating.toStringAsFixed(1);
  }

  /// Formats a distance in kilometers, e.g. 3.2 -> "3.2 km", 0.4 -> "400 m".
  static String formatDistance(double km) {
    if (km < 1) return '${(km * 1000).round()} ${AppStrings.unitM}';
    return '${km.toStringAsFixed(1)} ${AppStrings.unitKm}';
  }
}
