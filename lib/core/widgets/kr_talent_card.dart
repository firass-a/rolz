import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../utils/formatters.dart';
import 'kr_badge.dart';
import 'kr_card.dart';
import 'kr_network_image.dart';

enum KrTalentCardVariant { grid, list }

/// Compact talent card. Name/meta sit on a gradient overlay so fixed-height
/// rails never clip or overlap text. No floating rating that collides with
/// the name strip.
class KrTalentCard extends StatelessWidget {
  const KrTalentCard({
    super.key,
    required this.name,
    this.imageUrl,
    this.category,
    this.city,
    this.verified = false,
    this.rating,
    this.variant = KrTalentCardVariant.grid,
    this.onTap,
    this.heroTag,
    this.isFavorite = false,
    this.onFavoriteTap,
    this.available = false,
  });

  final String name;
  final String? imageUrl;
  final String? category;
  final String? city;
  final bool verified;
  final double? rating;
  final KrTalentCardVariant variant;
  final VoidCallback? onTap;
  final Object? heroTag;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;
  final bool available;

  @override
  Widget build(BuildContext context) {
    return variant == KrTalentCardVariant.grid ? _buildGrid(context) : _buildList(context);
  }

  Widget _buildGrid(BuildContext context) {
    Widget image = KrNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      errorIcon: Iconsax.profile_circle,
    );
    if (heroTag != null) image = Hero(tag: heroTag!, child: image);

    return AnimatedCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      borderRadius: AppRadius.radiusMd,
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Stack(
          fit: StackFit.expand,
          children: [
            image,
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x33000000),
                    Colors.transparent,
                    Color(0x00000000),
                    Color(0xF2000000),
                  ],
                  stops: [0, 0.25, 0.55, 1],
                ),
              ),
            ),
            if (available)
              const Positioned(
                top: 8,
                left: 8,
                child: StatusBadge.success('Available', showDot: true, filled: false),
              ),
            if (onFavoriteTap != null)
              Positioned(
                top: 8,
                right: 8,
                child: _FavoriteButton(isFavorite: isFavorite, onTap: onFavoriteTap),
              ),
            if (rating != null)
              Positioned(
                top: available ? 40 : 8,
                left: 8,
                child: _RatingPill(rating: rating!),
              ),
            Positioned(
              left: 10,
              right: 10,
              bottom: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.cardTitle.copyWith(
                            color: Colors.white,
                            fontSize: 14,
                            height: 1.2,
                          ),
                        ),
                      ),
                      if (verified) ...[
                        const SizedBox(width: 4),
                        const VerifiedBadge(compact: true),
                      ],
                    ],
                  ),
                  if (category != null || city != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      [if (category != null) category, if (city != null) city].join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white70,
                        fontSize: 11,
                        height: 1.2,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    Widget image = KrNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      errorIcon: Iconsax.profile_circle,
      borderRadius: AppRadius.radiusSm,
    );
    if (heroTag != null) image = Hero(tag: heroTag!, child: image);

    return AnimatedCard(
      onTap: onTap,
      child: Row(
        children: [
          SizedBox(width: 64, height: 80, child: image),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.cardTitle,
                      ),
                    ),
                    if (verified) ...[
                      const SizedBox(width: 6),
                      const VerifiedBadge(compact: true),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                if (category != null || city != null)
                  Text(
                    [if (category != null) category, if (city != null) city].join(' · '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall,
                  ),
                if (rating != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Iconsax.star_1, size: 13, color: AppColors.gold),
                      const SizedBox(width: 4),
                      Text(
                        Formatters.formatRating(rating),
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.gold,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                      if (available) ...[
                        const SizedBox(width: AppSpacing.sm),
                        const StatusBadge.success('Available'),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (onFavoriteTap != null)
            _FavoriteButton(isFavorite: isFavorite, onTap: onFavoriteTap),
        ],
      ),
    );
  }
}

class _RatingPill extends StatelessWidget {
  const _RatingPill({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Iconsax.star_1, size: 11, color: AppColors.gold),
          const SizedBox(width: 3),
          Text(
            Formatters.formatRating(rating),
            style: AppTextStyles.caption.copyWith(
              color: Colors.white,
              fontSize: 10,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.isFavorite, this.onTap});

  final bool isFavorite;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.45),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Icon(
          isFavorite ? Iconsax.heart_copy : Iconsax.heart,
          size: 14,
          color: isFavorite ? AppColors.error : Colors.white,
        ),
      ),
    );
  }
}
