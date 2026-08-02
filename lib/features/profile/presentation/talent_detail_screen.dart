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

/// Full profile for any talent, reachable by id — cover + avatar hero,
/// identity/stat header, contact/favorite/share/report actions, and every
/// section of a real casting profile: bio, skills, languages, physical
/// stats, experience, education, portfolio, videos, reviews and socials.
class TalentDetailScreen extends ConsumerStatefulWidget {
  const TalentDetailScreen({super.key, required this.id});

  final String id;

  @override
  ConsumerState<TalentDetailScreen> createState() => _TalentDetailScreenState();
}

class _TalentDetailScreenState extends ConsumerState<TalentDetailScreen> {
  bool _contacting = false;

  @override
  Widget build(BuildContext context) {
    final talent = ref.watch(talentByIdProvider(widget.id));

    if (talent == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(title: AppStrings.talentProfile),
        body: Center(
          child: ErrorState(
            icon: Iconsax.profile_remove,
            title: AppStrings.talentNotFound,
            subtitle: AppStrings.talentNotFoundSubtitle,
          ),
        ),
      );
    }

    final currentUser = ref.watch(currentUserProvider);
    final isOwner = ref.watch(currentTalentProvider)?.id == talent.id;
    final isFavorite = currentUser == null
        ? false
        : ref.watch(
            isFavoriteProvider((userId: currentUser.id, itemId: talent.id, type: FavoriteItemType.talent)),
          );
    final reviews = ref.watch(reviewsForTalentProvider(talent.id));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _CoverHeader(
            talent: talent,
            isFavorite: isFavorite,
            onFavorite: () => _toggleFavorite(currentUser?.id, talent),
            onShare: () => _share(talent),
            onReport: () => _report(currentUser?.id, talent),
          ),
          SliverToBoxAdapter(
            child: _ProfileBody(
              talent: talent,
              isOwner: isOwner,
              reviews: reviews,
              contacting: _contacting,
              onContact: () => _contact(currentUser, talent),
              onEdit: () => context.push(RouteNames.editProfile),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _contact(UserModel? currentUser, TalentModel talent) async {
    if (currentUser == null) {
      context.showSnack(AppStrings.signInToMessage, isError: true);
      return;
    }
    if (currentUser.id == talent.userId) {
      context.showSnack(AppStrings.ownProfileSnack);
      return;
    }
    setState(() => _contacting = true);
    final conversation = await ref
        .read(messageRepositoryProvider)
        .createConversation([currentUser.id, talent.userId]);
    if (!mounted) return;
    setState(() => _contacting = false);
    context.push(RouteNames.chatPath(conversation.id));
  }

  void _toggleFavorite(String? userId, TalentModel talent) {
    if (userId == null) {
      context.showSnack(AppStrings.signInToFavorites, isError: true);
      return;
    }
    final favorited = ref
        .read(favoriteRepositoryProvider)
        .toggleFavorite(userId, talent.id, FavoriteItemType.talent);
    context.showSnack(favorited ? AppStrings.addedToFavorites : AppStrings.removedFromFavorites);
  }

  void _share(TalentModel talent) {
    context.showSnack(AppStrings.shareLinkCopied(talent.fullName));
  }

  Future<void> _report(String? userId, TalentModel talent) async {
    if (userId == null) {
      context.showSnack(AppStrings.signInToReport, isError: true);
      return;
    }
    final reason = await showKrBottomSheet<String>(
      context,
      builder: (context) => _ReportSheet(subjectLabel: talent.fullName),
    );
    if (reason == null || reason.trim().isEmpty || !mounted) return;
    await ref.read(reportRepositoryProvider).create(
          reporterId: userId,
          targetId: talent.id,
          targetType: ReportTargetType.talent,
          reason: reason.trim(),
        );
    if (!mounted) return;
    context.showSnack(AppStrings.reportSubmitted);
  }
}

// ---------------------------------------------------------------------------
// Cover + avatar header
// ---------------------------------------------------------------------------

class _CoverHeader extends StatelessWidget {
  const _CoverHeader({
    required this.talent,
    required this.isFavorite,
    required this.onFavorite,
    required this.onShare,
    required this.onReport,
  });

  final TalentModel talent;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onShare;
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      stretch: true,
      expandedHeight: 300,
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsetsDirectional.only(start: AppSpacing.lg),
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
        background: Stack(
          fit: StackFit.expand,
          children: [
            KrNetworkImage(
              imageUrl: talent.coverUrl.isNotEmpty ? talent.coverUrl : talent.headshotUrl,
              errorIcon: Iconsax.profile_circle,
            ),
            const DecoratedBox(decoration: BoxDecoration(gradient: AppColors.gradientHero)),
            PositionedDirectional(
              start: AppSpacing.lg,
              bottom: AppSpacing.lg,
              child: KrAvatar(
                imageUrl: talent.headshotUrl,
                initials: talent.initials,
                size: KrAvatarSize.xl,
                verified: talent.isVerified,
                borderColor: AppColors.background,
                heroTag: 'talent-${talent.id}',
              ),
            ),
          ],
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

// ---------------------------------------------------------------------------
// Body
// ---------------------------------------------------------------------------

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({
    required this.talent,
    required this.isOwner,
    required this.reviews,
    required this.contacting,
    required this.onContact,
    required this.onEdit,
  });

  final TalentModel talent;
  final bool isOwner;
  final List<ReviewModel> reviews;
  final bool contacting;
  final VoidCallback onContact;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(talent.fullName, style: AppTextStyles.sectionTitle),
              ),
              if (isOwner)
                PremiumButton.secondary(label: AppStrings.edit, icon: Iconsax.edit_2, size: PremiumButtonSize.small, onPressed: onEdit),
            ],
          ).animate().fadeIn(duration: 350.ms),
          const SizedBox(height: 6),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _MetaItem(icon: Iconsax.user_tag, label: talent.category.label),
              _MetaItem(icon: Iconsax.location, label: talent.locationLabel),
            ],
          ).animate().fadeIn(delay: 60.ms, duration: 350.ms),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const Icon(Iconsax.star_1, size: 16, color: AppColors.gold),
              const SizedBox(width: 4),
              Text(
                '${Formatters.formatRating(talent.rating)} · ${AppStrings.reviewsCount(talent.reviewCount)}',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(width: AppSpacing.md),
              _AvailabilityBadge(status: talent.availability),
            ],
          ).animate().fadeIn(delay: 100.ms, duration: 350.ms),
          const SizedBox(height: AppSpacing.lg),
          if (!isOwner)
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: PremiumButton.primary(
                    label: AppStrings.contact,
                    icon: Iconsax.message,
                    isLoading: contacting,
                    onPressed: onContact,
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 140.ms, duration: 350.ms),
          const SizedBox(height: AppSpacing.xl),
          _Section(title: AppStrings.about, child: Text(talent.biography.orPlaceholder(AppStrings.noBioYet), style: AppTextStyles.bodyMuted)),
          _Section(
            title: AppStrings.skills,
            child: talent.skills.isEmpty
                ? _EmptyLine(AppStrings.noSkillsListed)
                : _ChipWrap(items: talent.skills),
          ),
          _Section(
            title: AppStrings.languages,
            child: talent.languages.isEmpty
                ? _EmptyLine(AppStrings.noLanguagesListed)
                : _ChipWrap(items: talent.languages, icon: Iconsax.language_square),
          ),
          _Section(
            title: AppStrings.physical,
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: AppSpacing.sm,
              crossAxisSpacing: AppSpacing.sm,
              childAspectRatio: 1.15,
              children: [
                KrStatCard(icon: Iconsax.cake, value: '${talent.age}', label: AppStrings.age, compact: true),
                KrStatCard(icon: Iconsax.ruler, value: Formatters.formatHeight(talent.heightCm), label: AppStrings.height, animateCounter: false, compact: true),
                KrStatCard(icon: Iconsax.weight, value: AppStrings.weightKgValue(talent.weightKg), label: AppStrings.weight, animateCounter: false, compact: true),
                KrStatCard(icon: Iconsax.eye, value: DisplayLocalizer.t(talent.eyeColor).orPlaceholder('—'), label: AppStrings.eyes, animateCounter: false, compact: true),
                KrStatCard(icon: Iconsax.scissor, value: DisplayLocalizer.t(talent.hairColor).orPlaceholder('—'), label: AppStrings.hair, animateCounter: false, compact: true),
                KrStatCard(icon: Iconsax.medal_star, value: talent.experienceLevel.label, label: AppStrings.level, animateCounter: false, compact: true),
              ],
            ),
          ),
          _Section(
            title: AppStrings.experience,
            child: talent.experience.isEmpty
                ? _EmptyLine(AppStrings.noExperienceCredits)
                : Column(
                    children: talent.experience
                        .map<Widget>((e) => _ExperienceRow(entry: e))
                        .toList()
                        .separatedBy(const SizedBox(height: AppSpacing.sm)),
                  ),
          ),
          _Section(
            title: AppStrings.education,
            child: Text(
              talent.education.isEmpty
                  ? AppStrings.notSpecified
                  : DisplayLocalizer.t(talent.education),
              style: AppTextStyles.bodyMuted,
            ),
          ),
          _Section(
            title: AppStrings.portfolio,
            child: talent.galleryUrls.isEmpty && talent.portfolioUrls.isEmpty
                ? _EmptyLine(AppStrings.noPortfolioImages)
                : _PortfolioGrid(urls: [...talent.portfolioUrls, ...talent.galleryUrls]),
          ),
          if (talent.videoThumbnails.isNotEmpty)
            _Section(title: AppStrings.videos, child: _VideoRow(thumbnails: talent.videoThumbnails)),
          _Section(
            title: AppStrings.reviews,
            child: reviews.isEmpty
                ? _EmptyLine(AppStrings.noReviewsYet)
                : Column(
                    children: reviews
                        .take(6)
                        .map<Widget>((r) => _ReviewCard(review: r))
                        .toList()
                        .separatedBy(const SizedBox(height: AppSpacing.sm)),
                  ),
          ),
          if (talent.socialLinks.isNotEmpty)
            _Section(
              title: AppStrings.social,
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: talent.socialLinks.entries
                    .map((e) => _SocialChip(platform: e.key, handle: e.value))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textMuted),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.bodySmall),
      ],
    );
  }
}

