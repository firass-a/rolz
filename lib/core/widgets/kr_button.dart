import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../theme/app_text_styles.dart';

enum PremiumButtonVariant { primary, secondary, ghost, danger }

enum PremiumButtonSize { small, medium, large }

class _ButtonPalette {
  const _ButtonPalette({
    required this.background,
    required this.foreground,
    this.border,
    this.shadow,
  });

  final Color background;
  final Color foreground;
  final Color? border;
  final List<BoxShadow>? shadow;
}

/// KAST-ROLZ's signature CTA button. Supports four visual variants, a
/// loading state, and a subtle tactile scale-down on press powered by
/// flutter_animate.
class PremiumButton extends StatefulWidget {
  const PremiumButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = PremiumButtonVariant.primary,
    this.size = PremiumButtonSize.medium,
    this.icon,
    this.trailingIcon,
    this.isLoading = false,
    this.fullWidth = false,
    this.borderRadius,
  });

  const PremiumButton.primary({
    super.key,
    required this.label,
    this.onPressed,
    this.size = PremiumButtonSize.medium,
    this.icon,
    this.trailingIcon,
    this.isLoading = false,
    this.fullWidth = false,
    this.borderRadius,
  }) : variant = PremiumButtonVariant.primary;

  const PremiumButton.secondary({
    super.key,
    required this.label,
    this.onPressed,
    this.size = PremiumButtonSize.medium,
    this.icon,
    this.trailingIcon,
    this.isLoading = false,
    this.fullWidth = false,
    this.borderRadius,
  }) : variant = PremiumButtonVariant.secondary;

  const PremiumButton.ghost({
    super.key,
    required this.label,
    this.onPressed,
    this.size = PremiumButtonSize.medium,
    this.icon,
    this.trailingIcon,
    this.isLoading = false,
    this.fullWidth = false,
    this.borderRadius,
  }) : variant = PremiumButtonVariant.ghost;

  const PremiumButton.danger({
    super.key,
    required this.label,
    this.onPressed,
    this.size = PremiumButtonSize.medium,
    this.icon,
    this.trailingIcon,
    this.isLoading = false,
    this.fullWidth = false,
    this.borderRadius,
  }) : variant = PremiumButtonVariant.danger;

  final String label;
  final VoidCallback? onPressed;
  final PremiumButtonVariant variant;
  final PremiumButtonSize size;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool isLoading;
  final bool fullWidth;
  final double? borderRadius;

  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<PremiumButton> {
  bool _pressed = false;

  bool get _disabled => widget.onPressed == null || widget.isLoading;

  void _setPressed(bool value) {
    if (!mounted || _pressed == value) return;
    setState(() => _pressed = value);
  }

  _ButtonPalette _paletteFor(PremiumButtonVariant variant) {
    if (_disabled) {
      switch (variant) {
        case PremiumButtonVariant.primary:
        case PremiumButtonVariant.danger:
          return _ButtonPalette(
            background: (variant == PremiumButtonVariant.danger
                    ? AppColors.error
                    : AppColors.gold)
                .withValues(alpha: 0.25),
            foreground: AppColors.textMuted,
          );
        case PremiumButtonVariant.secondary:
          return const _ButtonPalette(
            background: Colors.transparent,
            foreground: AppColors.textMuted,
            border: AppColors.border,
          );
        case PremiumButtonVariant.ghost:
          return const _ButtonPalette(
            background: Colors.transparent,
            foreground: AppColors.textMuted,
          );
      }
    }

    switch (variant) {
      case PremiumButtonVariant.primary:
        return _ButtonPalette(
          background: AppColors.gold,
          foreground: const Color(0xFF14110A),
          shadow: AppShadows.goldSoft,
        );
      case PremiumButtonVariant.secondary:
        return const _ButtonPalette(
          background: Colors.transparent,
          foreground: AppColors.gold,
          border: AppColors.gold,
        );
      case PremiumButtonVariant.ghost:
        return const _ButtonPalette(
          background: AppColors.glass,
          foreground: AppColors.textPrimary,
        );
      case PremiumButtonVariant.danger:
        return _ButtonPalette(
          background: AppColors.error.withValues(alpha: 0.12),
          foreground: AppColors.error,
          border: AppColors.error.withValues(alpha: 0.4),
        );
    }
  }

  EdgeInsets get _padding {
    switch (widget.size) {
      case PremiumButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm);
      case PremiumButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md + 2);
      case PremiumButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.lg);
    }
  }

  double get _fontSize {
    switch (widget.size) {
      case PremiumButtonSize.small:
        return 13;
      case PremiumButtonSize.medium:
        return 15;
      case PremiumButtonSize.large:
        return 16;
    }
  }

  double get _iconSize {
    switch (widget.size) {
      case PremiumButtonSize.small:
        return 16;
      case PremiumButtonSize.medium:
        return 18;
      case PremiumButtonSize.large:
        return 20;
    }
  }

  double get _spinnerSize => widget.size == PremiumButtonSize.small ? 14 : 16;

  @override
  Widget build(BuildContext context) {
    final palette = _paletteFor(widget.variant);
    final radius = widget.borderRadius ?? AppRadius.md;

    final content = Row(
      mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.isLoading) ...[
          SizedBox(
            width: _spinnerSize,
            height: _spinnerSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: palette.foreground,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ] else if (widget.icon != null) ...[
          Icon(widget.icon, size: _iconSize, color: palette.foreground),
          const SizedBox(width: AppSpacing.sm),
        ],
        Flexible(
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.button.copyWith(
              color: palette.foreground,
              fontSize: _fontSize,
            ),
          ),
        ),
        if (widget.trailingIcon != null && !widget.isLoading) ...[
          const SizedBox(width: AppSpacing.sm),
          Icon(widget.trailingIcon, size: _iconSize, color: palette.foreground),
        ],
      ],
    );

    final button = Container(
      width: widget.fullWidth ? double.infinity : null,
      padding: _padding,
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.circular(radius),
        border: palette.border != null
            ? Border.all(color: palette.border!, width: 1.4)
            : null,
        boxShadow: palette.shadow,
      ),
      child: content,
    );

    return Semantics(
      button: true,
      enabled: !_disabled,
      label: widget.label,
      child: MouseRegion(
        cursor: _disabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _disabled ? null : widget.onPressed,
          onTapDown: (_) => _setPressed(true),
          onTapUp: (_) => _setPressed(false),
          onTapCancel: () => _setPressed(false),
          child: button
              .animate(target: _pressed ? 1 : 0)
              .scaleXY(begin: 1, end: 0.96, duration: 120.ms, curve: Curves.easeOut),
        ),
      ),
    );
  }
}
