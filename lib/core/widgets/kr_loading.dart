import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_strings.dart';
import '../theme/app_text_styles.dart';
import 'kr_logo.dart';

/// A small inline gold spinner — drop into buttons, list footers or
/// wherever a compact loading affordance is needed.
class KrLoadingIndicator extends StatelessWidget {
  const KrLoadingIndicator({super.key, this.size = 22, this.strokeWidth = 2.4, this.color});

  final double size;
  final double strokeWidth;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(color ?? AppColors.gold),
      ),
    );
  }
}

/// A full-screen loading state — centered gold spinner with the
/// KAST-ROLZ wordmark pulsing softly underneath, plus an optional message.
class KrFullScreenLoader extends StatelessWidget {
  const KrFullScreenLoader({
    super.key,
    this.message,
    this.showLogo = true,
    this.backgroundColor,
  });

  final String? message;
  final bool showLogo;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? AppColors.background,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showLogo) ...[
            const KrLogo(size: 72)
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .fadeIn(duration: 900.ms)
                .then()
                .shimmer(
                  duration: 1600.ms,
                  color: AppColors.goldLight.withValues(alpha: 0.6),
                ),
            const SizedBox(height: AppSpacing.md),
            Text(
              AppStrings.appName,
              style: AppTextStyles.heroTitleCompact.copyWith(
                color: AppColors.gold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
          const KrLoadingIndicator(size: 32, strokeWidth: 3),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(message!, style: AppTextStyles.bodyMuted),
          ],
        ],
      ),
    );
  }
}

/// A thin horizontal loading bar for list footers when paginating.
class KrInlineLoader extends StatelessWidget {
  const KrInlineLoader({super.key, this.padding = const EdgeInsets.symmetric(vertical: AppSpacing.xl)});

  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: const Center(child: KrLoadingIndicator()),
    );
  }
}
