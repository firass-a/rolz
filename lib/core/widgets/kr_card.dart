import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

/// The base dark surface card used across KAST-ROLZ — talent cards, casting
/// cards, list tiles and settings rows all build on top of this. Gives a
/// gentle scale-down feedback on tap when [onTap] is provided.
class AnimatedCard extends StatefulWidget {
  const AnimatedCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding = AppSpacing.cardPadding,
    this.margin,
    this.borderRadius,
    this.color,
    this.border = true,
    this.borderColor,
    this.elevated = false,
    this.width,
    this.height,
    this.gradient,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Color? color;
  final bool border;
  final Color? borderColor;

  /// Adds a stronger drop shadow — use for floating or highlighted cards.
  final bool elevated;
  final double? width;
  final double? height;
  final Gradient? gradient;

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard> {
  bool _pressed = false;

  bool get _interactive => widget.onTap != null || widget.onLongPress != null;

  void _setPressed(bool value) {
    if (!mounted || _pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? AppRadius.radiusMd;

    Widget card = Container(
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.gradient == null ? (widget.color ?? AppColors.card) : null,
        gradient: widget.gradient,
        borderRadius: radius,
        border: widget.border
            ? Border.all(color: widget.borderColor ?? AppColors.border, width: 1)
            : null,
        boxShadow: widget.elevated ? AppShadows.elevated : AppShadows.card,
      ),
      child: widget.child,
    );

    if (_interactive) {
      card = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          onTapDown: (_) => _setPressed(true),
          onTapUp: (_) => _setPressed(false),
          onTapCancel: () => _setPressed(false),
          child: card
              .animate(target: _pressed ? 1 : 0)
              .scaleXY(begin: 1, end: 0.97, duration: 120.ms, curve: Curves.easeOut),
        ),
      );
    }

    return card;
  }
}
