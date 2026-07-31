/// Global "search everything" bar — searches talents, castings, recruiters,
/// agencies and conversations at once from a single query string.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import 'agency_provider.dart';
import 'auth_provider.dart';
import 'casting_provider.dart';
import 'message_provider.dart';
import 'recruiter_provider.dart';
import 'talent_provider.dart';

class GlobalSearchState {
  final String query;
  final bool isSearching;
  final List<TalentModel> talents;
  final List<CastingModel> castings;
  final List<RecruiterModel> recruiters;
  final List<AgencyModel> agencies;
  final List<ConversationModel> conversations;

  const GlobalSearchState({
    this.query = '',
    this.isSearching = false,
    this.talents = const [],
    this.castings = const [],
    this.recruiters = const [],
    this.agencies = const [],
    this.conversations = const [],
  });

  bool get hasResults =>
      talents.isNotEmpty ||
      castings.isNotEmpty ||
      recruiters.isNotEmpty ||
      agencies.isNotEmpty ||
      conversations.isNotEmpty;

  int get totalCount =>
      talents.length + castings.length + recruiters.length + agencies.length + conversations.length;

  GlobalSearchState copyWith({
    String? query,
    bool? isSearching,
    List<TalentModel>? talents,
    List<CastingModel>? castings,
    List<RecruiterModel>? recruiters,
    List<AgencyModel>? agencies,
    List<ConversationModel>? conversations,
  }) {
    return GlobalSearchState(
      query: query ?? this.query,
      isSearching: isSearching ?? this.isSearching,
      talents: talents ?? this.talents,
      castings: castings ?? this.castings,
      recruiters: recruiters ?? this.recruiters,
      agencies: agencies ?? this.agencies,
      conversations: conversations ?? this.conversations,
    );
  }
}

class GlobalSearchNotifier extends Notifier<GlobalSearchState> {
  @override
  GlobalSearchState build() => const GlobalSearchState();

  void search(String query) {
    final q = query.trim();
    if (q.isEmpty) {
      state = const GlobalSearchState();
      return;
    }
    state = state.copyWith(query: q, isSearching: true);
    final lower = q.toLowerCase();

    final talents = ref
        .read(talentProvider)
        .where((t) => !t.isArchived && (t.fullName.toLowerCase().contains(lower) || t.city.toLowerCase().contains(lower)))
        .take(20)
        .toList();

    final castings = ref
        .read(castingProvider)
        .where((c) => !c.isArchived && (c.title.toLowerCase().contains(lower) || c.city.toLowerCase().contains(lower)))
        .take(20)
        .toList();

    final recruiters = ref
        .read(recruiterProvider)
        .where((r) => r.companyName.toLowerCase().contains(lower) || r.fullName.toLowerCase().contains(lower))
        .take(20)
        .toList();

    final agencies = ref.read(agencyProvider).where((a) => a.name.toLowerCase().contains(lower)).take(20).toList();

    final currentUserId = ref.read(currentUserProvider)?.id;
    final conversations = currentUserId == null
        ? <ConversationModel>[]
        : ref
            .read(conversationProvider)
            .where((c) => c.participantIds.contains(currentUserId) && c.lastMessage.toLowerCase().contains(lower))
            .take(20)
            .toList();

    state = state.copyWith(
      query: q,
      isSearching: false,
      talents: talents,
      castings: castings,
      recruiters: recruiters,
      agencies: agencies,
      conversations: conversations,
    );
  }

  void clear() {
    state = const GlobalSearchState();
  }
}

final globalSearchProvider = NotifierProvider<GlobalSearchNotifier, GlobalSearchState>(GlobalSearchNotifier.new);
