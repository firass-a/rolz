import 'package:flutter/material.dart';

/// KAST-ROLZ design tokens — luxury cinematic palette.
abstract final class AppColors {
  static const background = Color(0xFF0A0A0A);
  static const surface = Color(0xFF141414);
  static const card = Color(0xFF1A1A1A);
  static const cardElevated = Color(0xFF222222);
  static const border = Color(0xFF2A2A2A);
  static const borderLight = Color(0xFF3A3A3A);

  static const gold = Color(0xFFD4AF37);
  static const goldLight = Color(0xFFF5D76E);
  static const goldDark = Color(0xFFB8960C);
  static const amber = Color(0xFFFFBF00);

  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFB0B0B0);
  static const textMuted = Color(0xFF6B6B6B);

  static const success = Color(0xFF2ECC71);
  static const error = Color(0xFFE74C3C);
  static const warning = Color(0xFFF39C12);
  static const info = Color(0xFF3498DB);

  static const glass = Color(0x1AFFFFFF);
  static const glassBorder = Color(0x33FFFFFF);
  static const overlay = Color(0xCC000000);

  static const gradientGold = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [goldLight, gold, goldDark],
  );

  static const gradientDark = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1A1A1A), Color(0xFF0A0A0A)],
  );

  static const gradientHero = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xCC000000), Color(0xFF0A0A0A)],
  );
}
