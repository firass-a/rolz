import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_strings.dart';
import '../theme/app_text_styles.dart';
import 'kr_button.dart';

/// A centred, cinematic empty state — icon in a soft gold halo, title,
/// subtitle and an optional call-to-action button.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    this.icon = Iconsax.box,
    this.title,
    this.subtitle,
    this.ctaLabel,
    this.onCtaTap,
    this.compact = false,
  });

  final IconData icon;
  final String? title;
  final String? subtitle;
  final String? ctaLabel;
  final VoidCallback? onCtaTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final resolvedTitle = title ?? AppStrings.emptyGenericTitle;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: compact ? AppSpacing.xl : AppSpacing.xxxl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: compact ? 72 : 96,
            height: compact ? 72 : 96,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.gold.withValues(alpha: 0.16),
                  AppColors.gold.withValues(alpha: 0.0),
                ],
              ),
            ),
            child: Container(
              width: compact ? 56 : 72,
              height: compact ? 56 : 72,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.card,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(icon, size: compact ? 26 : 32, color: AppColors.gold),
            ),
          ).animate().fadeIn(duration: 400.ms).scale(
                begin: const Offset(0.85, 0.85),
                end: const Offset(1, 1),
                curve: Curves.easeOutBack,
                duration: 500.ms,
              ),
          SizedBox(height: compact ? AppSpacing.md : AppSpacing.lg),
          Text(
            resolvedTitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionTitle.copyWith(fontSize: compact ? 20 : 24),
          ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMuted,
            ).animate().fadeIn(delay: 150.ms, duration: 400.ms),
          ],
          if (ctaLabel != null) ...[
            SizedBox(height: compact ? AppSpacing.lg : AppSpacing.xl),
            PremiumButton.primary(label: ctaLabel!, onPressed: onCtaTap)
                .animate()
                .fadeIn(delay: 200.ms, duration: 400.ms),
          ],
        ],
      ),
    );
  }
}
