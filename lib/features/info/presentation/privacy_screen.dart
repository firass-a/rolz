import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/widgets.dart';

/// Privacy Policy from https://kast-rolz-call.lovable.app/privacy
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: AppStrings.privacyPolicy),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxxl),
        children: [
          Text(AppStrings.legal.toUpperCase(), style: AppTextStyles.overline)
              .animate()
              .fadeIn(duration: 300.ms),
          const SizedBox(height: AppSpacing.sm),
          Text(AppStrings.privacyPolicy, style: AppTextStyles.heroTitleCompact)
              .animate()
              .fadeIn(delay: 40.ms, duration: 350.ms),
          const SizedBox(height: AppSpacing.xl),
          AnimatedCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.privacyBody1, style: AppTextStyles.bodyMuted),
                const SizedBox(height: AppSpacing.lg),
                Text(AppStrings.privacyBody2, style: AppTextStyles.bodyMuted),
                const SizedBox(height: AppSpacing.lg),
                Text(AppStrings.privacyBody3, style: AppTextStyles.bodyMuted),
              ],
            ),
          ).animate().fadeIn(delay: 100.ms, duration: 350.ms),
        ],
      ),
    );
  }
}
