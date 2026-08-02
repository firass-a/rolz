import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/app_colors.dart';

/// Thin wrapper around network or asset images that standardises the shimmer
/// placeholder and error state used everywhere media is shown in KAST-ROLZ.
class KrNetworkImage extends StatelessWidget {
  const KrNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.errorIcon = Iconsax.gallery_slash,
  });

  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final IconData errorIcon;

  bool get _isAsset {
    final url = imageUrl;
    return url != null && (url.startsWith('assets/') || url.startsWith('asset:'));
  }

  String get _assetPath {
    final url = imageUrl!;
    return url.startsWith('asset:') ? url.substring('asset:'.length) : url;
  }

  @override
  Widget build(BuildContext context) {
    Widget image;

    if (imageUrl == null || imageUrl!.isEmpty) {
      image = _errorPlaceholder();
    } else if (_isAsset) {
      image = Image.asset(
        _assetPath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => _errorPlaceholder(),
      );
    } else {
      image = CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit,
        fadeInDuration: const Duration(milliseconds: 250),
        placeholder: (context, url) => _shimmerPlaceholder(),
        errorWidget: (context, url, error) => _errorPlaceholder(),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }
    return image;
  }

  Widget _shimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: AppColors.card,
      highlightColor: AppColors.cardElevated,
      period: const Duration(milliseconds: 1400),
      child: Container(
        width: width,
        height: height,
        color: AppColors.card,
      ),
    );
  }

  Widget _errorPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: AppColors.surface,
      alignment: Alignment.center,
      child: Icon(errorIcon, color: AppColors.textMuted, size: 28),
    );
  }
}
