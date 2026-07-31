import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// KAST-ROLZ's app bar — transparent by default so hero imagery can bleed
/// underneath, with an optional solid dark fill, a gold-accented back
/// button and a trailing actions row.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
    this.transparent = true,
    this.centerTitle = false,
    this.leadingWidget,
    this.bottom,
    this.elevation = 0,
  });

  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final bool transparent;
  final bool centerTitle;
  final Widget? leadingWidget;
  final PreferredSizeWidget? bottom;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    return AppBar(
      backgroundColor: transparent ? Colors.transparent : AppColors.background,
      elevation: elevation,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: centerTitle,
      titleSpacing: leadingWidget == null && !(showBackButton && canPop) ? AppSpacing.lg : null,
      leading: leadingWidget ??
          (showBackButton && canPop ? _BackButton(onPressed: onBackPressed) : null),
      leadingWidth: leadingWidget == null && !(showBackButton && canPop) ? 0 : 56,
      title: titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 19),
                  overflow: TextOverflow.ellipsis,
                )
              : null),
      actions: actions != null
          ? [...actions!, const SizedBox(width: AppSpacing.sm)]
          : null,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}

class _BackButton extends StatelessWidget {
  const _BackButton({this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.lg),
      child: GestureDetector(
        onTap: onPressed ?? () => Navigator.of(context).maybePop(),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.glass,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: const Icon(Iconsax.arrow_left_2, size: 18, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

/// A round, glassy icon button matching [CustomAppBar]'s trailing actions —
/// use for share/favorite/more icons in a header.
class KrAppBarAction extends StatelessWidget {
  const KrAppBarAction({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.badge = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final bool badge;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.glass,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, size: 18, color: color ?? AppColors.textPrimary),
              if (badge)
                Positioned(
                  top: -1,
                  right: -1,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.background, width: 1.5),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