class _AvailabilityBadge extends StatelessWidget {
  const _AvailabilityBadge({required this.status});
  final AvailabilityStatus status;

  @override
  Widget build(BuildContext context) {
    final kind = switch (status) {
      AvailabilityStatus.available => KrStatusKind.success,
      AvailabilityStatus.busy => KrStatusKind.error,
      AvailabilityStatus.limited => KrStatusKind.warning,
    };
    return StatusBadge(label: status.label, kind: kind);
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.subsectionTitle),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.04, end: 0);
  }
}

class _EmptyLine extends StatelessWidget {
  const _EmptyLine(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.bodySmall);
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

class _ExperienceRow extends StatelessWidget {
  const _ExperienceRow({required this.entry});
  final ExperienceEntry entry;

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      border: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
            child: Text('${entry.year}', style: AppTextStyles.caption.copyWith(color: AppColors.gold, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(DisplayLocalizer.t(entry.title), style: AppTextStyles.cardTitle.copyWith(fontSize: 15)),
                const SizedBox(height: 2),
                Text(DisplayLocalizer.t(entry.role), style: AppTextStyles.bodySmall.copyWith(color: AppColors.gold)),
                if (entry.description != null && entry.description!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(DisplayLocalizer.t(entry.description!), style: AppTextStyles.bodySmall),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PortfolioGrid extends StatelessWidget {
  const _PortfolioGrid({required this.urls});
  final List<String> urls;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
      ),
      itemCount: urls.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: AppRadius.radiusSm,
          child: KrNetworkImage(imageUrl: urls[index], errorIcon: Iconsax.gallery_slash),
        );
      },
    );
  }
}

