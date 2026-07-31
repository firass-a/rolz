import 'dart:ui';

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

/// A frosted glassmorphism panel — translucent fill over a blurred
/// backdrop, with a soft border. Used for overlays, floating headers,
/// hero cards and modal chrome throughout KAST-ROLZ.
class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.blur = 18,
    this.tint,
    this.opacity = 0.10,
    this.borderColor,
    this.borderWidth = 1,
    this.width,
    this.height,
    this.gradient,
    this.boxShadow,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double blur;

  /// Base tint colour of the glass fill — defaults to white.
  final Color? tint;
  final double opacity;
  final Color? borderColor;
  final double borderWidth;
  final double? width;
  final double? height;

  /// Optional gradient overlay instead of a flat tint.
  final Gradient? gradient;
  final List<BoxShadow>? boxShadow;

  /// A gold-tinted variant, handy for premium/featured surfaces.
  const GlassContainer.gold({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.blur = 18,
    this.width,
    this.height,
    this.boxShadow,
  })  : tint = AppColors.gold,
        opacity = 0.10,
        borderColor = AppColors.gold,
        borderWidth = 1,
        gradient = null;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? AppRadius.radiusLg;
    final fill = (tint ?? Colors.white).withValues(alpha: opacity);

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: boxShadow == null ? null : BoxDecoration(boxShadow: boxShadow),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: gradient == null ? fill : null,
              gradient: gradient,
              borderRadius: radius,
              border: Border.all(
                color: borderColor ?? AppColors.glassBorder,
                width: borderWidth,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
