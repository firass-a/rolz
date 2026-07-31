import 'package:intl/intl.dart';

/// Small, dependency-free formatting helpers shared across every screen
/// that displays talent, casting or agency data.
abstract final class Formatters {
  static final NumberFormat _compactCurrency = NumberFormat.compactCurrency(
    decimalDigits: 0,
    symbol: '',
  );

  static final NumberFormat _thousands = NumberFormat.decimalPattern();

  /// Formats a salary/budget value with a currency code, e.g.
  /// `formatSalary(150000, currency: 'DZD')` -> "150,000 DZD".
  /// Large values are compacted, e.g. `formatSalary(2500000)` -> "2.5M DZD".
  static String formatSalary(
    num? amount, {
    String currency = 'DZD',
    bool compact = false,
  }) {
    if (amount == null) return 'Undisclosed';
    if (amount <= 0) return 'Unpaid / TFP';
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
    if (min == null && max == null) return 'Undisclosed';
    if (min != null && max != null) {
      if (min == max) return formatSalary(min, currency: currency);
      return '${_thousands.format(min)} – ${_thousands.format(max)} $currency';
    }
    final value = min ?? max;
    return 'From ${formatSalary(value, currency: currency)}';
  }

  /// Formats height in centimeters, e.g. `formatHeight(178)` -> '178 cm'.
  /// Returns an em dash when unknown.
  static String formatHeight(num? cm) {
    if (cm == null || cm <= 0) return '—';
    return '${cm.round()} cm';
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
    return '$age yrs';
  }

  /// Formats an age range, e.g. `formatAgeRange(18, 25)` -> "18–25 yrs".
  static String formatAgeRange(int? min, int? max) {
    if (min == null && max == null) return 'Any age';
    if (min != null && max != null) {
      if (min == max) return formatAge(min);
      return '$min–$max yrs';
    }
    if (min != null) return '$min+ yrs';
    return 'Up to $max yrs';
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

  /// Standard medium date, e.g. "27 Jul 2026".
  static String formatDate(DateTime? date) {
    if (date == null) return '—';
    return DateFormat('d MMM y').format(date);
  }

  /// Date + time, e.g. "27 Jul 2026, 14:32".
  static String formatDateTime(DateTime? date) {
    if (date == null) return '—';
    return DateFormat('d MMM y, HH:mm').format(date);
  }

  /// Deadline label with urgency awareness, e.g. "Closes in 3 days",
  /// "Closes today", "Closed 2 days ago".
  static String formatDeadline(DateTime? deadline) {
    if (deadline == null) return 'No deadline';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(deadline.year, deadline.month, deadline.day);
    final days = due.difference(today).inDays;

    if (days < 0) return 'Closed ${(-days)}d ago';
    if (days == 0) return 'Closes today';
    if (days == 1) return 'Closes tomorrow';
    if (days <= 30) return 'Closes in $days days';
    return 'Closes ${formatDate(deadline)}';
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
    if (rating == null) return 'New';
    return rating.toStringAsFixed(1);
  }

  /// Formats a distance in kilometers, e.g. 3.2 -> "3.2 km", 0.4 -> "400 m".
  static String formatDistance(double km) {
    if (km < 1) return '${(km * 1000).round()} m';
    return '${km.toStringAsFixed(1)} km';
  }
}
