import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/router/route_names.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/providers.dart';

/// One search box across every entity in KAST-ROLZ — talents, castings,
/// recruiters, agencies and conversations — powered by
/// [globalSearchProvider]. Doubles as the recruiter shell's "Search" tab.
class GlobalSearchScreen extends ConsumerStatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  ConsumerState<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends ConsumerState<GlobalSearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final search = ref.watch(globalSearchProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Search', showBackButton: false),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
            child: KrSearchBar(
              controller: _controller,
              hintText: 'Search talents, castings, agencies…',
              autofocus: true,
              onChanged: (value) => ref.read(globalSearchProvider.notifier).search(value),
            ),
          ),
          Expanded(
            child: search.query.isEmpty
                ? const Center(
                    child: EmptyState(
                      icon: Iconsax.search_normal,
                      title: 'Search KAST-ROLZ',
                      subtitle: 'Find talents, castings, recruiters and agencies in one place.',
                    ),
                  )
                : !search.hasResults
                    ? const Center(
                        child: EmptyState(
                          icon: Iconsax.search_normal_1,
                          title: 'No Results Found',
                          subtitle: 'Try a different name, role or city.',
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xxl),
                        children: [
                          if (search.talents.isNotEmpty) ...[
                            KrSectionHeader(title: 'Talents', subtitle: '${search.talents.length} found', actionLabel: null),
                            ...search.talents.map((t) => KrTalentCard(
                                  name: t.fullName,
                                  imageUrl: t.headshotUrl,
                                  category: t.category.label,
                                  city: t.city,
                                  verified: t.isVerified,
                                  rating: t.rating,
                                  variant: KrTalentCardVariant.list,
                                  onTap: () => context.push(RouteNames.talentDetailPath(t.id)),
                                )),
                            const SizedBox(height: AppSpacing.lg),
                          ],
                          if (search.castings.isNotEmpty) ...[
                            KrSectionHeader(title: 'Castings', subtitle: '${search.castings.length} found', actionLabel: null),
                            ...search.castings.map((c) => KrCastingCard(
                                  title: c.title,
                                  bannerUrl: c.bannerUrl,
                                  role: c.role,
                                  location: c.locationLabel,
                                  salaryLabel: Formatters.formatSalary(c.salary, currency: c.currency),
                                  onTap: () => context.push(RouteNames.castingDetailPath(c.id)),
                                )),
                            const SizedBox(height: AppSpacing.lg),
                          ],
                          if (search.agencies.isNotEmpty) ...[
                            KrSectionHeader(title: 'Agencies', subtitle: '${search.agencies.length} found', actionLabel: null),
                            ...search.agencies.map((a) => KrAgencyCard(
                                  name: a.name,
                                  logoUrl: a.logoUrl,
                                  location: a.city,
                                  verified: a.isVerified,
                                  talentCount: a.talentCount,
                                  onTap: () => context.push(RouteNames.agencyDetailPath(a.id)),
                                )),
                          ],
                        ].animate(interval: 40.ms).fadeIn(duration: 250.ms),
                      ),
          ),
        ],
      ),
    );
  }
}
