import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/widgets.dart';

/// Terms of Service from https://kast-rolz-call.lovable.app/terms
class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: AppStrings.termsOfService),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxxl),
        children: [
          Text(AppStrings.legal.toUpperCase(), style: AppTextStyles.overline)
              .animate()
              .fadeIn(duration: 300.ms),
          const SizedBox(height: AppSpacing.sm),
          Text(AppStrings.termsOfService, style: AppTextStyles.heroTitleCompact)
              .animate()
              .fadeIn(delay: 40.ms, duration: 350.ms),
          const SizedBox(height: AppSpacing.xl),
          AnimatedCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.termsBody1, style: AppTextStyles.bodyMuted),
                const SizedBox(height: AppSpacing.lg),
                Text(AppStrings.termsBody2, style: AppTextStyles.bodyMuted),
                const SizedBox(height: AppSpacing.lg),
                Text(AppStrings.termsBody3, style: AppTextStyles.bodyMuted),
              ],
            ),
          ).animate().fadeIn(delay: 100.ms, duration: 350.ms),
        ],
      ),
    );
  }
}
