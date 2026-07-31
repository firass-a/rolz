/// Riverpod state for [SavedSearchModel]s.
library;

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mock/mock_data.dart';
import '../models/models.dart';

class SavedSearchNotifier extends Notifier<List<SavedSearchModel>> {
  @override
  List<SavedSearchModel> build() {
    MockData.init();
    return List<SavedSearchModel>.from(MockData.savedSearches);
  }

  SavedSearchModel? getById(String id) => state.firstWhereOrNull((s) => s.id == id);

  void create(SavedSearchModel search) {
    state = [search, ...state];
  }

  void update(SavedSearchModel search) {
    state = [
      for (final s in state) if (s.id == search.id) search else s,
    ];
  }

  void delete(String id) {
    state = state.where((s) => s.id != id).toList();
  }
}

final savedSearchProvider =
    NotifierProvider<SavedSearchNotifier, List<SavedSearchModel>>(SavedSearchNotifier.new);

final savedSearchesForUserProvider = Provider.family<List<SavedSearchModel>, String>((ref, userId) {
  final list = ref.watch(savedSearchProvider).where((s) => s.userId == userId).toList();
  list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return list;
});
