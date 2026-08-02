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
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/providers.dart';

/// Full casting-call profile, reachable by id — banner hero, status/type
/// badges, every production detail, a recruiter info card, the talent
/// apply flow (with live application status), recruiter management tools,
/// and "similar castings" recommendations.
class CastingDetailScreen extends ConsumerStatefulWidget {
  const CastingDetailScreen({super.key, required this.id});

  final String id;

  @override
  ConsumerState<CastingDetailScreen> createState() => _CastingDetailScreenState();
}

class _CastingDetailScreenState extends ConsumerState<CastingDetailScreen> {
  bool _applying = false;

  @override
  Widget build(BuildContext context) {
    final casting = ref.watch(castingByIdProvider(widget.id));

    if (casting == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(title: AppStrings.navCasting),
        body: Center(
          child: ErrorState(
            icon: Iconsax.briefcase,
            title: AppStrings.castingNotFound,
            subtitle: AppStrings.castingNotFoundSubtitle,
          ),
        ),
      );
    }

    final currentUser = ref.watch(currentUserProvider);
    final currentTalent = ref.watch(currentTalentProvider);
    final currentRecruiter = ref.watch(currentRecruiterProvider);
    final recruiter = ref.watch(recruiterByIdProvider(casting.recruiterId));
    final agency = casting.hasAgency ? ref.watch(agencyByIdProvider(casting.agencyId!)) : null;
    final isOwner = currentRecruiter?.id == casting.recruiterId;

    final myApplication = currentTalent == null
        ? null
        : ref.watch(applicationsByTalentProvider(currentTalent.id)).firstWhereOrNull((a) => a.castingId == casting.id);

    final isFavorite = currentUser == null
        ? false
        : ref.watch(
            isFavoriteProvider((userId: currentUser.id, itemId: casting.id, type: FavoriteItemType.casting)),
          );

