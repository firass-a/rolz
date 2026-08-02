import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../constants/app_colors.dart';
import '../theme/app_text_styles.dart';

enum KrAvatarSize { xs, sm, md, lg, xl }

extension on KrAvatarSize {
  double get diameter {
    switch (this) {
      case KrAvatarSize.xs:
        return 28;
      case KrAvatarSize.sm:
        return 36;
      case KrAvatarSize.md:
        return 48;
      case KrAvatarSize.lg:
        return 64;
      case KrAvatarSize.xl:
        return 96;
    }
  }

  double get badgeSize {
    switch (this) {
      case KrAvatarSize.xs:
        return 10;
      case KrAvatarSize.sm:
        return 13;
      case KrAvatarSize.md:
        return 16;
      case KrAvatarSize.lg:
        return 20;
      case KrAvatarSize.xl:
        return 26;
    }
  }

  double get borderWidth {
    switch (this) {
      case KrAvatarSize.xs:
      case KrAvatarSize.sm:
        return 1.5;
      case KrAvatarSize.md:
        return 2;
      case KrAvatarSize.lg:
      case KrAvatarSize.xl:
        return 3;
    }
  }
}

/// KAST-ROLZ's circular avatar — cached network image with an initials
/// fallback and an optional gold "verified" badge overlay.
class KrAvatar extends StatelessWidget {
  const KrAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.size = KrAvatarSize.md,
    this.verified = false,
    this.online = false,
    this.borderColor,
    this.onTap,
    this.heroTag,
  });

  final String? imageUrl;
  final String? initials;
  final KrAvatarSize size;
  final bool verified;
  final bool online;
  final Color? borderColor;
  final VoidCallback? onTap;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    final diameter = size.diameter;
    final border = size.borderWidth;
    final inner = diameter - border * 2;

    Widget image = imageUrl != null && imageUrl!.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: imageUrl!,
            width: inner,
            height: inner,
            fit: BoxFit.cover,
            placeholder: (context, url) => _fallback(inner),
            errorWidget: (context, url, error) => _fallback(inner),
          )
        : _fallback(inner);

    Widget avatar = Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.cardElevated,
        border: Border.all(
          color: borderColor ?? AppColors.border,
          width: border,
        ),
      ),
      alignment: Alignment.center,
      child: ClipOval(
        child: SizedBox(
          width: inner,
          height: inner,
          child: image,
        ),
      ),
    );

    if (heroTag != null) {
      avatar = Hero(tag: heroTag!, child: avatar);
    }

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: diameter,
        height: diameter,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            avatar,
            if (verified)
              PositionedDirectional(
                end: -1,
                bottom: -1,
                child: _VerifiedDot(size: size.badgeSize),
              ),
            if (online && !verified)
              PositionedDirectional(
                end: 0,
                bottom: 0,
                child: Container(
                  width: size.badgeSize * 0.75,
                  height: size.badgeSize * 0.75,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.background, width: 2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _fallback(double diameter) {
    return Container(
      width: diameter,
      height: diameter,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: AppColors.gradientDark,
      ),
      child: Text(
        (initials ?? '?').toUpperCase(),
        style: AppTextStyles.cardTitle.copyWith(
          color: AppColors.gold,
          fontSize: diameter * 0.34,
        ),
      ),
    );
  }
}

class _VerifiedDot extends StatelessWidget {
  const _VerifiedDot({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.gold,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.background, width: size * 0.15),
      ),
      child: Icon(Iconsax.verify, size: size * 0.62, color: const Color(0xFF14110A)),
    );
  }
}
