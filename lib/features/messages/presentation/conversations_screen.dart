import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/mock/mock_data.dart';
import '../../../shared/providers/providers.dart';

/// Inbox list — names use Inter, trailing column is height-safe so timestamps
/// and badges never collide with titles.
class ConversationsScreen extends ConsumerStatefulWidget {
  const ConversationsScreen({super.key});

  @override
  ConsumerState<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends ConsumerState<ConversationsScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final user = auth.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: AppStrings.navMessages, showBackButton: false),
      body: user == null
          ? _GuestPrompt(isGuest: auth.isGuest)
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.sm),
                  child: KrSearchBar(
                    controller: _searchController,
                    hintText: AppStrings.searchConversations,
                    onChanged: (v) => setState(() => _query = v),
                  ),
                ),
                Expanded(child: _ConversationList(userId: user.id, query: _query)),
              ],
            ),
    );
  }
}

String _participantName(WidgetRef ref, String userId) {
  final talent = ref.watch(talentByUserIdProvider(userId));
  if (talent != null) return talent.fullName;
  final recruiter = ref.watch(recruiterByUserIdProvider(userId));
  if (recruiter != null) {
    return recruiter.fullName.isNotEmpty ? recruiter.fullName : recruiter.companyName;
  }
  return MockData.userById(userId)?.fullName ?? '';
}

class _ConversationList extends ConsumerWidget {
  const _ConversationList({required this.userId, this.query = ''});

  final String userId;
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var conversations = ref.watch(conversationsForUserProvider(userId));

    if (query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      conversations = conversations.where((c) {
        final otherId = c.otherParticipant(userId);
        final name = _participantName(ref, otherId).toLowerCase();
        return name.contains(q) || c.lastMessage.toLowerCase().contains(q);
      }).toList();
    }

    if (conversations.isEmpty) {
      return Center(
        child: EmptyState(
          icon: Iconsax.messages_3,
          title: query.trim().isEmpty ? AppStrings.emptyMessagesTitle : AppStrings.noConversationsFound,
          subtitle: query.trim().isEmpty
              ? AppStrings.emptyMessagesSubtitle
              : AppStrings.tryDifferentName,
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      itemCount: conversations.length,
      separatorBuilder: (_, __) =>
          const Divider(height: 1, indent: AppSpacing.lg, endIndent: AppSpacing.lg),
      itemBuilder: (context, index) {
        final conversation = conversations[index];
        final otherId = conversation.otherParticipant(userId);
        final other = MockData.userById(otherId);
        final unread = conversation.unreadCountFor(userId);
        final typing = conversation.isTypingFor(otherId);
        final displayName =
            _participantName(ref, otherId).orPlaceholder(other?.fullName ?? AppStrings.kastRolzUser);

        return InkWell(
          onTap: () => context.push(RouteNames.chatPath(conversation.id)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                KrAvatar(
                  imageUrl: other?.avatarUrl,
                  initials: displayName.initials,
                  online: other?.isOnline ?? false,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        displayName,
                        style: AppTextStyles.cardTitle.copyWith(fontSize: 14, height: 1.2),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        typing
                            ? AppStrings.typing
                            : (conversation.lastMessage.isEmpty
                                ? AppStrings.sayHelloWave
                                : conversation.lastMessage),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: typing ? AppColors.gold : AppColors.textSecondary,
                          fontStyle: typing ? FontStyle.italic : FontStyle.normal,
                          height: 1.25,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      conversation.lastMessageAt.chatTimestamp,
                      style: AppTextStyles.caption.copyWith(height: 1.1),
                    ),
                    if (unread > 0) ...[
                      const SizedBox(height: 6),
                      CountBadge(count: unread),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: (30 * (index % 10)).ms, duration: 300.ms);
      },
    );
  }
}

class _GuestPrompt extends StatelessWidget {
  const _GuestPrompt({required this.isGuest});

  final bool isGuest;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: EmptyState(
        icon: Iconsax.messages_3,
        title: isGuest ? AppStrings.signUpToMessage : AppStrings.emptyMessagesTitle,
        subtitle: isGuest
            ? AppStrings.signUpToMessageBody
            : AppStrings.emptyMessagesSubtitle,
        ctaLabel: isGuest ? AppStrings.register : null,
        onCtaTap: isGuest ? () => context.push(RouteNames.register) : null,
      ),
    );
  }
}
