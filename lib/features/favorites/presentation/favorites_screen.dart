import 'package:collection/collection.dart';
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
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/providers.dart';

/// Everything a user has bookmarked — talents, castings and agencies —
/// grouped into tabs, each backed live by [favoritesForUserByTypeProvider].
class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 3, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(currentUserProvider)?.id;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: AppStrings.favorites,
        showBackButton: false,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: AppStrings.talents),
            Tab(text: AppStrings.castings),
            Tab(text: AppStrings.agencies),
          ],
        ),
      ),
      body: userId == null
          ? Center(
              child: EmptyState(
                icon: Iconsax.heart,
                title: AppStrings.emptyFavoritesTitle,
                subtitle: AppStrings.emptyFavoritesSubtitle,
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _TalentFavorites(userId: userId),
                _CastingFavorites(userId: userId),
                _AgencyFavorites(userId: userId),
              ],
            ),
    );
  }
}

class _TalentFavorites extends ConsumerWidget {
  const _TalentFavorites({required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesForUserByTypeProvider((userId: userId, type: FavoriteItemType.talent)));
    final talents = ref.watch(talentProvider);
    final items = favorites.map((f) => talents.where((t) => t.id == f.itemId).firstOrNull).whereType<TalentModel>().toList();

    if (items.isEmpty) {
      return Center(child: EmptyState(icon: Iconsax.heart, title: AppStrings.emptyFavoritesTitle, subtitle: AppStrings.emptyFavoritesSubtitle, compact: true));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.62,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final talent = items[index];
        return KrTalentCard(
          name: talent.fullName,
          imageUrl: talent.headshotUrl,
          category: talent.category.label,
          city: DisplayLocalizer.t(talent.city),
          verified: talent.isVerified,
          rating: talent.rating,
          isFavorite: true,
          onFavoriteTap: () {
            final fav = ref.read(favoriteProvider.notifier).find(userId, talent.id, FavoriteItemType.talent);
            if (fav != null) ref.read(favoriteProvider.notifier).remove(fav.id);
          },
          onTap: () => context.push(RouteNames.talentDetailPath(talent.id)),
        ).animate().fadeIn(delay: (30 * (index % 8)).ms, duration: 280.ms);
      },
    );
  }
}

class _CastingFavorites extends ConsumerWidget {
  const _CastingFavorites({required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesForUserByTypeProvider((userId: userId, type: FavoriteItemType.casting)));
    final castings = ref.watch(castingProvider);
    final items = favorites.map((f) => castings.where((c) => c.id == f.itemId).firstOrNull).whereType<CastingModel>().toList();

    if (items.isEmpty) {
      return Center(child: EmptyState(icon: Iconsax.briefcase, title: AppStrings.emptyFavoritesTitle, subtitle: AppStrings.emptyFavoritesSubtitle, compact: true));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final casting = items[index];
        return KrCastingCard(
          title: DisplayLocalizer.t(casting.title),
          bannerUrl: casting.bannerUrl,
          role: DisplayLocalizer.t(casting.role),
          location: casting.locationLabel,
          salaryLabel: Formatters.formatSalary(casting.salary, currency: casting.currency),
          deadline: casting.applicationDeadline,
          isFavorite: true,
          onFavoriteTap: () {
            final fav = ref.read(favoriteProvider.notifier).find(userId, casting.id, FavoriteItemType.casting);
            if (fav != null) ref.read(favoriteProvider.notifier).remove(fav.id);
          },
          onTap: () => context.push(RouteNames.castingDetailPath(casting.id)),
        ).animate().fadeIn(delay: (30 * (index % 8)).ms, duration: 280.ms);
      },
    );
  }
}

class _AgencyFavorites extends ConsumerWidget {
  const _AgencyFavorites({required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesForUserByTypeProvider((userId: userId, type: FavoriteItemType.agency)));
    final agencies = ref.watch(agencyProvider);
    final items = favorites.map((f) => agencies.where((a) => a.id == f.itemId).firstOrNull).whereType<AgencyModel>().toList();

    if (items.isEmpty) {
      return Center(child: EmptyState(icon: Iconsax.buildings, title: AppStrings.emptyFavoritesTitle, subtitle: AppStrings.emptyFavoritesSubtitle, compact: true));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final agency = items[index];
        return KrAgencyCard(
          name: agency.name,
          logoUrl: agency.logoUrl,
          location: DisplayLocalizer.t(agency.city),
          verified: agency.isVerified,
          talentCount: agency.talentCount,
          onTap: () => context.push(RouteNames.agencyDetailPath(agency.id)),
        ).animate().fadeIn(delay: (30 * (index % 8)).ms, duration: 280.ms);
      },
    );
  }
}
