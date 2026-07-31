import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../constants/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/formatters.dart';
import 'kr_card.dart';
import 'kr_network_image.dart';

/// Casting-call card. Compact overlay layout avoids overflow in fixed-height
/// horizontal rails; richer meta stays below the banner for list feeds.
class KrCastingCard extends StatelessWidget {
  const KrCastingCard({
    super.key,
    required this.title,
    this.bannerUrl,
    this.role,
    this.location,
    this.salaryLabel,
    this.deadline,
    this.featured = false,
    this.urgent = false,
    this.onTap,
    this.isFavorite = false,
    this.onFavoriteTap,
    this.companyName,
    this.heroTag,
    this.compact = false,
  });

  final String title;
  final String? bannerUrl;
  final String? role;
  final String? location;
  final String? salaryLabel;
  final DateTime? deadline;
  final bool featured;
  final bool urgent;
  final VoidCallback? onTap;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;
  final String? companyName;
  final Object? heroTag;

  /// When true, all text sits on the banner (safe for fixed-height rails).
  final bool compact;

  @override
  Widget build(BuildContext context) {
    Widget banner = KrNetworkImage(
      imageUrl: bannerUrl,
      fit: BoxFit.cover,
      errorIcon: Iconsax.video_square,
    );
    if (heroTag != null) banner = Hero(tag: heroTag!, child: banner);

    if (compact) {
      return AnimatedCard(
        onTap: onTap,
        padding: EdgeInsets.zero,
        elevated: featured,
        borderColor: featured ? AppColors.gold.withValues(alpha: 0.5) : null,
        child: AspectRatio(
          aspectRatio: 16 / 10,
          child: Stack(
            fit: StackFit.expand,
            children: [
              banner,
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x33000000), Colors.transparent, Color(0xF2000000)],
                    stops: [0, 0.4, 1],
                  ),
                ),
              ),
              Positioned(top: 8, left: 8, child: _ribbons()),
              if (onFavoriteTap != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: _FavoriteButton(isFavorite: isFavorite, onTap: onFavoriteTap),
                ),
              Positioned(
                left: 10,
                right: 10,
                bottom: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.cardTitle.copyWith(color: Colors.white, height: 1.2),
                    ),
                    if (role != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        role!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.goldLight, height: 1.2),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      [
                        if (location != null) location,
                        if (salaryLabel != null) salaryLabel,
                      ].whereType<String>().join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return AnimatedCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      elevated: featured,
      borderColor: featured ? AppColors.gold.withValues(alpha: 0.5) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              fit: StackFit.expand,
              children: [
                banner,
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Color(0x99000000)],
                    ),
                  ),
                ),
                Positioned(top: 8, left: 8, child: _ribbons()),
                if (onFavoriteTap != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: _FavoriteButton(isFavorite: isFavorite, onTap: onFavoriteTap),
                  ),
                if (companyName != null)
                  Positioned(
                    left: 12,
                    bottom: 8,
                    right: 12,
                    child: Text(
                      companyName!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.overline.copyWith(color: AppColors.goldLight),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.cardTitle.copyWith(height: 1.25),
                ),
                if (role != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    role!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.gold),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  [
                    if (location != null) location,
                    if (salaryLabel != null) salaryLabel,
                    if (deadline != null) Formatters.formatDeadline(deadline),
                  ].whereType<String>().join(' · '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ribbons() {
    return Row(
      children: [
        if (featured) ...[
          const _RibbonBadge(icon: Iconsax.crown_1, label: 'Featured', color: AppColors.gold),
          if (urgent) const SizedBox(width: 6),
        ],
        if (urgent) const _RibbonBadge(icon: Iconsax.flag, label: 'Urgent', color: AppColors.error),
      ],
    );
  }
}

class _RibbonBadge extends StatelessWidget {
  const _RibbonBadge({required this.icon, required this.label, required this.color});

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: const Color(0xFF14110A)),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: const Color(0xFF14110A),
              fontWeight: FontWeight.w800,
              height: 1.1,
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
