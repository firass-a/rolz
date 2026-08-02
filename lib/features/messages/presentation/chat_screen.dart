import 'dart:async';
import 'dart:math';

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
import '../../../shared/mock/image_helper.dart';
import '../../../shared/mock/mock_data.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/providers.dart';

const List<String> _kQuickEmojis = [
  '😀', '😂', '😍', '😉', '👍', '🙏', '🎬', '🎭', '✨', '🔥',
  '❤️', '👏', '😎', '🤝', '📸', '🥳', '💯', '😢', '🙌', '⭐',
];

/// Small immutable view-model describing the "other" participant of a
/// conversation, resolved from whichever record (talent, recruiter, or
/// bare user) actually holds their profile data.
class _ChatPeer {
  const _ChatPeer({
    required this.name,
    this.avatarUrl,
    this.verified = false,
    this.online = false,
  });

  final String name;
  final String? avatarUrl;
  final bool verified;
  final bool online;
}

_ChatPeer _resolvePeer(WidgetRef ref, String otherId) {
  final talent = ref.watch(talentByUserIdProvider(otherId));
  final user = MockData.userById(otherId);
  final online = user?.isOnline ?? false;

  if (talent != null) {
    return _ChatPeer(
      name: talent.fullName,
      avatarUrl: talent.headshotUrl,
      verified: talent.isVerified,
      online: online,
    );
  }

  final recruiter = ref.watch(recruiterByUserIdProvider(otherId));
  if (recruiter != null) {
    return _ChatPeer(
      name: recruiter.fullName.isNotEmpty ? recruiter.fullName : recruiter.companyName,
      avatarUrl: recruiter.avatarUrl.isNotEmpty ? recruiter.avatarUrl : recruiter.companyLogo,
      verified: recruiter.isVerified,
      online: online,
    );
  }

  return _ChatPeer(
    name: user?.fullName ?? AppStrings.kastRolzUser,
    avatarUrl: user?.avatarUrl,
    verified: user?.isVerified ?? false,
    online: online,
  );
}

