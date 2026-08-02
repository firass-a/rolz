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
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/providers.dart';
import '../../admin/presentation/admin_dashboard_screen.dart';

IconData _categoryIcon(TalentCategory category) {
  switch (category) {
    case TalentCategory.actor:
      return Iconsax.video_play;
    case TalentCategory.actress:
      return Iconsax.video_vertical;
    case TalentCategory.model:
      return Iconsax.gallery;
    case TalentCategory.extra:
      return Iconsax.user_octagon;
    case TalentCategory.voiceActor:
      return Iconsax.microphone;
    case TalentCategory.dancer:
      return Iconsax.music;
    case TalentCategory.musician:
      return Iconsax.musicnote;
    case TalentCategory.contentCreator:
      return Iconsax.camera;
    case TalentCategory.photographer:
      return Iconsax.image;
  }
}

/// Talent home: a cinematic hero inviting discovery, a snapshot of the
/// talent's own stats, and curated rails for featured castings and top
/// agencies. Guests see the same shell with friendly zero-states instead
/// of personal stats.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    if (auth.user?.role == UserRole.admin && !auth.isGuest) {
      return const AdminDashboardScreen(embedded: true);
    }

    final user = auth.user;
    final talent = user == null ? null : ref.watch(talentByUserIdProvider(user.id));
    final applications = talent == null ? const [] : ref.watch(applicationsByTalentProvider(talent.id));
    final unreadNotifs = user == null ? 0 : ref.watch(unreadNotificationCountProvider(user.id));
    final featuredCastings = ref.watch(featuredCastingsProvider).take(6).toList();
    final featuredTalents = ref.watch(featuredTalentsProvider).take(8).toList();
    final trendingCastings = ([...ref.watch(activeCastingsProvider)]
          ..sort((a, b) => b.viewCount.compareTo(a.viewCount)))
        .take(6)
        .toList();
    final agencies = ref.watch(agencyProvider).take(6).toList();
    final bottomPad = context.shellBottomInset;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.gold,
          backgroundColor: AppColors.card,
          onRefresh: () async {},
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0),
                sliver: SliverToBoxAdapter(
                  child: _Header(
                    name: auth.isGuest
                        ? AppStrings.guest
                        : (user?.firstName.isNotEmpty == true ? user!.firstName : AppStrings.there),
                    avatarUrl: user?.avatarUrl,
                    unreadNotifications: unreadNotifs,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, 0),
                sliver: SliverToBoxAdapter(child: _HeroCard()),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, 0),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Expanded(
                        child: KrStatCard(
                          icon: Iconsax.send_2,
                          value: applications.isEmpty ? '0' : '${applications.length}',
                          label: AppStrings.applications,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: KrStatCard(
                          icon: Iconsax.eye,
                          value: talent == null ? '0' : Formatters.formatCount(talent.viewCount),
                          label: AppStrings.profileViews,
                          animateCounter: false,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: KrStatCard(
                          icon: Iconsax.star_1,
                          value: talent == null ? '—' : Formatters.formatRating(talent.rating),
                          label: AppStrings.rating,
                          animateCounter: false,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 150.ms, duration: 400.ms).slideY(begin: 0.08, end: 0),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(top: AppSpacing.xxl),
                sliver: SliverToBoxAdapter(
                  child: KrSectionHeader(
                    goldLabel: AppStrings.exploreByCraft,
                    title: AppStrings.popularCategories,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 48,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    itemCount: TalentCategory.values.length,
                    separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final category = TalentCategory.values[index];
                      return Center(
                        child: KrFilterChip(
                          label: category.label,
                          icon: _categoryIcon(category),
                          selected: false,
                          onTap: () {
                            ref.read(discoverFiltersProvider.notifier).setTalentFilters(
                                  ref.read(discoverFiltersProvider).talentFilters.copyWith(category: category),
                                );
                            context.go(RouteNames.discover);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(top: AppSpacing.xl),
                sliver: SliverToBoxAdapter(
                  child: KrSectionHeader(
                    goldLabel: AppStrings.risingStars,
                    title: AppStrings.featuredTalents,
                    onActionTap: () => context.go(RouteNames.discover),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 228,
                  child: featuredTalents.isEmpty
                      ? Center(child: Text(AppStrings.noFeaturedTalentsYet))
                      : ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.lg),
                          itemCount: featuredTalents.length,
                          separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
                          itemBuilder: (context, index) {
                            final t = featuredTalents[index];
                            return SizedBox(
                              width: 140,
                              child: KrTalentCard(
                                name: t.fullName,
                                imageUrl: t.headshotUrl,
                                category: t.category.label,
                                city: DisplayLocalizer.t(t.city),
                                verified: t.isVerified,
                                rating: t.rating,
                                available: t.availability == AvailabilityStatus.available,
                                onTap: () => context.push(RouteNames.talentDetailPath(t.id)),
                              ),
                            );
                          },
                        ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(top: AppSpacing.lg),
                sliver: SliverToBoxAdapter(
                  child: KrSectionHeader(
                    goldLabel: AppStrings.curatedForYou,
                    title: AppStrings.featuredCastings,
                    onActionTap: () => context.go(RouteNames.castings),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 176,
                  child: featuredCastings.isEmpty
                      ? Center(child: Text(AppStrings.noFeaturedCastingsYet))
                      : ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.lg),
                          itemCount: featuredCastings.length,
                          separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
                          itemBuilder: (context, index) {
                            final casting = featuredCastings[index];
                            return SizedBox(
                              width: 260,
                              child: KrCastingCard(
                                compact: true,
                                title: DisplayLocalizer.t(casting.title),
                                bannerUrl: casting.bannerUrl,
                                role: DisplayLocalizer.t(casting.role),
                                location: casting.locationLabel,
                                salaryLabel: Formatters.formatSalary(casting.salary, currency: casting.currency),
                                deadline: casting.applicationDeadline,
                                featured: casting.isFeatured,
                                urgent: casting.isUrgent,
                                onTap: () => context.push(RouteNames.castingDetailPath(casting.id)),
                              ),
                            );
                          },
                        ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(top: AppSpacing.lg),
                sliver: SliverToBoxAdapter(
                  child: KrSectionHeader(
                    goldLabel: AppStrings.hotRightNow,
                    title: AppStrings.trendingCastings,
                    onActionTap: () => context.go(RouteNames.castings),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 176,
                  child: trendingCastings.isEmpty
                      ? Center(child: Text(AppStrings.noCastingsYetShort))
                      : ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.lg),
                          itemCount: trendingCastings.length,
                          separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
                          itemBuilder: (context, index) {
                            final casting = trendingCastings[index];
                            return SizedBox(
                              width: 260,
                              child: KrCastingCard(
                                compact: true,
                                title: DisplayLocalizer.t(casting.title),
                                bannerUrl: casting.bannerUrl,
                                role: DisplayLocalizer.t(casting.role),
                                location: casting.locationLabel,
                                salaryLabel: Formatters.formatSalary(casting.salary, currency: casting.currency),
                                deadline: casting.applicationDeadline,
                                featured: casting.isFeatured,
                                urgent: casting.isUrgent,
                                onTap: () => context.push(RouteNames.castingDetailPath(casting.id)),
                              ),
                            );
                          },
                        ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(top: AppSpacing.lg),
                sliver: SliverToBoxAdapter(
                  child: KrSectionHeader(
                    goldLabel: AppStrings.trustedPartners,
                    title: AppStrings.topAgencies,
                    onActionTap: () => context.push(RouteNames.search),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 168,
                  child: agencies.isEmpty
                      ? const SizedBox.shrink()
                      : ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xl),
                          itemCount: agencies.length,
                          separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
                          itemBuilder: (context, index) {
                            final agency = agencies[index];
                            return KrAgencyCard(
                              name: agency.name,
                              logoUrl: agency.logoUrl,
                              location: DisplayLocalizer.t(agency.city),
                              verified: agency.isVerified,
                              talentCount: agency.talentCount,
                              width: 220,
                              onTap: () => context.push(RouteNames.agencyDetailPath(agency.id)),
                            );
                          },
                        ),
                ),
              ),
              SliverPadding(padding: EdgeInsets.only(bottom: bottomPad)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.name, required this.avatarUrl, required this.unreadNotifications});

  final String name;
  final String? avatarUrl;
  final int unreadNotifications;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        KrAvatar(imageUrl: avatarUrl, initials: name.isNotEmpty ? name[0] : '?', size: KrAvatarSize.md),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.welcomeBackComma, style: AppTextStyles.bodySmall),
              Text(
                name,
                style: AppTextStyles.cardTitle.copyWith(fontSize: 18, height: 1.2),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        KrAppBarAction(
          icon: Iconsax.notification,
          badge: unreadNotifications > 0,
          onPressed: () => context.push(RouteNames.notifications),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }
}

class _HeroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlassContainer.gold(
      padding: const EdgeInsets.all(AppSpacing.xl),
      boxShadow: AppShadows.gold,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.yourNextRoleAwaits, style: AppTextStyles.goldLabel),
          const SizedBox(height: AppSpacing.sm),
          Text(
            AppStrings.discoverPremiumCastingCalls,
            style: AppTextStyles.heroTitleCompact.copyWith(fontSize: 26),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            AppStrings.curatedOpportunities,
            style: AppTextStyles.bodyMuted,
          ),
          const SizedBox(height: AppSpacing.lg),
          PremiumButton.primary(
            label: AppStrings.exploreCastings,
            icon: Iconsax.discover,
            onPressed: () => context.go(RouteNames.castings),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 80.ms, duration: 450.ms).slideY(begin: 0.06, end: 0);
  }
}
