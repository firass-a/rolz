/// Riverpod state for [ConversationModel]s and [MessageModel]s.
library;

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mock/mock_data.dart';
import '../models/models.dart';

class ConversationNotifier extends Notifier<List<ConversationModel>> {
  @override
  List<ConversationModel> build() {
    MockData.init();
    return List<ConversationModel>.from(MockData.conversations);
  }

  ConversationModel? getById(String id) => state.firstWhereOrNull((c) => c.id == id);

  void create(ConversationModel conversation) {
    state = [conversation, ...state];
  }

  void update(ConversationModel conversation) {
    state = [
      for (final c in state) if (c.id == conversation.id) conversation else c,
    ];
  }

  void delete(String id) {
    state = state.where((c) => c.id != id).toList();
  }

  void setTyping(String conversationId, String userId, bool isTyping) {
    state = [
      for (final c in state)
        if (c.id == conversationId)
          c.copyWith(isTyping: {...c.isTyping, userId: isTyping})
        else
          c,
    ];
  }

  void markRead(String conversationId, String userId) {
    state = [
      for (final c in state)
        if (c.id == conversationId)
          c.copyWith(unreadCount: {...c.unreadCount, userId: 0})
        else
          c,
    ];
  }

  void incrementUnread(String conversationId, String userId) {
    state = [
      for (final c in state)
        if (c.id == conversationId)
          c.copyWith(unreadCount: {...c.unreadCount, userId: c.unreadCountFor(userId) + 1})
        else
          c,
    ];
  }

  void touch({
    required String conversationId,
    required String lastMessage,
    required DateTime lastMessageAt,
  }) {
    state = [
      for (final c in state)
        if (c.id == conversationId)
          c.copyWith(lastMessage: lastMessage, lastMessageAt: lastMessageAt, updatedAt: lastMessageAt)
        else
          c,
    ];
  }
}

class MessageNotifier extends Notifier<List<MessageModel>> {
  @override
  List<MessageModel> build() {
    MockData.init();
    return List<MessageModel>.from(MockData.messages);
  }

  void create(MessageModel message) {
    state = [...state, message];
  }

  void update(MessageModel message) {
    state = [
      for (final m in state) if (m.id == message.id) message else m,
    ];
  }

  void delete(String id) {
    state = state.where((m) => m.id != id).toList();
  }

  void markConversationRead(String conversationId, String readerId) {
    state = [
      for (final m in state)
        if (m.conversationId == conversationId && m.senderId != readerId)
          m.copyWith(isRead: true)
        else
          m,
    ];
  }
}

final conversationProvider =
    NotifierProvider<ConversationNotifier, List<ConversationModel>>(ConversationNotifier.new);

final messageProvider = NotifierProvider<MessageNotifier, List<MessageModel>>(MessageNotifier.new);

final conversationsForUserProvider = Provider.family<List<ConversationModel>, String>((ref, userId) {
  final list = ref.watch(conversationProvider).where((c) => c.participantIds.contains(userId)).toList();
  list.sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));
  return list;
});

final conversationByIdProvider = Provider.family<ConversationModel?, String>((ref, id) {
  return ref.watch(conversationProvider).firstWhereOrNull((c) => c.id == id);
});

final messagesForConversationProvider = Provider.family<List<MessageModel>, String>((ref, conversationId) {
  final list = ref.watch(messageProvider).where((m) => m.conversationId == conversationId).toList();
  list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
  return list;
});

final unreadConversationsCountProvider = Provider.family<int, String>((ref, userId) {
  return ref.watch(conversationsForUserProvider(userId)).where((c) => c.unreadCountFor(userId) > 0).length;
});

final totalUnreadMessagesProvider = Provider.family<int, String>((ref, userId) {
  return ref
      .watch(conversationsForUserProvider(userId))
      .fold<int>(0, (sum, c) => sum + c.unreadCountFor(userId));
});
