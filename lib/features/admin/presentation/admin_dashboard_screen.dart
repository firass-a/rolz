import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/providers/providers.dart';

/// Platform overview for admins: live counts pulled straight from the
/// shared providers, plus a roadmap of moderation tools that are on the
/// way (user management, report review, verification queue…).
class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key, this.embedded = false});

  /// When true, shown inside the main shell (no outer back affordance needed).
  final bool embedded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final talents = ref.watch(talentProvider);
    final recruiters = ref.watch(recruiterProvider);
    final castings = ref.watch(castingProvider);
    final pendingReports = ref.watch(pendingReportsCountProvider);
    final verifiedTalents = talents.where((t) => t.isVerified).length;
    final openCastings = castings.where((c) => c.isOpen).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: 'Admin Console', showBackButton: !embedded),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxxl),
        children: [
          Text(
            'Platform Overview',
            style: AppTextStyles.sectionTitle,
          ).animate().fadeIn(duration: 350.ms),
          const SizedBox(height: AppSpacing.md),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: AppSpacing.sm,
            crossAxisSpacing: AppSpacing.sm,
            childAspectRatio: 1.35,
            children: [
              KrStatCard(icon: Iconsax.user, value: '${talents.length + recruiters.length}', label: 'Total Users'),
              KrStatCard(icon: Iconsax.briefcase, value: '$openCastings', label: 'Open Castings'),
              KrStatCard(
                icon: Iconsax.flag,
                value: '$pendingReports',
                label: 'Pending Reports',
                iconColor: pendingReports > 0 ? AppColors.error : AppColors.gold,
              ),
              KrStatCard(icon: Iconsax.shield_tick, value: '$verifiedTalents', label: 'Verified Talents'),
            ],
          ).animate().fadeIn(delay: 100.ms, duration: 350.ms).slideY(begin: 0.06, end: 0),
          const SizedBox(height: AppSpacing.xxl),
          const _SectionLabel('Moderation Tools'),
          _ToolCard(
            icon: Iconsax.profile_2user,
            title: 'Manage Users',
            subtitle: 'Suspend, verify or ban accounts',
            onTap: () => embedded
                ? context.go(RouteNames.discover)
                : context.push(RouteNames.adminUsers),
          ),
          const SizedBox(height: AppSpacing.sm),
          _ToolCard(
            icon: Iconsax.flag,
            title: 'Review Reports',
            subtitle: '$pendingReports pending report${pendingReports == 1 ? '' : 's'}',
            highlighted: pendingReports > 0,
            onTap: () => context.push(RouteNames.adminReports),
          ),
          const SizedBox(height: AppSpacing.sm),
          _ToolCard(
            icon: Iconsax.shield_tick,
            title: 'Verification Queue',
            subtitle: 'Approve talent & recruiter badges',
            onTap: () => context.push(RouteNames.adminVerification),
          ),
          const SizedBox(height: AppSpacing.sm),
          _ToolCard(
            icon: Iconsax.briefcase,
            title: 'Casting Oversight',
            subtitle: 'Audit and moderate live castings',
            onTap: () => embedded
                ? context.go(RouteNames.castings)
                : context.push(RouteNames.adminCastings),
          ),
        ].animate(interval: 40.ms).fadeIn(duration: 250.ms),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm, left: 4),
      child: Text(label.toUpperCase(), style: AppTextStyles.overline),
    );
  }
}

class _ToolCard extends StatelessWidget {
  const _ToolCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.highlighted = false,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool highlighted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      onTap: onTap,
      borderColor: highlighted ? AppColors.error.withValues(alpha: 0.4) : null,
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: (highlighted ? AppColors.error : AppColors.gold).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 19, color: highlighted ? AppColors.error : AppColors.gold),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: AppTextStyles.cardTitle.copyWith(fontSize: 15)),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          const Icon(Iconsax.arrow_right_3, size: 16, color: AppColors.textMuted),
        ],
      ),
    );
  }
}
