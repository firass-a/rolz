import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../utils/formatters.dart';
import 'kr_badge.dart';
import 'kr_card.dart';
import 'kr_network_image.dart';

/// A compact agency/company card — square logo, name, verified badge and
/// a talent/casting count line. Works well in horizontal rails or grids.
class KrAgencyCard extends StatelessWidget {
  const KrAgencyCard({
    super.key,
    required this.name,
    this.logoUrl,
    this.talentCount,
    this.castingCount,
    this.verified = false,
    this.location,
    this.onTap,
    this.width,
  });

  final String name;
  final String? logoUrl;
  final int? talentCount;
  final int? castingCount;
  final bool verified;
  final String? location;
  final VoidCallback? onTap;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      onTap: onTap,
      width: width,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                clipBehavior: Clip.antiAlias,
                child: KrNetworkImage(
                  imageUrl: logoUrl,
                  fit: BoxFit.cover,
                  errorIcon: Iconsax.buildings,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.cardTitle.copyWith(fontSize: 15),
                          ),
                        ),
                        if (verified) ...[
                          const SizedBox(width: 4),
                          const VerifiedBadge(compact: true),
                        ],
                      ],
                    ),
                    if (location != null) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Iconsax.location, size: 12, color: AppColors.textMuted),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(
                              location!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (talentCount != null || castingCount != null) ...[
            const SizedBox(height: AppSpacing.md),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                if (talentCount != null)
                  _StatChip(
                    icon: Iconsax.profile_2user,
                    value: Formatters.formatCount(talentCount!),
                    label: 'Talents',
                  ),
                if (talentCount != null && castingCount != null)
                  const SizedBox(width: AppSpacing.lg),
                if (castingCount != null)
                  _StatChip(
                    icon: Iconsax.briefcase,
                    value: Formatters.formatCount(castingCount!),
                    label: 'Castings',
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.icon, required this.value, required this.label});

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.gold),
        const SizedBox(width: 5),
        Text(
          value,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 3),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}
