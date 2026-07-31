import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

/// Shared shimmer wrapper so every skeleton in the app pulses with the
/// same gold-tinted dark gradient.
class KrShimmer extends StatelessWidget {
  const KrShimmer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.card,
      highlightColor: AppColors.cardElevated,
      period: const Duration(milliseconds: 1400),
      child: child,
    );
  }
}

class _Bone extends StatelessWidget {
  const _Bone({
    this.width,
    this.height = 14,
  });

  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}

/// Skeleton matching the shape of a [KrTalentCard] grid tile.
class KrTalentCardSkeleton extends StatelessWidget {
  const KrTalentCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return KrShimmer(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: AppRadius.radiusMd,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(aspectRatio: 3 / 4, child: Container(color: Colors.white)),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm + 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _Bone(width: 100, height: 14),
                  SizedBox(height: 8),
                  _Bone(width: 60, height: 11),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton matching the shape of a [KrCastingCard].
class KrCastingCardSkeleton extends StatelessWidget {
  const KrCastingCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return KrShimmer(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: AppRadius.radiusMd,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _Bone(width: 160, height: 16),
                  SizedBox(height: 10),
                  _Bone(width: 110, height: 12),
                  SizedBox(height: 8),
                  _Bone(width: 80, height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for a profile header — big circular avatar + name/subtitle
/// lines, used while a talent/recruiter profile is loading.
class KrProfileHeaderSkeleton extends StatelessWidget {
  const KrProfileHeaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return KrShimmer(
      child: Column(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          ),
          const SizedBox(height: AppSpacing.md),
          const _Bone(width: 140, height: 18),
          const SizedBox(height: 8),
          const _Bone(width: 90, height: 12),
        ],
      ),
    );
  }
}

/// A generic vertical list of shimmering rows — useful for messages,
/// notifications and settings-style lists while data loads.
class KrListSkeleton extends StatelessWidget {
  const KrListSkeleton({super.key, this.itemCount = 6, this.itemHeight = 72});

  final int itemCount;
  final double itemHeight;

  @override
  Widget build(BuildContext context) {
    return KrShimmer(
      child: Column(
        children: List.generate(itemCount, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                Container(
                  width: itemHeight - 24,
                  height: itemHeight - 24,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _Bone(width: double.infinity, height: 14),
                      SizedBox(height: 8),
                      _Bone(width: 120, height: 11),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

/// A responsive grid of [KrTalentCardSkeleton]s — drop-in replacement for
/// a talent grid while the first page loads.
class KrGridSkeleton extends StatelessWidget {
  const KrGridSkeleton({
    super.key,
    this.itemCount = 6,
    this.crossAxisCount = 2,
  });

  final int itemCount;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.62,
      ),
      itemBuilder: (context, index) => const KrTalentCardSkeleton(),
    );
  }
}
