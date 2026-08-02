/// Recruiter-facing Find Talent screen — search + the same filter set as
/// the web Find Talent page (category, gender, availability, language,
/// skills, age, height, experience, location, nationality).
library;

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
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/providers.dart';
import 'find_talent_filters_sheet.dart';

const _uuid = Uuid();

class FindTalentScreen extends ConsumerStatefulWidget {
  const FindTalentScreen({super.key});

  @override
  ConsumerState<FindTalentScreen> createState() => _FindTalentScreenState();
}

class _FindTalentScreenState extends ConsumerState<FindTalentScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleFavorite(String userId, TalentModel talent) {
    final existing =
        ref.read(favoriteProvider.notifier).find(userId, talent.id, FavoriteItemType.talent);
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
    final talents = ref.watch(filteredTalentsProvider);
    final userId = ref.watch(currentUserProvider)?.id;
    final filters = ref.watch(discoverFiltersProvider).talentFilters;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: AppStrings.findTalent, showBackButton: false),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.sm),
            child: KrSearchBar(
              controller: _searchController,
              hintText: AppStrings.searchTalents,
              onChanged: (value) => ref.read(discoverFiltersProvider.notifier).setTalentQuery(value),
              showFilterIcon: true,
              hasActiveFilters: filters.hasActiveFilters,
              onFilterTap: () => showFindTalentFiltersSheet(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.sm),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppStrings.resultsCount(talents.length),
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
              ),
            ),
          ),
          Expanded(
            child: talents.isEmpty
                ? Center(
                    child: EmptyState(
                      icon: Iconsax.search_normal_1,
                      title: AppStrings.emptySearchTitle,
                      subtitle: AppStrings.noTalentsMatchFilters,
                    ),
                  )
                : GridView.builder(
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
                          : ref.watch(isFavoriteProvider((
                              userId: userId,
                              itemId: talent.id,
                              type: FavoriteItemType.talent,
                            )));
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
                  ),
          ),
        ],
      ),
    );
  }
}
