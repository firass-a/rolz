/// Simulates a notifications API on top of [NotificationNotifier].
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/models.dart';
import '../providers/notification_provider.dart';

class NotificationRepository {
  NotificationRepository(this._ref);

  final Ref _ref;

  static const _uuid = Uuid();
  static const _latency = Duration(milliseconds: 200);

  NotificationNotifier get _notifier => _ref.read(notificationProvider.notifier);

  List<NotificationModel> forUser(String userId) =>
      _ref.read(notificationProvider).where((n) => n.userId == userId).toList();

  int unreadCount(String userId) => forUser(userId).where((n) => !n.isRead).length;

  /// Creates and stores a new notification. Also usable synchronously (no
  /// await) from other repositories that just fired off a side effect.
  NotificationModel add({
    required String userId,
    required NotificationType type,
    required String title,
    String body = '',
    String? relatedId,
  }) {
    final notification = NotificationModel(
      id: _uuid.v4(),
      userId: userId,
      type: type,
      title: title,
      body: body,
      relatedId: relatedId,
      createdAt: DateTime.now(),
    );
    _notifier.add(notification);
    return notification;
  }

  Future<void> markRead(String id) async {
    await Future.delayed(_latency);
    _notifier.markRead(id);
  }

  Future<void> markAllRead(String userId) async {
    await Future.delayed(_latency);
    _notifier.markAllRead(userId);
  }

  Future<void> delete(String id) async {
    await Future.delayed(_latency);
    _notifier.delete(id);
  }
}

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) => NotificationRepository(ref));
