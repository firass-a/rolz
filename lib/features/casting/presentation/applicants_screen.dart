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
import '../../../core/widgets/widgets.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/providers.dart';

/// Recruiter-facing applicant manager for a single casting: filterable by
/// status, with per-applicant accept/reject/shortlist/message/view-profile
/// actions. Status changes flow through [applicationRepositoryProvider],
/// which also fires the accept/reject notifications automatically.
class ApplicantsScreen extends ConsumerStatefulWidget {
  const ApplicantsScreen({super.key, required this.castingId});

  final String castingId;

  @override
  ConsumerState<ApplicantsScreen> createState() => _ApplicantsScreenState();
}

class _ApplicantsScreenState extends ConsumerState<ApplicantsScreen> {
  ApplicationStatus? _filter;

  @override
  Widget build(BuildContext context) {
    final casting = ref.watch(castingByIdProvider(widget.castingId));
    final applications = ref.watch(applicationsByCastingProvider(widget.castingId));

    final filtered = _filter == null ? applications : applications.where((a) => a.status == _filter).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: casting != null ? 'Applicants · ${casting.title}' : 'Applicants',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.sm),
            child: FilterChipBar(
              selectedValue: _filter?.name ?? 'all',
              onSelected: (value) {
                setState(() {
                  _filter = value == null || value == 'all'
                      ? null
                      : ApplicationStatus.values.firstWhere((s) => s.name == value);
                });
              },
              items: [
                FilterChipItem(value: 'all', label: 'All', count: applications.length),
                for (final status in ApplicationStatus.values)
                  if (status != ApplicationStatus.withdrawn)
                    FilterChipItem(
                      value: status.name,
                      label: status.label,
                      count: applications.where((a) => a.status == status).length,
                    ),
              ],
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: EmptyState(
                      icon: Iconsax.profile_2user,
                      title: 'No Applicants Yet',
                      subtitle: 'Once talents apply to this casting, they\'ll show up here.',
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xxxl),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final application = filtered[index];
                      return _ApplicantCard(
                        application: application,
                        onAccept: () => _updateStatus(application, ApplicationStatus.accepted),
                        onReject: () => _updateStatus(application, ApplicationStatus.rejected),
                        onShortlist: () => _updateStatus(application, ApplicationStatus.shortlisted),
                        onMessage: () => _message(application),
                        onViewProfile: () => context.push(RouteNames.talentDetailPath(application.talentId)),
                      ).animate().fadeIn(delay: (30 * (index % 10)).ms, duration: 280.ms);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateStatus(ApplicationModel application, ApplicationStatus status) async {
    await ref.read(applicationRepositoryProvider).updateStatus(application.id, status);
    if (!mounted) return;
    context.showSnack('Application marked as ${status.label.toLowerCase()}.');
  }

  Future<void> _message(ApplicationModel application) async {
    final currentUser = ref.read(currentUserProvider);
    final talent = ref.read(talentByIdProvider(application.talentId));
    if (currentUser == null || talent == null) return;
    final conversation = await ref.read(messageRepositoryProvider).createConversation([currentUser.id, talent.userId]);
    if (!mounted) return;
    context.push(RouteNames.chatPath(conversation.id));
  }
}

KrStatusKind _applicationKind(ApplicationStatus status) {
  switch (status) {
    case ApplicationStatus.pending:
      return KrStatusKind.warning;
    case ApplicationStatus.accepted:
      return KrStatusKind.success;
    case ApplicationStatus.rejected:
      return KrStatusKind.error;
    case ApplicationStatus.withdrawn:
      return KrStatusKind.neutral;
    case ApplicationStatus.shortlisted:
      return KrStatusKind.gold;
  }
}

class _ApplicantCard extends ConsumerWidget {
  const _ApplicantCard({
    required this.application,
    required this.onAccept,
    required this.onReject,
    required this.onShortlist,
    required this.onMessage,
    required this.onViewProfile,
  });

  final ApplicationModel application;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onShortlist;
  final VoidCallback onMessage;
  final VoidCallback onViewProfile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final talent = ref.watch(talentByIdProvider(application.talentId));

    return AnimatedCard(
      onTap: onViewProfile,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              KrAvatar(
                imageUrl: talent?.headshotUrl,
                initials: (talent?.fullName ?? '?').initials,
                verified: talent?.isVerified ?? false,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      talent?.fullName ?? 'Unknown Talent',
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      [
                        if (talent != null) talent.category.label,
                        if (talent != null) talent.city,
                      ].join(' · '),
                      style: AppTextStyles.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text('Applied ${application.createdAt.timeAgo}', style: AppTextStyles.caption),
                  ],
                ),
              ),
              StatusBadge(label: application.status.label, kind: _applicationKind(application.status)),
            ],
          ),
          if (application.coverLetter.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(application.coverLetter, style: AppTextStyles.bodySmall, maxLines: 3, overflow: TextOverflow.ellipsis),
          ],
          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              _ActionIcon(icon: Iconsax.tick_circle, color: AppColors.success, tooltip: 'Accept', onTap: onAccept),
              _ActionIcon(icon: Iconsax.close_circle, color: AppColors.error, tooltip: 'Reject', onTap: onReject),
              _ActionIcon(icon: Iconsax.star_1, color: AppColors.gold, tooltip: 'Shortlist', onTap: onShortlist),
              _ActionIcon(icon: Iconsax.message, color: AppColors.info, tooltip: 'Message', onTap: onMessage),
              const Spacer(),
              _ActionIcon(icon: Iconsax.profile_circle, color: AppColors.textSecondary, tooltip: 'View Profile', onTap: onViewProfile),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({required this.icon, required this.color, required this.tooltip, required this.onTap});

  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: Tooltip(
        message: tooltip,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
        ),
      ),
    );
  }
}
