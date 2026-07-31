/// Riverpod state for [NotificationModel]s.
library;

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mock/mock_data.dart';
import '../models/models.dart';

class NotificationNotifier extends Notifier<List<NotificationModel>> {
  @override
  List<NotificationModel> build() {
    MockData.init();
    return List<NotificationModel>.from(MockData.notifications);
  }

  NotificationModel? getById(String id) => state.firstWhereOrNull((n) => n.id == id);

  void add(NotificationModel notification) {
    state = [notification, ...state];
  }

  void update(NotificationModel notification) {
    state = [
      for (final n in state) if (n.id == notification.id) notification else n,
    ];
  }

  void delete(String id) {
    state = state.where((n) => n.id != id).toList();
  }

  void markRead(String id) {
    state = [
      for (final n in state) if (n.id == id) n.copyWith(isRead: true) else n,
    ];
  }

  void markAllRead(String userId) {
    state = [
      for (final n in state) if (n.userId == userId) n.copyWith(isRead: true) else n,
    ];
  }
}

final notificationProvider =
    NotifierProvider<NotificationNotifier, List<NotificationModel>>(NotificationNotifier.new);

final notificationsForUserProvider = Provider.family<List<NotificationModel>, String>((ref, userId) {
  final list = ref.watch(notificationProvider).where((n) => n.userId == userId).toList();
  list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return list;
});

final unreadNotificationCountProvider = Provider.family<int, String>((ref, userId) {
  return ref.watch(notificationsForUserProvider(userId)).where((n) => !n.isRead).length;
});
