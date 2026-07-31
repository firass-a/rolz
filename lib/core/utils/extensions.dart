import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/app_colors.dart';

/// Quick access to theme pieces + a couple of navigation/snackbar helpers
/// so screens don't repeat `Theme.of(context)` everywhere.
extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  TextTheme get textTheme => Theme.of(this).textTheme;

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get screenSize => MediaQuery.sizeOf(this);

  double get screenWidth => MediaQuery.sizeOf(this).width;

  double get screenHeight => MediaQuery.sizeOf(this).height;

  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);

  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  /// Space to reserve above the bottom navigation bar so scroll content
  /// is never clipped behind it.
  double get shellBottomInset => MediaQuery.paddingOf(this).bottom + 96;

  bool get isKeyboardOpen => MediaQuery.viewInsetsOf(this).bottom > 0;

  /// True for phones in landscape or tablets — a simple width heuristic.
  bool get isWideScreen => screenWidth >= 600;

  /// Shows a themed snack bar. Pass [isError] for a red-tinted variant.
  void showSnack(
    String message, {
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    final messenger = ScaffoldMessenger.of(this);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
        backgroundColor: isError ? AppColors.error : null,
      ),
    );
  }

  /// Pushes a named route using the app's [Navigator].
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);
  }

  /// Replaces the current route with a named route.
  Future<T?> pushReplacementNamed<T, TO>(
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(this)
        .pushReplacementNamed<T, TO>(routeName, arguments: arguments);
  }

  /// Pops the current route if possible.
  void pop<T>([T? result]) {
    if (Navigator.of(this).canPop()) {
      Navigator.of(this).pop<T>(result);
    }
  }

  /// Clears the navigation stack down to the first route and pushes [routeName].
  Future<T?> pushNamedAndRemoveUntil<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamedAndRemoveUntil<T>(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Dismisses the on-screen keyboard.
  void dismissKeyboard() => FocusScope.of(this).unfocus();
}

extension StringX on String {
  /// Capitalises only the first letter, e.g. "actor" -> "Actor".
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalises the first letter of every word, e.g. "casting director".
  String get titleCase {
    if (isEmpty) return this;
    return split(' ').map((w) => w.capitalize).join(' ');
  }

  /// Up to two uppercase initials derived from a name, e.g.
  /// "Amina Sofiane" -> "AS", "Kast" -> "K".
  String get initials {
    final parts = trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  /// Naive but effective email validity check for form validation.
  bool get isValidEmail {
    return RegExp(r'^[\w\.\-\+]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(this);
  }

  /// Truncates the string to [maxLength], appending an ellipsis if needed.
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength).trimRight()}…';
  }

  /// Null/empty-safe fallback, e.g. `city.orPlaceholder('Unknown')`.
  String orPlaceholder(String placeholder) => trim().isEmpty ? placeholder : this;
}

extension NullableStringX on String? {
  bool get isNullOrEmpty => this == null || this!.trim().isEmpty;
}

extension DateTimeX on DateTime {
  /// A short, human "time ago" label, e.g. "2h ago", "Just now", "3d ago".
  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo ago';
    return '${(diff.inDays / 365).floor()}y ago';
  }

  /// e.g. "27 Jul 2026".
  String get formattedDate => DateFormat('d MMM y').format(this);

  /// e.g. "27 Jul".
  String get formattedDayMonth => DateFormat('d MMM').format(this);

  /// e.g. "14:32".
  String get formattedTime => DateFormat('HH:mm').format(this);

  /// Chat-style timestamp: time if today, weekday if this week, else date.
  String get chatTimestamp {
    final now = DateTime.now();
    final isToday =
        now.year == year && now.month == month && now.day == day;
    if (isToday) return formattedTime;

    final diff = now.difference(this).inDays;
    if (diff < 7) return DateFormat('EEEE').format(this);
    return formattedDate;
  }

  bool get isToday {
    final now = DateTime.now();
    return now.year == year && now.month == month && now.day == day;
  }

  /// Whether the deadline represented by this date has passed.
  bool get isPast => isBefore(DateTime.now());

  /// Days remaining until this date (can be negative if already past).
  int get daysUntil => difference(DateTime.now()).inDays;
}

extension ListX<T> on List<T> {
  /// Returns a new list with [separator] inserted between every element —
  /// handy for building UI lists with dividers.
  List<T> separatedBy(T separator) {
    if (isEmpty) return this;
    final result = <T>[];
    for (var i = 0; i < length; i++) {
      result.add(this[i]);
      if (i != length - 1) result.add(separator);
    }
    return result;
  }

  /// Null-safe element access; returns null instead of throwing when out
  /// of range.
  T? elementAtOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }

  /// Splits the list into chunks of [size] — useful for grid pagination.
  List<List<T>> chunked(int size) {
    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      chunks.add(sublist(i, i + size > length ? length : i + size));
    }
    return chunks;
  }
}