/// Full 1:1 messenger screen for a single [conversationId] — message
/// history, typing indicator, search-in-conversation, and a rich input bar
/// (emoji, mock photo attachment, mock voice note, text).
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.conversationId});

  final String conversationId;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _textController = TextEditingController();
  final _searchController = TextEditingController();
  final _random = Random();

  bool _searching = false;
  String _searchQuery = '';
  bool _hasText = false;

  Timer? _typingOnTimer;
  Timer? _autoReplyTimer;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      final hasText = _textController.text.trim().isNotEmpty;
      if (hasText != _hasText) setState(() => _hasText = hasText);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _markRead());
  }

  void _markRead() {
    final userId = ref.read(currentUserProvider)?.id;
    if (userId == null) return;
    ref.read(messageRepositoryProvider).markRead(widget.conversationId, userId);
  }

  @override
  void dispose() {
    _typingOnTimer?.cancel();
    _autoReplyTimer?.cancel();
    final userId = ref.read(currentUserProvider)?.id;
    if (userId != null) {
      ref.read(messageRepositoryProvider).setTyping(widget.conversationId, userId, false);
    }
    _textController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _simulateReply(String otherId) {
    _typingOnTimer?.cancel();
    _autoReplyTimer?.cancel();
    final repo = ref.read(messageRepositoryProvider);

    _typingOnTimer = Timer(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      repo.setTyping(widget.conversationId, otherId, true);
    });
    _autoReplyTimer = Timer(const Duration(milliseconds: 2400), () {
      if (!mounted) return;
      repo.setTyping(widget.conversationId, otherId, false);
      final replies = AppStrings.autoReplies;
      repo.sendMessage(
        conversationId: widget.conversationId,
        senderId: otherId,
        content: replies[_random.nextInt(replies.length)],
      );
    });
  }

  Future<void> _sendText() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    final userId = ref.read(currentUserProvider)?.id;
    final conversation = ref.read(conversationByIdProvider(widget.conversationId));
    if (userId == null || conversation == null) return;

    _textController.clear();
    await ref.read(messageRepositoryProvider).sendMessage(
          conversationId: widget.conversationId,
          senderId: userId,
          content: text,
        );
    if (!mounted) return;
    _simulateReply(conversation.otherParticipant(userId));
  }

  void _insertEmoji() {
    final emoji = _kQuickEmojis[_random.nextInt(_kQuickEmojis.length)];
    final text = _textController.text;
    final selection = _textController.selection;
    final start = selection.start >= 0 ? selection.start : text.length;
    final end = selection.end >= 0 ? selection.end : text.length;
    final newText = text.replaceRange(start, end, emoji);
    _textController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: start + emoji.length),
    );
  }

  Future<void> _sendImage() async {
    final userId = ref.read(currentUserProvider)?.id;
    final conversation = ref.read(conversationByIdProvider(widget.conversationId));
    if (userId == null || conversation == null) return;

    final seed = 'chat-${widget.conversationId}-${DateTime.now().millisecondsSinceEpoch}';
    await ref.read(messageRepositoryProvider).sendMessage(
          conversationId: widget.conversationId,
          senderId: userId,
          content: AppStrings.photo,
          type: MessageType.image,
          imageUrl: portraitUrl(seed),
        );
    if (!mounted) return;
    _simulateReply(conversation.otherParticipant(userId));
  }

  Future<void> _sendVoice() async {
    final userId = ref.read(currentUserProvider)?.id;
    final conversation = ref.read(conversationByIdProvider(widget.conversationId));
    if (userId == null || conversation == null) return;

    context.showSnack(AppStrings.voiceRecorded);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    await ref.read(messageRepositoryProvider).sendMessage(
          conversationId: widget.conversationId,
          senderId: userId,
          content: AppStrings.voiceMessageContent,
        );
    if (!mounted) return;
    _simulateReply(conversation.otherParticipant(userId));
  }

  void _toggleSearch() {
    setState(() {
      _searching = !_searching;
      if (!_searching) {
        _searchQuery = '';
        _searchController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final conversation = ref.watch(conversationByIdProvider(widget.conversationId));
    final currentUser = ref.watch(currentUserProvider);

    if (conversation == null || currentUser == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(title: AppStrings.conversation),
        body: Center(
          child: EmptyState(
            icon: Iconsax.message_remove,
            title: AppStrings.conversationNotFound,
            subtitle: AppStrings.conversationNotFoundSubtitle,
          ),
        ),
      );
    }

    final otherId = conversation.otherParticipant(currentUser.id);
    final peer = _resolvePeer(ref, otherId);
    final isTyping = conversation.isTypingFor(otherId);
    final messages = ref.watch(messagesForConversationProvider(widget.conversationId));
    final filtered = _searchQuery.isEmpty
        ? messages
        : messages.where((m) => m.content.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        titleWidget: _searching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: AppTextStyles.input,
                cursorColor: AppColors.gold,
                decoration: InputDecoration(
                  hintText: AppStrings.searchInConversation,
                  hintStyle: AppTextStyles.hint,
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  isDense: true,
                ),
                onChanged: (v) => setState(() => _searchQuery = v),
              )
            : Row(
                children: [
                  KrAvatar(
                    imageUrl: peer.avatarUrl,
                    initials: peer.name.initials,
                    size: KrAvatarSize.sm,
                    online: peer.online,
                    verified: peer.verified,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          peer.name,
                          style: AppTextStyles.cardTitle.copyWith(fontSize: 15),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          isTyping ? AppStrings.typing : (peer.online ? AppStrings.online : AppStrings.offline),
                          style: AppTextStyles.caption.copyWith(
                            color: isTyping ? AppColors.gold : AppColors.textMuted,
                            fontStyle: isTyping ? FontStyle.italic : FontStyle.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
        actions: [
          KrAppBarAction(
            icon: _searching ? Iconsax.close_circle : Iconsax.search_normal,
            onPressed: _toggleSearch,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: messages.isEmpty
                  ? Center(
                      child: EmptyState(
                        icon: Iconsax.message_2,
                        title: AppStrings.sayHelloTitle,
                        subtitle: AppStrings.sayHelloSubtitle(peer.name),
                      ),
                    )
                  : filtered.isEmpty
                      ? Center(
                          child: EmptyState(
                            icon: Iconsax.search_normal_1,
                            title: AppStrings.noMessagesFound,
                            subtitle: AppStrings.noUsersFoundSubtitle,
                            compact: true,
                          ),
                        )
                      : ListView.builder(
                          reverse: true,
                          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.sm),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final i = filtered.length - 1 - index;
                            final message = filtered[i];
                            final isMine = message.senderId == currentUser.id;
                            final showDateSeparator =
                                i == 0 || !filtered[i - 1].createdAt.isSameDayAs(message.createdAt);

                            final bubble = Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (showDateSeparator) _DateSeparator(date: message.createdAt),
                                _MessageBubble(message: message, isMine: isMine, peer: peer),
                              ],
                            );

                            if (index == 0) {
                              return bubble
                                  .animate()
                                  .fadeIn(duration: 220.ms)
                                  .slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic);
                            }
                            return bubble;
                          },
                        ),
            ),
            if (isTyping) _TypingIndicator(peer: peer),
            _ChatInputBar(
              controller: _textController,
              hasText: _hasText,
              onEmoji: _insertEmoji,
              onAttach: _sendImage,
              onVoice: _sendVoice,
              onSend: _sendText,
            ),
          ],
        ),
      ),
    );
  }
}

