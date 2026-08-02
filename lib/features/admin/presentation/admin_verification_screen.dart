import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/providers.dart';

/// Verification queue for admins: every unverified talent and recruiter,
/// with one-tap approve (flips [TalentModel.isVerified] /
/// [RecruiterModel.isVerified] and the linked [UserModel]) or reject
/// (dismisses the request from the queue for this session).
class AdminVerificationScreen extends ConsumerStatefulWidget {
  const AdminVerificationScreen({super.key});

  @override
  ConsumerState<AdminVerificationScreen> createState() => _AdminVerificationScreenState();
}

class _AdminVerificationScreenState extends ConsumerState<AdminVerificationScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 2, vsync: this);
  final _rejectedIds = <String>{};

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _reject(String id, String name) {
    setState(() => _rejectedIds.add(id));
    context.showSnack(AppStrings.verificationRejected(name), isError: true);
  }

  @override
  Widget build(BuildContext context) {
    final talents = ref
        .watch(talentProvider)
        .where((t) => !t.isVerified && !t.isArchived && !_rejectedIds.contains(t.id))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final recruiters = ref
        .watch(recruiterProvider)
        .where((r) => !r.isVerified && !_rejectedIds.contains(r.id))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: AppStrings.verificationQueue,
        showBackButton: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: AppStrings.talentsTabCount(talents.length)),
            Tab(text: AppStrings.recruitersTabCount(recruiters.length)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _TalentQueue(talents: talents, onReject: _reject),
          _RecruiterQueue(recruiters: recruiters, onReject: _reject),
        ],
      ),
    );
  }
}

class _TalentQueue extends ConsumerWidget {
  const _TalentQueue({required this.talents, required this.onReject});

  final List<TalentModel> talents;
  final void Function(String id, String name) onReject;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (talents.isEmpty) {
      return Center(
        child: EmptyState(
          icon: Iconsax.shield_tick,
          title: AppStrings.allCaughtUp,
          subtitle: AppStrings.noTalentVerificationPending,
          compact: true,
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxxl),
      itemCount: talents.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final talent = talents[index];
        return _VerificationCard(
          name: talent.fullName,
          imageUrl: talent.headshotUrl,
          subtitle: '${talent.category.label} · ${talent.locationLabel}',
          submitted: talent.createdAt,
          onApprove: () {
            ref.read(talentProvider.notifier).update(talent.copyWith(isVerified: true));
            final user = ref.read(userByIdProvider(talent.userId));
            if (user != null) ref.read(userProvider.notifier).setVerified(user.id, true);
            context.showSnack(AppStrings.isNowVerified(talent.fullName));
          },
          onReject: () => onReject(talent.id, talent.fullName),
        ).animate().fadeIn(delay: (25 * (index % 12)).ms, duration: 260.ms);
      },
    );
  }
}

class _RecruiterQueue extends ConsumerWidget {
  const _RecruiterQueue({required this.recruiters, required this.onReject});

  final List<RecruiterModel> recruiters;
  final void Function(String id, String name) onReject;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (recruiters.isEmpty) {
      return Center(
        child: EmptyState(
          icon: Iconsax.shield_tick,
          title: AppStrings.allCaughtUp,
          subtitle: AppStrings.noRecruiterVerificationPending,
          compact: true,
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxxl),
      itemCount: recruiters.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final recruiter = recruiters[index];
        final name = recruiter.fullName.isNotEmpty ? recruiter.fullName : recruiter.companyName;
        return _VerificationCard(
          name: recruiter.companyName,
          imageUrl: recruiter.companyLogo.isNotEmpty ? recruiter.companyLogo : recruiter.avatarUrl,
          subtitle: '${recruiter.companyType.label} · ${recruiter.locationLabel}',
          submitted: recruiter.createdAt,
          onApprove: () {
            ref.read(recruiterProvider.notifier).update(recruiter.copyWith(isVerified: true));
            final user = ref.read(userByIdProvider(recruiter.userId));
            if (user != null) ref.read(userProvider.notifier).setVerified(user.id, true);
            context.showSnack(AppStrings.isNowVerified(recruiter.companyName));
          },
          onReject: () => onReject(recruiter.id, name),
        ).animate().fadeIn(delay: (25 * (index % 12)).ms, duration: 260.ms);
      },
    );
  }
}

class _VerificationCard extends StatelessWidget {
  const _VerificationCard({
    required this.name,
    required this.imageUrl,
    required this.subtitle,
    required this.submitted,
    required this.onApprove,
    required this.onReject,
  });

  final String name;
  final String? imageUrl;
  final String subtitle;
  final DateTime submitted;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              KrAvatar(imageUrl: imageUrl, initials: name.initials, size: KrAvatarSize.md),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(name, style: AppTextStyles.cardTitle.copyWith(fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text(subtitle, style: AppTextStyles.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              StatusBadge.warning(AppStrings.pending),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(AppStrings.requestedAgo(submitted.timeAgo), style: AppTextStyles.caption),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: PremiumButton.ghost(
                  label: AppStrings.reject,
                  icon: Iconsax.close_circle,
                  onPressed: onReject,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: PremiumButton.primary(
                  label: AppStrings.approve,
                  icon: Iconsax.shield_tick,
                  onPressed: onApprove,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
