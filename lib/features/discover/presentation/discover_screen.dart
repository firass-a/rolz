import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/l10n/display_localizer.dart';
import '../../../core/router/route_names.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/providers.dart';
import '../../admin/presentation/admin_users_screen.dart';
import 'discover_filters_sheet.dart';

const _uuid = Uuid();

/// Talent discovery grid: live search, category filter chips and a
/// responsive masonry-style grid of [KrTalentCard]s, all driven by the
/// shared [discoverFiltersProvider] / [filteredTalentsProvider].
class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  final _searchController = TextEditingController();
  TalentCategory? _category;
  bool _isGridView = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleFavorite(String userId, TalentModel talent) {
    final existing = ref.read(favoriteProvider.notifier).find(userId, talent.id, FavoriteItemType.talent);
    if (existing != null) {
      ref.read(favoriteProvider.notifier).remove(existing.id);
    } else {
      ref.read(favoriteProvider.notifier).add(FavoriteModel(
            id: _uuid.v4(),
            userId: userId,
            itemId: talent.id,
            itemType: FavoriteItemType.talent,
            createdAt: DateTime.now(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(currentRoleProvider);
    if (role == UserRole.admin) {
      return const AdminUsersScreen(embedded: true);
    }

    final talents = ref.watch(filteredTalentsProvider);
    final userId = ref.watch(currentUserProvider)?.id;
    final filters = ref.watch(discoverFiltersProvider).talentFilters;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: AppStrings.navDiscover, showBackButton: false),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
            child: KrSearchBar(
              controller: _searchController,
              hintText: AppStrings.searchHint,
              onChanged: (value) => ref.read(discoverFiltersProvider.notifier).setTalentQuery(value),
              showFilterIcon: true,
              hasActiveFilters: filters.hasActiveFilters,
              onFilterTap: () => showDiscoverFiltersSheet(context),
            ),
          ),
          SizedBox(
            height: 44,
            child: Row(
              children: [
                Expanded(
                  child: FilterChipBar(
                  padding: const EdgeInsets.only(left: AppSpacing.lg),
                  selectedValue: _category?.name ?? 'all',
                  onSelected: (value) {
                    final category = value == null || value == 'all'
                        ? null
                        : TalentCategory.values.firstWhere((c) => c.name == value);
                    setState(() => _category = category);
                    ref.read(discoverFiltersProvider.notifier).setTalentFilters(
                          ref.read(discoverFiltersProvider).talentFilters.copyWith(category: category),
                        );
                  },
                  items: [
                    FilterChipItem(value: 'all', label: AppStrings.all),
                    ...TalentCategory.values.map((c) => FilterChipItem(value: c.name, label: c.label)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.lg),
                child: _ViewToggleButton(
                  isGridView: _isGridView,
                  onTap: () => setState(() => _isGridView = !_isGridView),
                ),
              ),
            ],
          ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: talents.isEmpty
                ? Center(
                    child: EmptyState(
                      title: AppStrings.emptySearchTitle,
                      subtitle: AppStrings.emptySearchSubtitle,
                    ),
                  )
                : _isGridView
                    ? GridView.builder(
                        padding: EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, context.shellBottomInset),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: AppSpacing.md,
                          crossAxisSpacing: AppSpacing.md,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: talents.length,
                        itemBuilder: (context, index) {
                          final talent = talents[index];
                          final isFavorite = userId == null
                              ? false
                              : ref.watch(
                                  isFavoriteProvider((userId: userId, itemId: talent.id, type: FavoriteItemType.talent)));
                          return KrTalentCard(
                            name: talent.fullName,
                            imageUrl: talent.headshotUrl,
                            category: talent.category.label,
                            city: DisplayLocalizer.t(talent.city),
                            verified: talent.isVerified,
                            rating: talent.rating,
                            available: talent.availability == AvailabilityStatus.available,
                            isFavorite: isFavorite,
                            onFavoriteTap: userId == null ? null : () => _toggleFavorite(userId, talent),
                            onTap: () => context.push(RouteNames.talentDetailPath(talent.id)),
                          ).animate().fadeIn(delay: (30 * (index % 8)).ms, duration: 300.ms);
                        },
                      )
                    : ListView.separated(
                        padding: EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, context.shellBottomInset),
                        itemCount: talents.length,
                        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, index) {
                          final talent = talents[index];
                          final isFavorite = userId == null
                              ? false
                              : ref.watch(
                                  isFavoriteProvider((userId: userId, itemId: talent.id, type: FavoriteItemType.talent)));
                          return KrTalentCard(
                            variant: KrTalentCardVariant.list,
                            name: talent.fullName,
                            imageUrl: talent.headshotUrl,
                            category: talent.category.label,
                            city: DisplayLocalizer.t(talent.city),
                            verified: talent.isVerified,
                            rating: talent.rating,
                            available: talent.availability == AvailabilityStatus.available,
                            isFavorite: isFavorite,
                            onFavoriteTap: userId == null ? null : () => _toggleFavorite(userId, talent),
                            onTap: () => context.push(RouteNames.talentDetailPath(talent.id)),
                          ).animate().fadeIn(delay: (20 * (index % 10)).ms, duration: 250.ms);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _ViewToggleButton extends StatelessWidget {
  const _ViewToggleButton({required this.isGridView, required this.onTap});

  final bool isGridView;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: AppRadius.radiusFull,
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(
          isGridView ? Iconsax.row_vertical : Iconsax.grid_2,
          size: 17,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