extension on DateTime {
  bool isSameDayAs(DateTime other) => year == other.year && month == other.month && day == other.day;
}

class _DateSeparator extends StatelessWidget {
  const _DateSeparator({required this.date});

  final DateTime date;

  String get _label {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final that = DateTime(date.year, date.month, date.day);
    final diff = today.difference(that).inDays;
    if (diff == 0) return AppStrings.today;
    if (diff == 1) return AppStrings.yesterday;
    return date.formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(_label, style: AppTextStyles.caption),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.isMine, required this.peer});

  final MessageModel message;
  final bool isMine;
  final _ChatPeer peer;

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isMine ? AppColors.gold.withValues(alpha: 0.16) : AppColors.card;
    final borderColor = isMine ? AppColors.gold.withValues(alpha: 0.4) : AppColors.border;

    final radius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: Radius.circular(isMine ? 16 : 4),
      bottomRight: Radius.circular(isMine ? 4 : 16),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMine) ...[
            KrAvatar(imageUrl: peer.avatarUrl, initials: peer.name.initials, size: KrAvatarSize.xs),
            const SizedBox(width: AppSpacing.sm),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.72),
              padding: message.isImage
                  ? const EdgeInsets.all(6)
                  : const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: radius,
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (message.isImage)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: KrNetworkImage(
                        imageUrl: message.imageUrl,
                        width: 200,
                        height: 220,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    Text(
                      message.content,
                      style: AppTextStyles.body.copyWith(fontSize: 14.5, height: 1.35),
                    ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(message.createdAt.formattedTime, style: AppTextStyles.caption),
                      if (isMine) ...[
                        const SizedBox(width: 4),
                        Icon(
                          message.isRead ? Icons.done_all : Icons.done,
                          size: 13,
                          color: message.isRead ? AppColors.gold : AppColors.textMuted,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator({required this.peer});

  final _ChatPeer peer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.sm),
      child: Row(
        children: [
          KrAvatar(imageUrl: peer.avatarUrl, initials: peer.name.initials, size: KrAvatarSize.xs),
          const SizedBox(width: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.card,
              border: Border.all(color: AppColors.border),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
                  )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .fadeIn(delay: (i * 160).ms, duration: 500.ms)
                      .then()
                      .fade(begin: 1, end: 0.25, duration: 500.ms),
                );
              }),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 200.ms);
  }
}

class _ChatInputBar extends StatelessWidget {
  const _ChatInputBar({
    required this.controller,
    required this.hasText,
    required this.onEmoji,
    required this.onAttach,
    required this.onVoice,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool hasText;
  final VoidCallback onEmoji;
  final VoidCallback onAttach;
  final VoidCallback onVoice;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.sm, AppSpacing.sm, AppSpacing.sm),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _ComposerIcon(icon: Iconsax.gallery_add, onTap: onAttach),
          const SizedBox(width: 4),
          Expanded(
            child: Container(
              constraints: const BoxConstraints(minHeight: 40, maxHeight: 120),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      minLines: 1,
                      maxLines: 5,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.send,
                      style: AppTextStyles.input.copyWith(fontSize: 15, height: 1.25),
                      cursorColor: AppColors.gold,
                      decoration: InputDecoration(
                        hintText: AppStrings.messageHint,
                        hintStyle: AppTextStyles.hint.copyWith(fontSize: 15),
                        filled: false,
                        isDense: true,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                      onSubmitted: (_) => onSend(),
                    ),
                  ),
                  _ComposerIcon(icon: Iconsax.emoji_happy, onTap: onEmoji, compact: true),
                ],
              ),
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: hasText ? onSend : onVoice,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: hasText ? AppColors.gold : AppColors.card,
                shape: BoxShape.circle,
                border: hasText ? null : Border.all(color: AppColors.border),
              ),
              child: Icon(
                hasText ? Iconsax.send_1 : Iconsax.microphone_2,
                size: 18,
                color: hasText ? const Color(0xFF14110A) : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ComposerIcon extends StatelessWidget {
  const _ComposerIcon({required this.icon, required this.onTap, this.compact = false});

  final IconData icon;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: compact ? 36 : 40,
        height: 40,
        child: Icon(icon, size: 22, color: AppColors.textSecondary),
      ),
    );
  }
}
