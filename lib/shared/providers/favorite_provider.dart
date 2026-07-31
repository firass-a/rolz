/// Riverpod state for [FavoriteModel]s.
library;

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mock/mock_data.dart';
import '../models/models.dart';

class FavoriteNotifier extends Notifier<List<FavoriteModel>> {
  @override
  List<FavoriteModel> build() {
    MockData.init();
    return List<FavoriteModel>.from(MockData.favorites);
  }

  FavoriteModel? find(String userId, String itemId, FavoriteItemType itemType) {
    return state.firstWhereOrNull(
      (f) => f.userId == userId && f.itemId == itemId && f.itemType == itemType,
    );
  }

  void add(FavoriteModel favorite) {
    state = [favorite, ...state];
  }

  void remove(String id) {
    state = state.where((f) => f.id != id).toList();
  }
}

final favoriteProvider = NotifierProvider<FavoriteNotifier, List<FavoriteModel>>(FavoriteNotifier.new);

final favoritesForUserProvider = Provider.family<List<FavoriteModel>, String>((ref, userId) {
  return ref.watch(favoriteProvider).where((f) => f.userId == userId).toList();
});

final favoritesForUserByTypeProvider =
    Provider.family<List<FavoriteModel>, ({String userId, FavoriteItemType type})>((ref, args) {
  return ref
      .watch(favoritesForUserProvider(args.userId))
      .where((f) => f.itemType == args.type)
      .toList();
});

final isFavoriteProvider =
    Provider.family<bool, ({String userId, String itemId, FavoriteItemType type})>((ref, args) {
  return ref.watch(favoriteProvider).any(
        (f) => f.userId == args.userId && f.itemId == args.itemId && f.itemType == args.type,
      );
});
