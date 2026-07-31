import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/providers.dart';

/// Agency profile, reachable by id — cover + logo, credentials, specialties
/// and a live roster of every talent represented by this agency, pulled
/// straight from [talentsByAgencyProvider].
class AgencyDetailScreen extends ConsumerWidget {
  const AgencyDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agency = ref.watch(agencyByIdProvider(id));

    if (agency == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: const CustomAppBar(title: 'Agency'),
        body: const Center(
          child: ErrorState(
            icon: Iconsax.buildings,
            title: 'Agency Not Found',
            subtitle: 'This agency profile may have been removed.',
          ),
        ),
      );
    }

    final currentUser = ref.watch(currentUserProvider);
    final isFavorite = currentUser == null
        ? false
        : ref.watch(isFavoriteProvider((userId: currentUser.id, itemId: agency.id, type: FavoriteItemType.agency)));
    final talents = ref.watch(talentsByAgencyProvider(agency.id)).where((t) => !t.isArchived).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _CoverHeader(
            agency: agency,
            isFavorite: isFavorite,
            onFavorite: () {
              if (currentUser == null) {
                context.showSnack('Sign in to save favorites.', isError: true);
                return;
              }
              final favorited = ref.read(favoriteRepositoryProvider).toggleFavorite(currentUser.id, agency.id, FavoriteItemType.agency);
              context.showSnack(favorited ? 'Added to favorites.' : 'Removed from favorites.');
            },
            onShare: () => context.showSnack('Share link for ${agency.name} copied to clipboard.'),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xxxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Transform.translate(
                    offset: const Offset(0, -40),
                    child: Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.background, width: 4),
                        boxShadow: AppShadows.card,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: KrNetworkImage(imageUrl: agency.logoUrl, errorIcon: Iconsax.buildings),
                    ),
                  ).animate().fadeIn(duration: 350.ms).scale(begin: const Offset(0.85, 0.85), end: const Offset(1, 1)),
                  Transform.translate(
                    offset: const Offset(0, -20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(agency.name, style: AppTextStyles.sectionTitle)),
                            if (agency.isVerified) const VerifiedBadge(label: 'Verified'),
                          ],
                        ).animate().fadeIn(delay: 60.ms, duration: 350.ms),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Iconsax.location, size: 14, color: AppColors.textMuted),
                            const SizedBox(width: 4),
                            Text(agency.locationLabel, style: AppTextStyles.bodySmall),
                          ],
                        ).animate().fadeIn(delay: 100.ms, duration: 350.ms),
                        const SizedBox(height: AppSpacing.lg),
                        Row(
                          children: [
                            Expanded(child: KrStatCard(icon: Iconsax.profile_2user, value: '${agency.talentCount}', label: 'Talents')),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(child: KrStatCard(icon: Iconsax.star_1, value: Formatters.formatRating(agency.rating), label: 'Rating', animateCounter: false)),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(child: KrStatCard(icon: Iconsax.calendar, value: '${agency.createdAt.year}', label: 'Since', animateCounter: false)),
                          ],
                        ).animate().fadeIn(delay: 140.ms, duration: 350.ms),
                        const SizedBox(height: AppSpacing.xl),
                        if (agency.description.isNotEmpty) ...[
                          Text('About', style: AppTextStyles.subsectionTitle),
                          const SizedBox(height: AppSpacing.md),
                          Text(agency.description, style: AppTextStyles.bodyMuted),
                          const SizedBox(height: AppSpacing.xl),
                        ],
                        if (agency.specialties.isNotEmpty) ...[
                          Text('Specialties', style: AppTextStyles.subsectionTitle),
                          const SizedBox(height: AppSpacing.md),
                          Wrap(
                            spacing: AppSpacing.sm,
                            runSpacing: AppSpacing.sm,
                            children: agency.specialties
                                .map((s) => Container(
                                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                                      decoration: BoxDecoration(
                                        color: AppColors.card,
                                        borderRadius: AppRadius.radiusFull,
                                        border: Border.all(color: AppColors.border),
                                      ),
                                      child: Text(s, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary)),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                        ],
                        if (agency.website.isNotEmpty) ...[
                          GestureDetector(
                            onTap: () => context.showSnack('Opening ${agency.website}…'),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Iconsax.global, size: 15, color: AppColors.gold),
                                const SizedBox(width: 6),
                                Text(agency.website, style: AppTextStyles.bodySmall.copyWith(color: AppColors.gold)),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                        ],
                        KrSectionHeader(title: 'Our Talents', subtitle: '${talents.length} represented', padding: EdgeInsets.zero),
                        const SizedBox(height: AppSpacing.md),
                        talents.isEmpty
                            ? const EmptyState(
                                icon: Iconsax.profile_2user,
                                title: 'No Talents Yet',
                                subtitle: 'This agency hasn\'t added any talents yet.',
                                compact: true,
                              )
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: AppSpacing.md,
                                  crossAxisSpacing: AppSpacing.md,
                                  childAspectRatio: 0.62,
                                ),
                                itemCount: talents.length,
                                itemBuilder: (context, index) {
                                  final talent = talents[index];
                                  return KrTalentCard(
                                    name: talent.fullName,
                                    imageUrl: talent.headshotUrl,
                                    category: talent.category.label,
                                    city: talent.city,
                                    verified: talent.isVerified,
                                    rating: talent.rating,
                                    onTap: () => context.push(RouteNames.talentDetailPath(talent.id)),
                                  ).animate().fadeIn(delay: (30 * (index % 8)).ms, duration: 280.ms);
                                },
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CoverHeader extends StatelessWidget {
  const _CoverHeader({
    required this.agency,
    required this.isFavorite,
    required this.onFavorite,
    required this.onShare,
  });

  final AgencyModel agency;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      stretch: true,
      expandedHeight: 220,
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.only(left: AppSpacing.lg),
        child: Center(child: _GlassIconButton(icon: Iconsax.arrow_left_2, onTap: () => Navigator.of(context).maybePop())),
      ),
      leadingWidth: 56,
      actions: [
        _GlassIconButton(icon: Iconsax.share, onTap: onShare),
        const SizedBox(width: AppSpacing.sm),
        _GlassIconButton(
          icon: isFavorite ? Iconsax.heart_copy : Iconsax.heart,
          iconColor: isFavorite ? AppColors.error : AppColors.textPrimary,
          onTap: onFavorite,
        ),
        const SizedBox(width: AppSpacing.lg),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            KrNetworkImage(imageUrl: agency.coverUrl.isNotEmpty ? agency.coverUrl : agency.logoUrl, errorIcon: Iconsax.buildings),
            const DecoratedBox(decoration: BoxDecoration(gradient: AppColors.gradientHero)),
          ],
        ),
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({required this.icon, this.onTap, this.iconColor});

  final IconData icon;
  final VoidCallback? onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Icon(icon, size: 17, color: iconColor ?? AppColors.textPrimary),
      ),
    );
  }
}
