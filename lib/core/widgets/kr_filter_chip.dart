import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// A single pill-shaped filter chip — gold filled when selected, subtle
/// dark outline otherwise.
class KrFilterChip extends StatelessWidget {
  const KrFilterChip({
    super.key,
    required this.label,
    required this.selected,
    this.onTap,
    this.icon,
    this.count,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md + 2, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: selected ? AppColors.gold : AppColors.card,
          borderRadius: AppRadius.radiusFull,
          border: Border.all(
            color: selected ? AppColors.gold : AppColors.border,
            width: 1,
          ),
          boxShadow: selected ? AppShadows.goldSoft : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 15,
                color: selected ? const Color(0xFF14110A) : AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.xs + 2),
            ],
            Text(
              label,
              style: AppTextStyles.buttonSmall.copyWith(
                color: selected ? const Color(0xFF14110A) : AppColors.textSecondary,
              ),
            ),
            if (count != null && count! > 0) ...[
              const SizedBox(width: AppSpacing.xs + 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.black.withValues(alpha: 0.15)
                      : AppColors.gold.withValues(alpha: 0.15),
                  borderRadius: AppRadius.radiusFull,
                ),
                child: Text(
                  '$count',
                  style: AppTextStyles.caption.copyWith(
                    color: selected ? const Color(0xFF14110A) : AppColors.gold,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Data model for a single entry rendered by [FilterChipBar].
class FilterChipItem {
  const FilterChipItem({
    required this.value,
    required this.label,
    this.icon,
    this.count,
  });

  final String value;
  final String label;
  final IconData? icon;
  final int? count;
}

/// A horizontally scrollable row of [KrFilterChip]s with single-select
/// behaviour — perfect for category/casting-type/status filters atop a
/// list or grid.
class FilterChipBar extends StatelessWidget {
  const FilterChipBar({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onSelected,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
    this.spacing = AppSpacing.sm,
    this.allowDeselect = false,
  });

  final List<FilterChipItem> items;
  final String? selectedValue;
  final ValueChanged<String?> onSelected;
  final EdgeInsetsGeometry padding;
  final double spacing;
  final bool allowDeselect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: padding,
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(width: spacing),
        itemBuilder: (context, index) {
          final item = items[index];
          final selected = item.value == selectedValue;
          return KrFilterChip(
            label: item.label,
            icon: item.icon,
            count: item.count,
            selected: selected,
            onTap: () {
              if (selected && allowDeselect) {
                onSelected(null);
              } else {
                onSelected(item.value);
              }
            },
          );
        },
      ),
    );
  }
}
