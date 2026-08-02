import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/widgets.dart';

/// Company story from https://kast-rolz-call.lovable.app/about
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: AppStrings.aboutKastRolz),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxxl),
        children: [
          Text(AppStrings.company.toUpperCase(), style: AppTextStyles.overline)
              .animate()
              .fadeIn(duration: 300.ms),
          const SizedBox(height: AppSpacing.sm),
          Text(AppStrings.aboutKastRolz, style: AppTextStyles.heroTitleCompact)
              .animate()
              .fadeIn(delay: 40.ms, duration: 350.ms),
          const SizedBox(height: AppSpacing.lg),
          Text(AppStrings.aboutIntro, style: AppTextStyles.bodyMuted)
              .animate()
              .fadeIn(delay: 80.ms, duration: 350.ms),
          const SizedBox(height: AppSpacing.xxl),
          _Section(title: AppStrings.ourMission, body: AppStrings.ourMissionBody)
              .animate()
              .fadeIn(delay: 120.ms, duration: 350.ms),
          const SizedBox(height: AppSpacing.xl),
          _Section(title: AppStrings.ourVision, body: AppStrings.ourVisionBody)
              .animate()
              .fadeIn(delay: 160.ms, duration: 350.ms),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.subsectionTitle),
          const SizedBox(height: AppSpacing.sm),
          Text(body, style: AppTextStyles.bodyMuted),
        ],
      ),
    );
  }
}
