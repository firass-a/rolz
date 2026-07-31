import 'package:equatable/equatable.dart';

/// A 1:1 (or group, in the future) chat thread between users.
class ConversationModel extends Equatable {
  final String id;
  final List<String> participantIds;
  final String lastMessage;
  final DateTime lastMessageAt;
  final Map<String, int> unreadCount;
  final Map<String, bool> isTyping;
  final DateTime updatedAt;

  const ConversationModel({
    required this.id,
    required this.participantIds,
    this.lastMessage = '',
    required this.lastMessageAt,
    this.unreadCount = const {},
    this.isTyping = const {},
    required this.updatedAt,
  });

  int unreadCountFor(String userId) => unreadCount[userId] ?? 0;

  bool isTypingFor(String userId) => isTyping[userId] ?? false;

  String otherParticipant(String currentUserId) =>
      participantIds.firstWhere((id) => id != currentUserId, orElse: () => '');

  ConversationModel copyWith({
    String? id,
    List<String>? participantIds,
    String? lastMessage,
    DateTime? lastMessageAt,
    Map<String, int>? unreadCount,
    Map<String, bool>? isTyping,
    DateTime? updatedAt,
  }) {
    return ConversationModel(
      id: id ?? this.id,
      participantIds: participantIds ?? this.participantIds,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      unreadCount: unreadCount ?? this.unreadCount,
      isTyping: isTyping ?? this.isTyping,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        participantIds,
        lastMessage,
        lastMessageAt,
        unreadCount,
        isTyping,
        updatedAt,
      ];
}
