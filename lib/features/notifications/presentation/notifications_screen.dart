import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/providers.dart';

IconData _iconFor(NotificationType type) {
  switch (type) {
    case NotificationType.like:
      return Iconsax.heart;
    case NotificationType.application:
      return Iconsax.send_2;
    case NotificationType.acceptance:
      return Iconsax.tick_circle;
    case NotificationType.rejection:
      return Iconsax.close_circle;
    case NotificationType.message:
      return Iconsax.message;
    case NotificationType.reminder:
      return Iconsax.clock;
    case NotificationType.verification:
      return Iconsax.shield_tick;
    case NotificationType.system:
      return Iconsax.notification;
  }
}

Color _colorFor(NotificationType type) {
  switch (type) {
    case NotificationType.acceptance:
    case NotificationType.verification:
      return AppColors.success;
    case NotificationType.rejection:
      return AppColors.error;
    case NotificationType.reminder:
      return AppColors.warning;
    default:
      return AppColors.gold;
  }
}

/// The signed-in user's activity feed — likes, applications, messages and
/// system notices, newest first, with a one-tap "mark all read".
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: AppStrings.notifications,
        actions: user == null
            ? null
            : [
                TextButton(
                  onPressed: () => ref.read(notificationProvider.notifier).markAllRead(user.id),
                  child: Text(AppStrings.markAllRead, style: AppTextStyles.buttonSmall.copyWith(color: AppColors.gold)),
                ),
              ],
      ),
      body: user == null
          ? Center(
              child: EmptyState(
                icon: Iconsax.notification,
                title: AppStrings.emptyNotificationsTitle,
                subtitle: AppStrings.emptyNotificationsSubtitle,
              ),
            )
          : _NotificationList(userId: user.id),
    );
  }
}

class _NotificationList extends ConsumerWidget {
  const _NotificationList({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsForUserProvider(userId));

    if (notifications.isEmpty) {
      return Center(
        child: EmptyState(
          icon: Iconsax.notification,
          title: AppStrings.emptyNotificationsTitle,
          subtitle: AppStrings.emptyNotificationsSubtitle,
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      itemCount: notifications.length,
      separatorBuilder: (_, __) => const Divider(height: 1, indent: AppSpacing.lg, endIndent: AppSpacing.lg),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        final color = _colorFor(notification.type);
        return ListTile(
          onTap: () => ref.read(notificationProvider.notifier).markRead(notification.id),
          contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
          leading: Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(_iconFor(notification.type), size: 19, color: color),
          ),
          title: Text(
            notification.title,
            style: AppTextStyles.cardTitle.copyWith(
              fontSize: 15,
              fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w700,
            ),
          ),
          subtitle: Text(
            notification.body,
            style: AppTextStyles.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(notification.createdAt.timeAgo, style: AppTextStyles.caption),
              const SizedBox(height: 6),
              if (!notification.isRead)
                Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle)),
            ],
          ),
        ).animate().fadeIn(delay: (25 * (index % 12)).ms, duration: 280.ms);
      },
    );
  }
}
