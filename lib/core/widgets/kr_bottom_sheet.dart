import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_strings.dart';
import '../theme/app_text_styles.dart';
import 'kr_button.dart';

/// Shows a KAST-ROLZ styled modal bottom sheet — dark surface, rounded top
/// corners, a drag handle, and safe-area aware padding.
Future<T?> showKrBottomSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool isScrollControlled = true,
  bool showDragHandle = true,
  bool isDismissible = true,
  bool enableDrag = true,
  Color? backgroundColor,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    backgroundColor: backgroundColor ?? AppColors.surface,
    barrierColor: AppColors.overlay,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showDragHandle) ...[
                const SizedBox(height: AppSpacing.sm),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
              Flexible(child: Builder(builder: builder)),
            ],
          ),
        ),
      );
    },
  );
}

/// A destructive/confirmation action sheet — icon, title, body copy and
/// two stacked buttons (confirm + cancel). Use for delete, ban, logout,
/// or any irreversible action that deserves a second thought.
class ConfirmationSheet extends StatelessWidget {
  const ConfirmationSheet({
    super.key,
    required this.title,
    required this.body,
    this.icon = Iconsax.warning_2,
    this.confirmLabel = AppStrings.confirm,
    this.cancelLabel = AppStrings.cancel,
    this.isDanger = true,
    this.onConfirm,
  });

  /// Convenience preset for delete confirmations.
  const ConfirmationSheet.delete({
    super.key,
    this.title = AppStrings.confirmDeleteTitle,
    this.body = AppStrings.confirmDeleteBody,
    this.confirmLabel = AppStrings.delete,
    this.cancelLabel = AppStrings.cancel,
    this.onConfirm,
  })  : icon = Iconsax.trash,
        isDanger = true;

  /// Convenience preset for banning a user.
  const ConfirmationSheet.ban({
    super.key,
    this.title = AppStrings.confirmBanTitle,
    this.body = AppStrings.confirmBanBody,
    this.confirmLabel = 'Ban User',
    this.cancelLabel = AppStrings.cancel,
    this.onConfirm,
  })  : icon = Iconsax.shield_cross,
        isDanger = true;

  final String title;
  final String body;
  final IconData icon;
  final String confirmLabel;
  final String cancelLabel;
  final bool isDanger;
  final VoidCallback? onConfirm;

  /// Convenience static helper to present this sheet and await the
  /// boolean result (`true` if confirmed).
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String body,
    IconData icon = Iconsax.warning_2,
    String confirmLabel = AppStrings.confirm,
    String cancelLabel = AppStrings.cancel,
    bool isDanger = true,
  }) async {
    final result = await showKrBottomSheet<bool>(
      context,
      builder: (context) => ConfirmationSheet(
        title: title,
        body: body,
        icon: icon,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDanger: isDanger,
        onConfirm: () => Navigator.of(context).pop(true),
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final accent = isDanger ? AppColors.error : AppColors.gold;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: accent.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, color: accent, size: 28),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionTitle.copyWith(fontSize: 21),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            body,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMuted,
          ),
          const SizedBox(height: AppSpacing.xl),
          PremiumButton(
            label: confirmLabel,
            fullWidth: true,
            variant: isDanger ? PremiumButtonVariant.danger : PremiumButtonVariant.primary,
            onPressed: onConfirm ?? () => Navigator.of(context).pop(true),
          ),
          const SizedBox(height: AppSpacing.sm),
          PremiumButton.ghost(
            label: cancelLabel,
            fullWidth: true,
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
    );
  }
}