    final similar = ref
        .watch(activeCastingsProvider)
        .where((c) => c.category == casting.category && c.id != casting.id)
        .take(6)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _BannerHeader(
            casting: casting,
            isFavorite: isFavorite,
            onFavorite: () => _toggleFavorite(currentUser?.id, casting),
            onShare: () => _share(casting),
            onReport: () => _report(currentUser?.id, casting),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xxxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      if (casting.isFeatured) StatusBadge.gold(AppStrings.castingFeatured, showDot: false),
                      if (casting.isUrgent) StatusBadge.error(AppStrings.castingUrgent, showDot: false),
                      StatusBadge(label: casting.status.label, kind: _statusKind(casting.status)),
                      StatusBadge(label: casting.type.label, kind: KrStatusKind.neutral, showDot: false),
                    ],
                  ).animate().fadeIn(duration: 300.ms),
                  const SizedBox(height: AppSpacing.md),
                  Text(DisplayLocalizer.t(casting.title), style: AppTextStyles.sectionTitle).animate().fadeIn(delay: 40.ms, duration: 300.ms),
                  if (casting.role.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(DisplayLocalizer.t(casting.role), style: AppTextStyles.body.copyWith(color: AppColors.gold)).animate().fadeIn(delay: 70.ms, duration: 300.ms),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.lg,
                    runSpacing: AppSpacing.sm,
                    children: [
                      _MetaItem(icon: Iconsax.location, label: casting.locationLabel),
                      _MetaItem(icon: Iconsax.dollar_circle, label: Formatters.formatSalary(casting.salary, currency: casting.currency), gold: true),
                      _MetaItem(icon: Iconsax.calendar, label: AppStrings.shootOn(Formatters.formatDate(casting.shootStartDate))),
                      _MetaItem(
                        icon: Iconsax.clock,
                        label: Formatters.formatDeadline(casting.applicationDeadline),
                        gold: !casting.isExpired,
                      ),
                    ],
                  ).animate().fadeIn(delay: 100.ms, duration: 300.ms),
                  _Section(title: AppStrings.description, child: Text(DisplayLocalizer.description(casting.description).orPlaceholder(AppStrings.noDescriptionProvided), style: AppTextStyles.bodyMuted)),
                  if (casting.requirements.isNotEmpty)
                    _Section(
                      title: AppStrings.requirements,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: casting.requirements
                            .map<Widget>((r) => Padding(
                                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Iconsax.tick_circle, size: 15, color: AppColors.gold),
                                      const SizedBox(width: AppSpacing.sm),
                                      Expanded(child: Text(DisplayLocalizer.t(r), style: AppTextStyles.bodyMuted)),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  if (casting.skills.isNotEmpty) _Section(title: AppStrings.skills, child: _ChipWrap(items: casting.skills)),
                  if (casting.languages.isNotEmpty)
                    _Section(title: AppStrings.languages, child: _ChipWrap(items: casting.languages, icon: Iconsax.language_square)),
                  _Section(
                    title: AppStrings.profileRequirements,
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: AppSpacing.sm,
                      crossAxisSpacing: AppSpacing.sm,
                      childAspectRatio: 1.35,
                      children: [
                        KrStatCard(icon: Iconsax.profile_2user, value: Formatters.formatAgeRange(casting.ageMin, casting.ageMax), label: AppStrings.ageRange, animateCounter: false, compact: true),
                        KrStatCard(icon: Iconsax.ruler, value: casting.heightMin == null && casting.heightMax == null ? AppStrings.any : '${Formatters.formatHeight(casting.heightMin)} – ${Formatters.formatHeight(casting.heightMax)}', label: AppStrings.height, animateCounter: false, compact: true),
                        KrStatCard(icon: Iconsax.user_tag, value: casting.gender?.label ?? AppStrings.any, label: AppStrings.gender, animateCounter: false, compact: true),
                        KrStatCard(icon: Iconsax.medal_star, value: casting.experienceLevel.label, label: AppStrings.experience, animateCounter: false, compact: true),
                      ],
                    ),
                  ),
                  _Section(
                    title: AppStrings.postedBy,
                    child: _RecruiterCard(
                      recruiter: recruiter,
                      agency: agency,
                      onTap: agency != null
                          ? () => context.push(RouteNames.agencyDetailPath(agency.id))
                          : () => context.showSnack(AppStrings.recruiterProfileComingSoon),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (!isOwner)
                    _ApplySection(
                      casting: casting,
                      currentTalent: currentTalent,
                      application: myApplication,
                      applying: _applying,
                      onApply: () => _apply(casting),
                    ),
                  if (isOwner)
                    _ManageSection(
                      casting: casting,
                      onEdit: () => context.push(RouteNames.editCastingPath(casting.id)),
                      onApplicants: () => context.push(RouteNames.applicantsPath(casting.id)),
                      onDuplicate: () => _duplicate(casting),
                      onArchive: () => _toggleArchive(casting),
                      onDelete: () => _delete(casting),
                    ),
                  if (similar.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xl),
                    KrSectionHeader(title: AppStrings.similarCastings, padding: EdgeInsets.zero),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      height: 240,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: similar.length,
                        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
                        itemBuilder: (context, index) {
                          final c = similar[index];
                          return SizedBox(
                            width: 260,
                            child: KrCastingCard(
                              title: DisplayLocalizer.t(c.title),
                              bannerUrl: c.bannerUrl,
                              role: DisplayLocalizer.t(c.role),
                              location: c.locationLabel,
                              salaryLabel: Formatters.formatSalary(c.salary, currency: c.currency),
                              deadline: c.applicationDeadline,
                              featured: c.isFeatured,
                              urgent: c.isUrgent,
                              onTap: () => context.pushReplacement(RouteNames.castingDetailPath(c.id)),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _apply(CastingModel casting) async {
    final talent = ref.read(currentTalentProvider);
    if (talent == null) {
      context.showSnack(AppStrings.onlyTalentCanApply, isError: true);
      return;
    }
    setState(() => _applying = true);
    await ref.read(applicationRepositoryProvider).apply(castingId: casting.id, talentId: talent.id);
    if (!mounted) return;
    setState(() => _applying = false);
    context.showSnack(AppStrings.applicationSubmitted);
  }

  void _toggleFavorite(String? userId, CastingModel casting) {
    if (userId == null) {
      context.showSnack(AppStrings.signInToFavorites, isError: true);
      return;
    }
    final favorited = ref.read(favoriteRepositoryProvider).toggleFavorite(userId, casting.id, FavoriteItemType.casting);
    context.showSnack(favorited ? AppStrings.addedToFavorites : AppStrings.removedFromFavorites);
  }

  void _share(CastingModel casting) {
    context.showSnack(AppStrings.shareLinkCopied(casting.title));
  }

  Future<void> _report(String? userId, CastingModel casting) async {
    if (userId == null) {
      context.showSnack(AppStrings.signInToReportCasting, isError: true);
      return;
    }
    final reason = await showKrBottomSheet<String>(
      context,
      builder: (context) => _ReportSheet(subjectLabel: casting.title),
    );
    if (reason == null || reason.trim().isEmpty || !mounted) return;
    await ref.read(reportRepositoryProvider).create(
          reporterId: userId,
          targetId: casting.id,
          targetType: ReportTargetType.casting,
          reason: reason.trim(),
        );
    if (!mounted) return;
    context.showSnack(AppStrings.reportSubmitted);
  }

  Future<void> _duplicate(CastingModel casting) async {
    await ref.read(castingRepositoryProvider).duplicate(casting.id);
    if (!mounted) return;
    context.showSnack(AppStrings.castingDuplicated);
  }

  Future<void> _toggleArchive(CastingModel casting) async {
    final archiving = !casting.isArchived;
    final confirmed = await ConfirmationSheet.show(
      context,
      title: archiving ? AppStrings.archiveThisCasting : AppStrings.restoreThisCasting,
      body: archiving ? AppStrings.archiveCastingBodyDetail : AppStrings.restoreCastingBody,
      icon: Iconsax.archive,
      confirmLabel: archiving ? AppStrings.archive : AppStrings.restore,
      isDanger: archiving,
    );
    if (!confirmed) return;
    if (archiving) {
      await ref.read(castingRepositoryProvider).archive(casting.id);
    } else {
      await ref.read(castingRepositoryProvider).restore(casting.id);
    }
    if (!mounted) return;
    context.showSnack(archiving ? AppStrings.castingArchived : AppStrings.castingRestored);
  }

  Future<void> _delete(CastingModel casting) async {
    final confirmed = await ConfirmationSheet.show(
      context,
      title: AppStrings.deleteThisCasting,
      body: AppStrings.deleteCastingBodyDetail,
      icon: Iconsax.trash,
      confirmLabel: AppStrings.delete,
    );
    if (!confirmed) return;
    await ref.read(castingRepositoryProvider).delete(casting.id);
    if (!mounted) return;
    context.showSnack(AppStrings.castingDeleted);
    if (context.canPop()) {
      Navigator.of(context).pop();
    } else {
      context.go(RouteNames.dashboard);
    }
  }
}

KrStatusKind _statusKind(CastingStatus status) {
  switch (status) {
    case CastingStatus.open:
      return KrStatusKind.success;
    case CastingStatus.filled:
      return KrStatusKind.gold;
    case CastingStatus.draft:
      return KrStatusKind.neutral;
    case CastingStatus.closed:
    case CastingStatus.archived:
      return KrStatusKind.error;
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

// ---------------------------------------------------------------------------
// Banner header
// ---------------------------------------------------------------------------

class _BannerHeader extends StatelessWidget {
  const _BannerHeader({
    required this.casting,
    required this.isFavorite,
    required this.onFavorite,
    required this.onShare,
    required this.onReport,
  });

  final CastingModel casting;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onShare;
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      stretch: true,
      expandedHeight: 260,
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
        const SizedBox(width: AppSpacing.sm),
        _GlassIconButton(icon: Iconsax.flag, onTap: onReport),
        const SizedBox(width: AppSpacing.lg),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Hero(
          tag: 'casting-${casting.id}',
          child: Stack(
            fit: StackFit.expand,
            children: [
              KrNetworkImage(imageUrl: casting.bannerUrl, errorIcon: Iconsax.video_square),
              const DecoratedBox(decoration: BoxDecoration(gradient: AppColors.gradientHero)),
            ],
          ),
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

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.icon, required this.label, this.gold = false});
  final IconData icon;
  final String label;
  final bool gold;

  @override
  Widget build(BuildContext context) {
    final color = gold ? AppColors.gold : AppColors.textSecondary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.bodySmall.copyWith(color: color, fontWeight: gold ? FontWeight.w700 : FontWeight.w500)),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.subsectionTitle),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.04, end: 0);
  }
}

class _ChipWrap extends StatelessWidget {
  const _ChipWrap({required this.items, this.icon});
  final List<String> items;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: items
          .map((item) => Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: AppRadius.radiusFull,
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 13, color: AppColors.gold),
                      const SizedBox(width: 6),
                    ],
                    Text(DisplayLocalizer.t(item), style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary)),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

class _RecruiterCard extends StatelessWidget {
  const _RecruiterCard({required this.recruiter, required this.agency, this.onTap});
  final RecruiterModel? recruiter;
  final AgencyModel? agency;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final name = agency?.name ?? recruiter?.companyName ?? recruiter?.fullName ?? AppStrings.kastRolzRecruiter;
    final subtitle = agency?.locationLabel ?? recruiter?.locationLabel ?? '';
    final imageUrl = agency?.logoUrl ?? recruiter?.avatarUrl;
    final verified = agency?.isVerified ?? recruiter?.isVerified ?? false;

    return AnimatedCard(
      onTap: onTap,
      child: Row(
        children: [
          KrAvatar(imageUrl: imageUrl, initials: name.initials, verified: verified),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(name, style: AppTextStyles.cardTitle.copyWith(fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.bodySmall),
                ],
              ],
            ),
          ),
          const Icon(Iconsax.arrow_right_3, size: 16, color: AppColors.textMuted),
        ],
      ),
    );
  }
}

