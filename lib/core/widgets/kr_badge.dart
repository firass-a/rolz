import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../constants/app_colors.dart';
import '../theme/app_text_styles.dart';

/// A small gold "verified" pill with a checkmark — used next to talent
/// names, agency names and anywhere trust matters.
class VerifiedBadge extends StatelessWidget {
  const VerifiedBadge({super.key, this.label, this.compact = false});

  /// If null, renders as an icon-only circular badge; if provided, renders
  /// as a labeled pill (e.g. "Verified").
  final String? label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (label == null) {
      return Container(
        width: compact ? 16 : 20,
        height: compact ? 16 : 20,
        alignment: Alignment.center,
        decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
        child: Icon(Iconsax.verify, size: compact ? 10 : 12, color: const Color(0xFF14110A)),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Iconsax.verify, size: compact ? 11 : 13, color: AppColors.gold),
          const SizedBox(width: 4),
          Text(
            label!,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.gold,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

enum KrStatusKind { success, warning, error, info, neutral, gold }

extension on KrStatusKind {
  Color get color {
    switch (this) {
      case KrStatusKind.success:
        return AppColors.success;
      case KrStatusKind.warning:
        return AppColors.warning;
      case KrStatusKind.error:
        return AppColors.error;
      case KrStatusKind.info:
        return AppColors.info;
      case KrStatusKind.neutral:
        return AppColors.textMuted;
      case KrStatusKind.gold:
        return AppColors.gold;
    }
  }
}

/// A colored dot + label status pill — e.g. "Open", "Closed", "Available",
/// "Pending", "Banned". Color communicates the status kind.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    this.kind = KrStatusKind.neutral,
    this.showDot = true,
    this.filled = false,
  });

  const StatusBadge.success(this.label, {super.key, this.showDot = true, this.filled = false})
      : kind = KrStatusKind.success;
  const StatusBadge.warning(this.label, {super.key, this.showDot = true, this.filled = false})
      : kind = KrStatusKind.warning;
  const StatusBadge.error(this.label, {super.key, this.showDot = true, this.filled = false})
      : kind = KrStatusKind.error;
  const StatusBadge.info(this.label, {super.key, this.showDot = true, this.filled = false})
      : kind = KrStatusKind.info;
  const StatusBadge.gold(this.label, {super.key, this.showDot = true, this.filled = false})
      : kind = KrStatusKind.gold;

  final String label;
  final KrStatusKind kind;
  final bool showDot;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final color = kind.color;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: filled ? color : color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: filled ? null : Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: filled ? Colors.white : color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: filled ? Colors.white : color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// A small circular unread-count badge — clamps to "99+" beyond 99, and
/// renders nothing when [count] is zero (unless [showZero] is true).
class CountBadge extends StatelessWidget {
  const CountBadge({
    super.key,
    required this.count,
    this.showZero = false,
    this.color = AppColors.gold,
    this.textColor = const Color(0xFF14110A),
    this.size = 18,
  });

  final int count;
  final bool showZero;
  final Color color;
  final Color textColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (count <= 0 && !showZero) return const SizedBox.shrink();

    final label = count > 99 ? '99+' : '$count';

    return Container(
      constraints: BoxConstraints(minWidth: size, minHeight: size),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size),
        border: Border.all(color: AppColors.background, width: 1.5),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: textColor,
          fontWeight: FontWeight.w800,
          fontSize: 10,
        ),
      ),
    );
  }
}
