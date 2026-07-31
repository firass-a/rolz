import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Compact statistic tile — Inter digits, FittedBox so values never overflow.
class KrStatCard extends StatelessWidget {
  const KrStatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.animateCounter = true,
    this.iconColor,
    this.onTap,
    this.compact = false,
  });

  final IconData icon;
  final String value;
  final String label;
  final bool animateCounter;
  final Color? iconColor;
  final VoidCallback? onTap;
  final bool compact;

  num? get _numericValue => num.tryParse(value);

  @override
  Widget build(BuildContext context) {
    final accent = iconColor ?? AppColors.gold;

    final card = Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? AppSpacing.sm + 2 : AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.radiusMd,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: compact ? 30 : 34,
            height: compact ? 30 : 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: compact ? 16 : 18, color: accent),
          ),
          SizedBox(height: compact ? AppSpacing.sm : AppSpacing.md - 2),
          _AnimatedValue(
            value: value,
            numeric: animateCounter ? _numericValue : null,
            style: AppTextStyles.statValue.copyWith(
              fontSize: compact ? 18 : 20,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );

    if (onTap == null) return card;
    return GestureDetector(onTap: onTap, child: card);
  }
}

class _AnimatedValue extends StatelessWidget {
  const _AnimatedValue({
    required this.value,
    required this.numeric,
    required this.style,
  });

  final String value;
  final num? numeric;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    if (numeric == null) {
      return FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(value, style: style, maxLines: 1),
      );
    }

    final isInt = numeric == numeric!.roundToDouble();

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: numeric!.toDouble()),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, _) {
        final text = isInt
            ? animatedValue.round().toString()
            : animatedValue.toStringAsFixed(1);
        return FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(text, style: style, maxLines: 1),
        );
      },
    );
  }
}