class _ApplySection extends StatelessWidget {
  const _ApplySection({
    required this.casting,
    required this.currentTalent,
    required this.application,
    required this.applying,
    required this.onApply,
  });

  final CastingModel casting;
  final TalentModel? currentTalent;
  final ApplicationModel? application;
  final bool applying;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    if (application != null) {
      return AnimatedCard(
        child: Row(
          children: [
            Icon(Iconsax.send_2, size: 18, color: AppColors.gold),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(AppStrings.youApplied(application!.createdAt.timeAgo), style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary))),
            StatusBadge(label: application!.status.label, kind: _applicationKind(application!.status)),
          ],
        ),
      );
    }

    if (currentTalent == null) {
      return PremiumButton.secondary(
        label: AppStrings.signInAsTalentToApply,
        icon: Iconsax.send_2,
        fullWidth: true,
        onPressed: onApply,
      );
    }

    final disabled = !casting.isOpen || casting.isExpired;

    return PremiumButton.primary(
      label: disabled ? AppStrings.applicationsClosed : AppStrings.apply,
      icon: disabled ? null : Iconsax.send_2,
      fullWidth: true,
      isLoading: applying,
      onPressed: disabled ? null : onApply,
    );
  }
}

class _ManageSection extends StatelessWidget {
  const _ManageSection({
    required this.casting,
    required this.onEdit,
    required this.onApplicants,
    required this.onDuplicate,
    required this.onArchive,
    required this.onDelete,
  });

