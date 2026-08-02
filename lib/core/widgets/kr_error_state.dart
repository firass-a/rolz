import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_strings.dart';
import '../theme/app_text_styles.dart';
import 'kr_button.dart';

/// A centred error state with a retry action — used whenever a network
/// call or data load fails.
class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    this.icon = Iconsax.warning_2,
    this.title,
    this.subtitle,
    this.onRetry,
    this.retryLabel,
    this.compact = false,
  }) : _connection = false;

  /// Convenience constructor for connectivity failures.
  const ErrorState.connection({
    super.key,
    this.onRetry,
    this.retryLabel,
    this.compact = false,
  })  : icon = Iconsax.wifi_square,
        title = null,
        subtitle = null,
        _connection = true;

  final IconData icon;
  final String? title;
  final String? subtitle;
  final VoidCallback? onRetry;
  final String? retryLabel;
  final bool compact;
  final bool _connection;

  @override
  Widget build(BuildContext context) {
    final resolvedTitle = title ??
        (_connection ? AppStrings.errorConnectionTitle : AppStrings.errorGenericTitle);
    final resolvedSubtitle = subtitle ??
        (_connection ? AppStrings.errorConnectionSubtitle : AppStrings.errorGenericSubtitle);
    final resolvedRetry = retryLabel ?? AppStrings.retry;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: compact ? AppSpacing.xl : AppSpacing.xxxl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: compact ? 64 : 80,
            height: compact ? 64 : 80,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, size: compact ? 28 : 34, color: AppColors.error),
          ).animate().shake(duration: 500.ms, hz: 3, offset: const Offset(4, 0)),
          SizedBox(height: compact ? AppSpacing.md : AppSpacing.lg),
          Text(
            resolvedTitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionTitle.copyWith(fontSize: compact ? 19 : 22),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            resolvedSubtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMuted,
          ),
          if (onRetry != null) ...[
            SizedBox(height: compact ? AppSpacing.lg : AppSpacing.xl),
            PremiumButton.secondary(
              label: resolvedRetry,
              icon: Iconsax.refresh,
              onPressed: onRetry,
            ),
          ],
        ],
      ),
    );
  }
}
