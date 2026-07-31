/// Simulates a favorites/bookmarks API on top of [FavoriteNotifier].
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/models.dart';
import '../providers/favorite_provider.dart';

class FavoriteRepository {
  FavoriteRepository(this._ref);

  final Ref _ref;

  static const _uuid = Uuid();

  FavoriteNotifier get _notifier => _ref.read(favoriteProvider.notifier);

  bool isFavorite(String userId, String itemId, FavoriteItemType type) {
    return _notifier.find(userId, itemId, type) != null;
  }

  List<FavoriteModel> forUser(String userId) =>
      _ref.read(favoriteProvider).where((f) => f.userId == userId).toList();

  List<FavoriteModel> forUserByType(String userId, FavoriteItemType type) =>
      forUser(userId).where((f) => f.itemType == type).toList();

  /// Adds the favorite if it doesn't exist yet, otherwise removes it.
  /// Returns the new favorited state (`true` = now favorited).
  bool toggleFavorite(String userId, String itemId, FavoriteItemType itemType) {
    final existing = _notifier.find(userId, itemId, itemType);
    if (existing != null) {
      _notifier.remove(existing.id);
      return false;
    }
    _notifier.add(FavoriteModel(
      id: _uuid.v4(),
      userId: userId,
      itemId: itemId,
      itemType: itemType,
      createdAt: DateTime.now(),
    ));
    return true;
  }
}

final favoriteRepositoryProvider = Provider<FavoriteRepository>((ref) => FavoriteRepository(ref));
