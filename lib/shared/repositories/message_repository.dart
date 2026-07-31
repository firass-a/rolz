/// Simulates a messaging API on top of [ConversationNotifier] and
/// [MessageNotifier].
library;

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../mock/mock_data.dart';
import '../models/models.dart';
import '../providers/message_provider.dart';
import '../providers/recruiter_provider.dart';
import '../providers/talent_provider.dart';

class MessageRepository {
  MessageRepository(this._ref);

  final Ref _ref;

  static const _uuid = Uuid();
  static const _latency = Duration(milliseconds: 250);

  ConversationNotifier get _conversations => _ref.read(conversationProvider.notifier);

  MessageNotifier get _messages => _ref.read(messageProvider.notifier);

  List<ConversationModel> conversationsFor(String userId) =>
      _ref.read(conversationProvider).where((c) => c.participantIds.contains(userId)).toList()
        ..sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));

  List<MessageModel> getMessages(String conversationId) =>
      _ref.read(messageProvider).where((m) => m.conversationId == conversationId).toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

  /// Finds an existing 1:1 conversation between [participantIds] or creates
  /// a new empty one.
  Future<ConversationModel> createConversation(List<String> participantIds) async {
    await Future.delayed(_latency);
    final existing = _ref.read(conversationProvider).firstWhereOrNull(
          (c) =>
              c.participantIds.length == participantIds.length &&
              c.participantIds.toSet().containsAll(participantIds),
        );
    if (existing != null) return existing;

    final now = DateTime.now();
    final conversation = ConversationModel(
      id: _uuid.v4(),
      participantIds: participantIds,
      lastMessage: '',
      lastMessageAt: now,
      unreadCount: {for (final id in participantIds) id: 0},
      isTyping: {for (final id in participantIds) id: false},
      updatedAt: now,
    );
    _conversations.create(conversation);
    return conversation;
  }

  /// Sends a message and updates the parent conversation's preview/unread
  /// counters for every other participant.
  Future<MessageModel> sendMessage({
    required String conversationId,
    required String senderId,
    required String content,
    MessageType type = MessageType.text,
    String? imageUrl,
  }) async {
    await Future.delayed(_latency);
    final now = DateTime.now();
    final message = MessageModel(
      id: _uuid.v4(),
      conversationId: conversationId,
      senderId: senderId,
      content: content,
      type: type,
      imageUrl: imageUrl,
      isRead: false,
      createdAt: now,
    );
    _messages.create(message);
    _conversations.touch(conversationId: conversationId, lastMessage: content, lastMessageAt: now);

    final conversation = _conversations.getById(conversationId);
    if (conversation != null) {
      for (final participantId in conversation.participantIds) {
        if (participantId != senderId) {
          _conversations.incrementUnread(conversationId, participantId);
        }
      }
    }
    return message;
  }

  Future<void> markRead(String conversationId, String readerId) async {
    await Future.delayed(_latency);
    _messages.markConversationRead(conversationId, readerId);
    _conversations.markRead(conversationId, readerId);
  }

  void setTyping(String conversationId, String userId, bool isTyping) {
    _conversations.setTyping(conversationId, userId, isTyping);
  }

  /// Text-searches [query] against the other participant's name and the
  /// conversation's last message.
  List<ConversationModel> searchConversations(String query, String currentUserId) {
    final all = conversationsFor(currentUserId);
    if (query.trim().isEmpty) return all;
    final q = query.trim().toLowerCase();
    return all.where((c) {
      final otherId = c.otherParticipant(currentUserId);
      final name = _participantName(otherId).toLowerCase();
      return name.contains(q) || c.lastMessage.toLowerCase().contains(q);
    }).toList();
  }

  String _participantName(String userId) {
    final talent = _ref.read(talentByUserIdProvider(userId));
    if (talent != null) return talent.fullName;
    final recruiter = _ref.read(recruiterByUserIdProvider(userId));
    if (recruiter != null) {
      return recruiter.fullName.isNotEmpty ? recruiter.fullName : recruiter.companyName;
    }
    return MockData.userById(userId)?.fullName ?? '';
  }
}

final messageRepositoryProvider = Provider<MessageRepository>((ref) => MessageRepository(ref));
