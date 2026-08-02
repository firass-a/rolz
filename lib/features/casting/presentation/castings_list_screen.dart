import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/l10n/display_localizer.dart';
import '../../../core/router/route_names.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/providers.dart';
import '../../admin/presentation/admin_castings_screen.dart';

const _uuid = Uuid();

/// Browsable list of live casting calls: search, casting-type filters and
/// a vertical feed of [KrCastingCard]s backed by [filteredCastingsProvider].
class CastingsListScreen extends ConsumerStatefulWidget {
  const CastingsListScreen({super.key});

  @override
  ConsumerState<CastingsListScreen> createState() => _CastingsListScreenState();
}

class _CastingsListScreenState extends ConsumerState<CastingsListScreen> {
  final _searchController = TextEditingController();
  CastingType? _type;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleFavorite(String userId, CastingModel casting) {
    final existing =
        ref.read(favoriteProvider.notifier).find(userId, casting.id, FavoriteItemType.casting);
    if (existing != null) {
      ref.read(favoriteProvider.notifier).remove(existing.id);
    } else {
      ref.read(favoriteProvider.notifier).add(FavoriteModel(
            id: _uuid.v4(),
            userId: userId,
            itemId: casting.id,
            itemType: FavoriteItemType.casting,
            createdAt: DateTime.now(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(currentRoleProvider);
    if (role == UserRole.admin) {
      return const AdminCastingsScreen(embedded: true);
    }

    final castings = ref.watch(filteredCastingsProvider);
    final userId = ref.watch(currentUserProvider)?.id;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: AppStrings.navCastings, showBackButton: false),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
            child: KrSearchBar(
              controller: _searchController,
              hintText: AppStrings.searchCastings,
              onChanged: (value) => ref.read(discoverFiltersProvider.notifier).setCastingQuery(value),
            ),
          ),
          SizedBox(
            height: 44,
            child: FilterChipBar(
              selectedValue: _type?.name ?? 'all',
              onSelected: (value) {
                final type = value == null || value == 'all'
                    ? null
                    : CastingType.values.firstWhere((c) => c.name == value);
                setState(() => _type = type);
                ref.read(discoverFiltersProvider.notifier).setCastingFilters(
                      ref.read(discoverFiltersProvider).castingFilters.copyWith(type: type),
                    );
              },
              items: [
                FilterChipItem(value: 'all', label: AppStrings.all),
                ...CastingType.values.map((c) => FilterChipItem(value: c.name, label: c.label)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: castings.isEmpty
                ? Center(
                    child: EmptyState(
                      title: AppStrings.emptySearchTitle,
                      subtitle: AppStrings.emptySearchSubtitle,
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, context.shellBottomInset),
                    itemCount: castings.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final casting = castings[index];
                      final isFavorite = userId == null
                          ? false
                          : ref.watch(isFavoriteProvider(
                              (userId: userId, itemId: casting.id, type: FavoriteItemType.casting)));
                      return KrCastingCard(
                        title: DisplayLocalizer.t(casting.title),
                        bannerUrl: casting.bannerUrl,
                        role: DisplayLocalizer.t(casting.role),
                        location: casting.locationLabel,
                        salaryLabel:
                            Formatters.formatSalary(casting.salary, currency: casting.currency),
                        deadline: casting.applicationDeadline,
                        featured: casting.isFeatured,
                        urgent: casting.isUrgent,
                        isFavorite: isFavorite,
                        onFavoriteTap: userId == null ? null : () => _toggleFavorite(userId, casting),
                        onTap: () => context.push(RouteNames.castingDetailPath(casting.id)),
                      ).animate().fadeIn(delay: (30 * (index % 8)).ms, duration: 300.ms);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
