import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/l10n/display_localizer.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/providers.dart';

/// Recruiter home base: a snapshot of active castings, applicants and
/// hires, quick actions, and a rail of the most recent applicants across
/// all of the recruiter's castings.
class RecruiterDashboardScreen extends ConsumerWidget {
  const RecruiterDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final user = auth.user;
    final recruiter = user == null ? null : ref.watch(recruiterByUserIdProvider(user.id));
    final castings = recruiter == null ? const [] : ref.watch(castingsByRecruiterProvider(recruiter.id));
    final applications = recruiter == null ? const [] : ref.watch(applicationsByRecruiterProvider(recruiter.id));
    final openCastings = castings.where((c) => c.isOpen).length;
    final pendingApplications = applications.where((a) => a.isPending).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    KrAvatar(
                      imageUrl: recruiter?.avatarUrl ?? user?.avatarUrl,
                      initials: (recruiter?.companyName ?? user?.firstName ?? '?').initials,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppStrings.welcomeBackComma, style: AppTextStyles.bodySmall),
                          Text(
                            recruiter?.companyName ?? user?.fullName ?? AppStrings.roleRecruiterLabel,
                            style: AppTextStyles.sectionTitle.copyWith(fontSize: 21),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    KrAppBarAction(
                      icon: Iconsax.notification,
                      onPressed: () => context.push(RouteNames.notifications),
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, 0),
              sliver: SliverToBoxAdapter(
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSpacing.sm,
                  crossAxisSpacing: AppSpacing.sm,
                  childAspectRatio: 1.35,
                  children: [
                    KrStatCard(icon: Iconsax.briefcase, value: '$openCastings', label: AppStrings.openCastings),
                    KrStatCard(icon: Iconsax.profile_2user, value: '${applications.length}', label: AppStrings.totalApplicants),
                    KrStatCard(icon: Iconsax.clock, value: '$pendingApplications', label: AppStrings.pendingReview),
                    KrStatCard(icon: Iconsax.crown_1, value: '${recruiter?.hireCount ?? 0}', label: AppStrings.successfulHires),
                  ],
                ).animate().fadeIn(delay: 120.ms, duration: 400.ms).slideY(begin: 0.06, end: 0),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, 0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: PremiumButton.primary(
                        label: AppStrings.postACasting,
                        icon: Iconsax.add_circle,
                        onPressed: () => context.go(RouteNames.postCasting),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: PremiumButton.secondary(
                        label: AppStrings.findTalent,
                        icon: Iconsax.search_normal,
                        onPressed: () => context.go(RouteNames.search),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 180.ms, duration: 400.ms),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(top: AppSpacing.xxl),
              sliver: SliverToBoxAdapter(
                child: KrSectionHeader(title: AppStrings.yourCastings, subtitle: AppStrings.totalCount(castings.length)),
              ),
            ),
            if (castings.isEmpty)
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                sliver: SliverToBoxAdapter(
                  child: EmptyState(
                    icon: Iconsax.briefcase,
                    title: AppStrings.noCastingsYet,
                    subtitle: AppStrings.postFirstCasting,
                    compact: true,
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: castings
                        .take(5)
                        .map<Widget>((casting) => _CastingRow(
                              title: DisplayLocalizer.t(casting.title),
                              status: casting.status,
                              applicants: casting.applicantCount,
                              onTap: () => context.push(RouteNames.castingDetailPath(casting.id)),
                            ))
                        .toList()
                        .separatedBy(const SizedBox(height: AppSpacing.md)),
                  ),
                ),
              ),
            const SliverPadding(padding: EdgeInsets.only(bottom: AppSpacing.xxxl)),
          ],
        ),
      ),
    );
  }
}

class _CastingRow extends StatelessWidget {
  const _CastingRow({
    required this.title,
    required this.status,
    required this.applicants,
    this.onTap,
  });

  final String title;
  final CastingStatus status;
  final int applicants;
  final VoidCallback? onTap;

  KrStatusKind get _kind {
    switch (status) {
      case CastingStatus.open:
        return KrStatusKind.success;
      case CastingStatus.filled:
        return KrStatusKind.gold;
      case CastingStatus.draft:
        return KrStatusKind.neutral;
      case CastingStatus.closed:
      case CastingStatus.archived:
        return KrStatusKind.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: AppTextStyles.cardTitle, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Row(
                  children: [
                    StatusBadge(label: status.label, kind: _kind),
                    const SizedBox(width: AppSpacing.sm),
                    Icon(Iconsax.profile_2user, size: 13, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(AppStrings.applicantsLabel(applicants), style: AppTextStyles.caption),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Iconsax.arrow_right_3, size: 16, color: AppColors.textMuted),
        ],
      ),
    );
  }
}
