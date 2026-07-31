import 'package:flutter/material.dart';

import 'app_colors.dart';

/// KAST-ROLZ spacing, radius and shadow scale — keeps every screen on the
/// same cinematic rhythm.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  /// Horizontal page gutter used across most screens.
  static const double pageGutter = lg;

  static const EdgeInsets pagePadding = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);
  static const EdgeInsets sectionPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: xl,
  );
}

/// Corner radii — from subtle chips to hero cards.
abstract final class AppRadius {
  static const double sm = 12;
  static const double md = 18;
  static const double lg = 24;
  static const double xl = 28;
  static const double full = 999;

  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius radiusXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius radiusFull = BorderRadius.all(
    Radius.circular(full),
  );
}

/// Elevation shadows — soft gold glow for highlighted surfaces, dark drop
/// shadows for regular cards and sheets.
abstract final class AppShadows {
  /// Subtle dark elevation for standard cards on the black background.
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x66000000),
      blurRadius: 20,
      offset: Offset(0, 8),
      spreadRadius: -4,
    ),
  ];

  /// Slightly stronger elevation for floating / modal surfaces.
  static const List<BoxShadow> elevated = [
    BoxShadow(
      color: Color(0x99000000),
      blurRadius: 32,
      offset: Offset(0, 16),
      spreadRadius: -6,
    ),
  ];

  /// Warm gold glow used behind primary CTAs and featured/premium cards.
  static const List<BoxShadow> gold = [
    BoxShadow(
      color: Color(0x40D4AF37),
      blurRadius: 24,
      offset: Offset(0, 10),
      spreadRadius: -6,
    ),
  ];

  /// Tight gold glow for small interactive elements (buttons, badges).
  static const List<BoxShadow> goldSoft = [
    BoxShadow(
      color: Color(0x33D4AF37),
      blurRadius: 12,
      offset: Offset(0, 4),
      spreadRadius: -2,
    ),
  ];

  /// Used for bottom sheets / nav bars anchored to the bottom of the screen.
  static const List<BoxShadow> bottomSheet = [
    BoxShadow(
      color: Color(0xB3000000),
      blurRadius: 28,
      offset: Offset(0, -8),
      spreadRadius: -4,
    ),
  ];

  static List<BoxShadow> glow({Color color = AppColors.gold, double opacity = 0.35}) {
    return [
      BoxShadow(
        color: color.withValues(alpha: opacity),
        blurRadius: 28,
        offset: const Offset(0, 12),
        spreadRadius: -8,
      ),
    ];
  }
}

/// Standard animation durations & curves for a soft, cinematic feel.
abstract final class AppDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration cinematic = Duration(milliseconds: 800);

  static const Curve curve = Curves.easeOutCubic;
  static const Curve curveIn = Curves.easeInCubic;
  static const Curve bounce = Curves.easeOutBack;
}