  final CastingModel casting;
  final VoidCallback onEdit;
  final VoidCallback onApplicants;
  final VoidCallback onDuplicate;
  final VoidCallback onArchive;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.manageThisCasting, style: AppTextStyles.subsectionTitle),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: PremiumButton.secondary(label: AppStrings.viewApplicantsCount(casting.applicantCount), icon: Iconsax.profile_2user, onPressed: onApplicants),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(child: PremiumButton.ghost(label: AppStrings.edit, icon: Iconsax.edit_2, onPressed: onEdit)),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: PremiumButton.ghost(label: AppStrings.duplicate, icon: Iconsax.copy, onPressed: onDuplicate)),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: PremiumButton.ghost(
                label: casting.isArchived ? AppStrings.restore : AppStrings.archive,
                icon: Iconsax.archive,
                onPressed: onArchive,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: PremiumButton.danger(label: AppStrings.delete, icon: Iconsax.trash, onPressed: onDelete)),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Report sheet
// ---------------------------------------------------------------------------

class _ReportSheet extends StatefulWidget {
  const _ReportSheet({required this.subjectLabel});
  final String subjectLabel;

  @override
  State<_ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends State<_ReportSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.reportSubject(widget.subjectLabel), style: AppTextStyles.sectionTitle.copyWith(fontSize: 21)),
          const SizedBox(height: AppSpacing.sm),
          Text(AppStrings.reportBodyHint, style: AppTextStyles.bodyMuted),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _controller,
            maxLines: 4,
            style: AppTextStyles.input,
            decoration: InputDecoration(hintText: AppStrings.describeIssue),
          ),
          const SizedBox(height: AppSpacing.lg),
          PremiumButton.danger(
            label: AppStrings.submitReport,
            fullWidth: true,
            onPressed: () => Navigator.of(context).pop(_controller.text),
          ),
          const SizedBox(height: AppSpacing.sm),
          PremiumButton.ghost(label: AppStrings.cancel, fullWidth: true, onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }
}
