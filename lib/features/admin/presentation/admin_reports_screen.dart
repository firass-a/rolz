import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/mock/mock_data.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/providers.dart';

const _kAllStatus = 'all';

IconData _targetIcon(ReportTargetType type) {
  switch (type) {
    case ReportTargetType.user:
      return Iconsax.profile_circle;
    case ReportTargetType.talent:
      return Iconsax.user;
    case ReportTargetType.recruiter:
      return Iconsax.briefcase;
    case ReportTargetType.casting:
      return Iconsax.video_square;
    case ReportTargetType.message:
      return Iconsax.message_text;
    case ReportTargetType.review:
      return Iconsax.star_1;
  }
}

/// Resolves a human-readable label for whatever a report's [targetId]
/// points at, spanning users, talents, recruiters, castings, messages and
/// reviews.
String _resolveTargetLabel(WidgetRef ref, ReportModel report) {
  switch (report.targetType) {
    case ReportTargetType.user:
      return MockData.userById(report.targetId)?.fullName ?? 'Unknown user';
    case ReportTargetType.talent:
      return ref.watch(talentByIdProvider(report.targetId))?.fullName ?? 'Unknown talent';
    case ReportTargetType.recruiter:
      return ref.watch(recruiterByIdProvider(report.targetId))?.companyName ?? 'Unknown recruiter';
    case ReportTargetType.casting:
      return ref.watch(castingByIdProvider(report.targetId))?.title ?? 'Unknown casting';
    case ReportTargetType.message:
      final message = ref.watch(messageProvider).firstWhereOrNull((m) => m.id == report.targetId);
      return message?.content.truncate(60) ?? 'Deleted message';
    case ReportTargetType.review:
      final review = ref.watch(reviewProvider).firstWhereOrNull((r) => r.id == report.targetId);
      return review?.comment.truncate(60) ?? 'Deleted review';
  }
}

/// Admin moderation queue for user-submitted reports — filter by status
/// and resolve or dismiss each one, backed by [reportProvider].
class AdminReportsScreen extends ConsumerStatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  ConsumerState<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends ConsumerState<AdminReportsScreen> {
  String _statusFilter = _kAllStatus;

  @override
  Widget build(BuildContext context) {
    var reports = ref.watch(reportProvider);
    if (_statusFilter != _kAllStatus) {
      reports = reports.where((r) => r.status.name == _statusFilter).toList();
    }
    reports = [...reports]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final pendingCount = ref.watch(pendingReportsCountProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Review Reports',
        showBackButton: true,
        actions: [
          if (pendingCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: Center(child: StatusBadge.error('$pendingCount pending')),
            ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: AppSpacing.sm),
          FilterChipBar(
            selectedValue: _statusFilter,
            onSelected: (v) => setState(() => _statusFilter = v ?? _kAllStatus),
            items: [
              const FilterChipItem(value: _kAllStatus, label: 'All'),
              ...ReportStatus.values.map((s) => FilterChipItem(value: s.name, label: s.label)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: reports.isEmpty
                ? const Center(
                    child: EmptyState(
                      icon: Iconsax.flag,
                      title: 'No Reports',
                      subtitle: 'Nothing to review for this filter.',
                      compact: true,
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xxxl),
                    itemCount: reports.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      return _ReportRow(report: reports[index])
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

class _ReportRow extends ConsumerWidget {
  const _ReportRow({required this.report});

  final ReportModel report;

  Widget _statusBadge(ReportStatus status) {
    switch (status) {
      case ReportStatus.pending:
        return StatusBadge.warning(status.label);
      case ReportStatus.resolved:
        return StatusBadge.success(status.label);
      case ReportStatus.dismissed:
        return StatusBadge(label: status.label, kind: KrStatusKind.neutral);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reporter = MockData.userById(report.reporterId);
    final targetLabel = _resolveTargetLabel(ref, report);
    final notifier = ref.read(reportProvider.notifier);

    return AnimatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_targetIcon(report.targetType), size: 18, color: AppColors.error),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${report.targetType.label}: $targetLabel',
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 14.5),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text('Reported by ${reporter?.fullName ?? 'Unknown'}', style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              _statusBadge(report.status),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.radiusSm,
              border: Border.all(color: AppColors.border),
            ),
            child: Text(report.reason, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Text(report.createdAt.timeAgo, style: AppTextStyles.caption),
              const Spacer(),
              if (report.status == ReportStatus.pending) ...[
                _ActionButton(
                  label: 'Dismiss',
                  color: AppColors.textMuted,
                  onTap: () {
                    notifier.updateStatus(report.id, ReportStatus.dismissed);
                    context.showSnack('Report dismissed.');
                  },
                ),
                const SizedBox(width: AppSpacing.sm),
                _ActionButton(
                  label: 'Resolve',
                  color: AppColors.success,
                  onTap: () {
                    notifier.updateStatus(report.id, ReportStatus.resolved);
                    context.showSnack('Report resolved.');
                  },
                ),
              ] else
                _ActionButton(
                  label: 'Reopen',
                  color: AppColors.gold,
                  onTap: () {
                    notifier.updateStatus(report.id, ReportStatus.pending);
                    context.showSnack('Report reopened.');
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label, required this.color, required this.onTap});

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Text(
          label,
          style: AppTextStyles.buttonSmall.copyWith(color: color),
        ),
      ),
    );
  }
}
