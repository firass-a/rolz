/// Holds the currently selected [TalentFilters] / [CastingFilters] for the
/// discover screens, plus reactive providers that apply them to the live
/// talent/casting lists.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import '../repositories/casting_repository.dart';
import '../repositories/talent_repository.dart';
import 'casting_provider.dart';
import 'talent_provider.dart';

class DiscoverFiltersState {
  final TalentFilters talentFilters;
  final CastingFilters castingFilters;

  const DiscoverFiltersState({
    this.talentFilters = const TalentFilters(),
    this.castingFilters = const CastingFilters(),
  });

  DiscoverFiltersState copyWith({
    TalentFilters? talentFilters,
    CastingFilters? castingFilters,
  }) {
    return DiscoverFiltersState(
      talentFilters: talentFilters ?? this.talentFilters,
      castingFilters: castingFilters ?? this.castingFilters,
    );
  }
}

class DiscoverFiltersNotifier extends Notifier<DiscoverFiltersState> {
  @override
  DiscoverFiltersState build() => const DiscoverFiltersState();

  void setTalentFilters(TalentFilters filters) {
    state = state.copyWith(talentFilters: filters);
  }

  void setCastingFilters(CastingFilters filters) {
    state = state.copyWith(castingFilters: filters);
  }

  void setTalentQuery(String query) {
    state = state.copyWith(talentFilters: state.talentFilters.copyWith(query: query));
  }

  void setCastingQuery(String query) {
    state = state.copyWith(castingFilters: state.castingFilters.copyWith(query: query));
  }

  void resetTalentFilters() {
    state = state.copyWith(talentFilters: const TalentFilters());
  }

  void resetCastingFilters() {
    state = state.copyWith(castingFilters: const CastingFilters());
  }
}

final discoverFiltersProvider =
    NotifierProvider<DiscoverFiltersNotifier, DiscoverFiltersState>(DiscoverFiltersNotifier.new);

/// Reactively re-filters/re-sorts the live talent list whenever either the
/// talent data or the selected filters change.
final filteredTalentsProvider = Provider<List<TalentModel>>((ref) {
  final talents = ref.watch(talentProvider);
  final filters = ref.watch(discoverFiltersProvider).talentFilters;
  return applyTalentFilters(talents, filters);
});

/// Reactively re-filters/re-sorts the live casting list whenever either the
/// casting data or the selected filters change.
final filteredCastingsProvider = Provider<List<CastingModel>>((ref) {
  final castings = ref.watch(castingProvider);
  final filters = ref.watch(discoverFiltersProvider).castingFilters;
  return applyCastingFilters(castings, filters);
});