class _VideoRow extends StatelessWidget {
  const _VideoRow({required this.thumbnails});
  final List<String> thumbnails;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: thumbnails.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: AppRadius.radiusSm,
            child: SizedBox(
              width: 150,
              height: 96,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  KrNetworkImage(imageUrl: thumbnails[index], errorIcon: Iconsax.video_square),
                  const DecoratedBox(decoration: BoxDecoration(color: Color(0x33000000))),
                  Center(
                    child: Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.45), shape: BoxShape.circle),
                      child: const Icon(Iconsax.play, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});
  final ReviewModel review;

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(review.reviewerName.orPlaceholder(AppStrings.kastRolzUser), style: AppTextStyles.cardTitle.copyWith(fontSize: 14)),
              ),
              Row(
                children: List.generate(5, (i) {
                  return Icon(
                    i < review.rating.round() ? Iconsax.star_1 : Iconsax.star,
                    size: 13,
                    color: AppColors.gold,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(review.createdAt.formattedDate, style: AppTextStyles.caption),
          if (review.comment.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(review.comment, style: AppTextStyles.bodySmall),
          ],
        ],
      ),
    );
  }
}

class _SocialChip extends StatelessWidget {
  const _SocialChip({required this.platform, required this.handle});
  final String platform;
  final String handle;

  IconData get _icon {
    switch (platform.toLowerCase()) {
      case 'instagram':
        return Iconsax.instagram;
      case 'facebook':
        return Iconsax.facebook;
      case 'whatsapp':
        return Iconsax.whatsapp;
      default:
        return Iconsax.link;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.showSnack(AppStrings.openingPlatform(platform)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: AppRadius.radiusFull,
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_icon, size: 14, color: AppColors.gold),
            const SizedBox(width: 6),
            Text(handle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary)),
          ],
        ),
      ),
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
