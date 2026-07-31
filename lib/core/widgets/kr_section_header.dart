import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_strings.dart';
import '../theme/app_text_styles.dart';

/// The recurring "Section Title" + "See All →" row used above every
/// horizontal rail and list preview across the home/discover screens.
class KrSectionHeader extends StatelessWidget {
  const KrSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel = AppStrings.seeAll,
    this.onActionTap,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
    this.goldLabel,
  });

  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final EdgeInsetsGeometry padding;

  /// Small uppercase eyebrow label rendered above the title, e.g. "CURATED".
  final String? goldLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (goldLabel != null) ...[
                  Text(goldLabel!.toUpperCase(), style: AppTextStyles.goldLabel),
                  const SizedBox(height: 4),
                ],
                Text(
                  title,
                  style: AppTextStyles.sectionTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: AppTextStyles.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (onActionTap != null && actionLabel != null)
            GestureDetector(
              onTap: onActionTap,
              child: Padding(
                padding: const EdgeInsets.only(left: AppSpacing.sm, bottom: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      actionLabel!,
                      style: AppTextStyles.buttonSmall.copyWith(color: AppColors.gold),
                    ),
                    const SizedBox(width: 2),
                    const Icon(Iconsax.arrow_right_3, size: 14, color: AppColors.gold),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
