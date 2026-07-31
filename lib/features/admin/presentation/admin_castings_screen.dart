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

const _kAllStatus = 'all';

/// Admin oversight of every casting on the platform — search, filter by
/// status, and feature / archive / close / delete any listing directly
/// from [castingProvider].
class AdminCastingsScreen extends ConsumerStatefulWidget {
  const AdminCastingsScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  ConsumerState<AdminCastingsScreen> createState() => _AdminCastingsScreenState();
}

class _AdminCastingsScreenState extends ConsumerState<AdminCastingsScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  String _statusFilter = _kAllStatus;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var castings = ref.watch(castingProvider);

    if (_query.trim().isNotEmpty) {
      final q = _query.trim().toLowerCase();
      castings = castings
          .where((c) =>
              c.title.toLowerCase().contains(q) ||
              c.role.toLowerCase().contains(q) ||
              c.city.toLowerCase().contains(q))
          .toList();
    }
    if (_statusFilter != _kAllStatus) {
      castings = castings.where((c) => c.status.name == _statusFilter).toList();
    }
    castings = [...castings]..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: 'Casting Oversight', showBackButton: !widget.embedded),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.sm),
            child: KrSearchBar(
              controller: _searchController,
              hintText: 'Search castings by title, role or city…',
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          FilterChipBar(
            selectedValue: _statusFilter,
            onSelected: (v) => setState(() => _statusFilter = v ?? _kAllStatus),
            items: [
              const FilterChipItem(value: _kAllStatus, label: 'All'),
              ...CastingStatus.values.map((s) => FilterChipItem(value: s.name, label: s.label)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: castings.isEmpty
                ? const Center(
                    child: EmptyState(
                      icon: Iconsax.briefcase,
                      title: 'No Castings Found',
                      subtitle: 'Try a different search term or filter.',
                      compact: true,
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xxxl),
                    itemCount: castings.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final casting = castings[index];
                      return _CastingRow(casting: casting)
                          .animate()
                          .fadeIn(delay: (25 * (index % 12)).ms, duration: 260.ms);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _CastingRow extends ConsumerWidget {
  const _CastingRow({required this.casting});

  final CastingModel casting;

  Widget _statusBadge(CastingStatus status) {
    switch (status) {
      case CastingStatus.open:
        return StatusBadge.success(status.label);
      case CastingStatus.closed:
        return StatusBadge.error(status.label);
      case CastingStatus.filled:
        return const StatusBadge(label: 'Filled', kind: KrStatusKind.info);
      case CastingStatus.draft:
        return StatusBadge(label: status.label, kind: KrStatusKind.neutral);
      case CastingStatus.archived:
        return StatusBadge.warning(status.label);
    }
  }

  Future<void> _handleAction(BuildContext context, WidgetRef ref, String action) async {
    final notifier = ref.read(castingProvider.notifier);
    switch (action) {
      case 'view':
        context.push(RouteNames.castingDetailPath(casting.id));
        break;
      case 'feature':
        notifier.toggleFeatured(casting.id);
        context.showSnack(casting.isFeatured ? 'Removed from featured.' : 'Casting is now featured.');
        break;
      case 'close':
        notifier.updateStatus(casting.id, CastingStatus.closed);
        context.showSnack('Casting closed.');
        break;
      case 'archive':
        final archiving = !casting.isArchived;
        if (archiving) {
          final confirmed = await ConfirmationSheet.show(
            context,
            title: 'Archive this casting?',
            body: 'It will be hidden from discovery and marked archived.',
            icon: Iconsax.archive_1,
            confirmLabel: 'Archive',
          );
          if (!confirmed) return;
          notifier.archive(casting.id);
          if (context.mounted) context.showSnack('Casting archived.');
        } else {
          notifier.restore(casting.id);
          if (context.mounted) context.showSnack('Casting restored.');
        }
        break;
      case 'delete':
        final confirmed = await ConfirmationSheet.show(
          context,
          title: 'Delete this casting?',
          body: 'This permanently removes the listing and cannot be undone.',
        );
        if (!confirmed) return;
        notifier.delete(casting.id);
        if (context.mounted) context.showSnack('Casting deleted.', isError: true);
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recruiter = ref.watch(recruiterByIdProvider(casting.recruiterId));

    return AnimatedCard(
      onTap: () => context.push(RouteNames.castingDetailPath(casting.id)),
      padding: const EdgeInsets.all(AppSpacing.sm + 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: AppRadius.radiusSm,
            child: KrNetworkImage(imageUrl: casting.thumbnailUrl, width: 72, height: 72, fit: BoxFit.cover),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  casting.title,
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  recruiter?.companyName ?? 'Unknown recruiter',
                  style: AppTextStyles.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _statusBadge(casting.status),
                    if (casting.isFeatured) const StatusBadge.gold('Featured', showDot: false),
                    if (casting.isUrgent) const StatusBadge.error('Urgent', showDot: false),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${casting.locationLabel} · ${Formatters.formatSalary(casting.salary, currency: casting.currency)} · ${casting.applicantCount} applicants',
                  style: AppTextStyles.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (action) => _handleAction(context, ref, action),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'view', child: _Row(icon: Iconsax.eye, label: 'View')),
              PopupMenuItem(
                value: 'feature',
                child: _Row(
                  icon: Iconsax.crown_1,
                  label: casting.isFeatured ? 'Unfeature' : 'Feature',
                ),
              ),
              if (casting.status == CastingStatus.open)
                const PopupMenuItem(value: 'close', child: _Row(icon: Iconsax.lock, label: 'Close')),
              PopupMenuItem(
                value: 'archive',
                child: _Row(
                  icon: casting.isArchived ? Iconsax.archive_add : Iconsax.archive_1,
                  label: casting.isArchived ? 'Restore' : 'Archive',
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: _Row(icon: Iconsax.trash, label: 'Delete', color: AppColors.error),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.icon, required this.label, this.color});

  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.textPrimary;
    return Row(
      children: [
        Icon(icon, size: 17, color: c),
        const SizedBox(width: AppSpacing.sm),
        Text(label, style: AppTextStyles.body.copyWith(fontSize: 14, color: c)),
      ],
    );
  }
}
