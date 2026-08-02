import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/providers.dart';

/// Subscription plans for talents and recruiters — mirrors the product
/// pricing board (Standard / Premium for talent, Studio / Enterprise for
/// recruiters). Checkout is stubbed with a snack until payments land.
class PricingScreen extends ConsumerWidget {
  const PricingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(authProvider).user?.role;
    final recruiterFirst = role == UserRole.recruiter;

    final talentSection = _PlanSection(
      title: AppStrings.pricingForTalents,
      children: [
        _PlanCardData.standard(),
        _PlanCardData.premium(),
      ],
    );
    final recruiterSection = _PlanSection(
      title: AppStrings.pricingForRecruiters,
      children: [
        _PlanCardData.studio(),
        _PlanCardData.enterprise(),
      ],
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: AppStrings.pricing),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xxxl,
        ),
        children: [
          Text(AppStrings.pricingTitle, style: AppTextStyles.heroTitleCompact)
              .animate()
              .fadeIn(duration: 350.ms),
          const SizedBox(height: AppSpacing.sm),
          Text(AppStrings.pricingSubtitle, style: AppTextStyles.bodyMuted)
              .animate()
              .fadeIn(delay: 60.ms, duration: 350.ms),
          const SizedBox(height: AppSpacing.xxl),
          if (recruiterFirst) ...[
            recruiterSection,
            const SizedBox(height: AppSpacing.xxl),
            talentSection,
          ] else ...[
            talentSection,
            const SizedBox(height: AppSpacing.xxl),
            recruiterSection,
          ],
        ],
      ),
    );
  }
}

class _PlanSection extends StatelessWidget {
  const _PlanSection({required this.title, required this.children});

  final String title;
  final List<_PlanCardData> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: AppTextStyles.overline),
        const SizedBox(height: AppSpacing.md),
        ...children.asMap().entries.expand((entry) {
          final i = entry.key;
          final plan = entry.value;
          return [
            if (i > 0) const SizedBox(height: AppSpacing.md),
            _PlanCard(plan: plan)
                .animate()
                .fadeIn(delay: (80 * i).ms, duration: 320.ms)
                .slideY(begin: 0.04, end: 0),
          ];
        }),
      ],
    );
  }
}

class _PlanCardData {
  const _PlanCardData({
    required this.name,
    required this.price,
    required this.priceSuffix,
    required this.features,
    required this.ctaLabel,
    required this.isSales,
    this.badge,
    this.highlighted = false,
  });

  final String name;
  final String price;
  final String? priceSuffix;
  final List<String> features;
  final String ctaLabel;
  final bool isSales;
  final String? badge;
  final bool highlighted;

  factory _PlanCardData.standard() => _PlanCardData(
        name: AppStrings.planStandard,
        price: AppStrings.priceStandard,
        priceSuffix: AppStrings.perMonth,
        badge: AppStrings.tryFirstMonthFree,
        features: [
          AppStrings.featureProProfilePhoto,
          AppStrings.feature5Applications,
          AppStrings.featureBasicVisibility,
        ],
        ctaLabel: AppStrings.startStandard,
        isSales: false,
      );

  factory _PlanCardData.premium() => _PlanCardData(
        name: AppStrings.planPremium,
        price: AppStrings.pricePremium,
        priceSuffix: AppStrings.perMonth,
        badge: AppStrings.mostPopular,
        highlighted: true,
        features: [
          AppStrings.featureVerifiedBadge,
          AppStrings.featureProProfileMedia,
          AppStrings.featureUnlimitedApplications,
          AppStrings.featurePriorityListing,
          AppStrings.featureAdvancedAnalytics,
          AppStrings.featureFeaturedPortfolio,
          AppStrings.featureMessaging,
        ],
        ctaLabel: AppStrings.goPremium,
        isSales: false,
      );

  factory _PlanCardData.studio() => _PlanCardData(
        name: AppStrings.planStudio,
        price: AppStrings.priceStudio,
        priceSuffix: AppStrings.perMonth,
        badge: AppStrings.mostPopular,
        highlighted: true,
        features: [
          AppStrings.feature10Castings,
          AppStrings.featureUnlimitedTalentSearch,
          AppStrings.featureApplicantTracking,
        ],
        ctaLabel: AppStrings.subscribeStudio,
        isSales: false,
      );

  factory _PlanCardData.enterprise() => _PlanCardData(
        name: AppStrings.planEnterprise,
        price: AppStrings.priceContactSales,
        priceSuffix: null,
        features: [
          AppStrings.featureUnlimitedCastings,
          AppStrings.featureCustomAiMatching,
          AppStrings.featurePrioritySupport,
        ],
        ctaLabel: AppStrings.contactSales,
        isSales: true,
      );
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.plan});

  final _PlanCardData plan;

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      elevated: plan.highlighted,
      borderColor: plan.highlighted ? AppColors.gold.withValues(alpha: 0.55) : null,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(plan.name, style: AppTextStyles.subsectionTitle),
              ),
              if (plan.badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.gold.withValues(alpha: 0.35)),
                  ),
                  child: Text(
                    plan.badge!,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.gold,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  plan.price,
                  style: plan.isSales
                      ? AppTextStyles.sectionTitle.copyWith(color: AppColors.gold)
                      : AppTextStyles.heroTitleCompact.copyWith(fontSize: 36),
                ),
              ),
              if (plan.priceSuffix != null) ...[
                const SizedBox(width: 6),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(plan.priceSuffix!, style: AppTextStyles.bodyMuted),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          ...plan.features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Iconsax.tick_circle, size: 18, color: AppColors.gold),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(feature, style: AppTextStyles.body),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (plan.highlighted || plan.isSales)
            PremiumButton.primary(
              label: plan.ctaLabel,
              fullWidth: true,
              onPressed: () => context.showSnack(
                plan.isSales ? AppStrings.salesContactSoon : AppStrings.pricingComingSoon,
              ),
            )
          else
            PremiumButton.secondary(
              label: plan.ctaLabel,
              fullWidth: true,
              onPressed: () => context.showSnack(AppStrings.pricingComingSoon),
            ),
        ],
      ),
    );
  }
}
