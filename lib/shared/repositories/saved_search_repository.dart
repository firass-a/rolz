/// Simulates a saved-searches API on top of [SavedSearchNotifier].
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/models.dart';
import '../providers/saved_search_provider.dart';

class SavedSearchRepository {
  SavedSearchRepository(this._ref);

  final Ref _ref;

  static const _uuid = Uuid();
  static const _latency = Duration(milliseconds: 250);

  SavedSearchNotifier get _notifier => _ref.read(savedSearchProvider.notifier);

  SavedSearchModel? getById(String id) => _notifier.getById(id);

  List<SavedSearchModel> forUser(String userId) =>
      _ref.read(savedSearchProvider).where((s) => s.userId == userId).toList();

  Future<SavedSearchModel> create({
    required String userId,
    required String name,
    Map<String, dynamic> filters = const {},
  }) async {
    await Future.delayed(_latency);
    final search = SavedSearchModel(
      id: _uuid.v4(),
      userId: userId,
      name: name,
      filters: filters,
      createdAt: DateTime.now(),
    );
    _notifier.create(search);
    return search;
  }

  Future<void> update(SavedSearchModel search) async {
    await Future.delayed(_latency);
    _notifier.update(search);
  }

  Future<void> delete(String id) async {
    await Future.delayed(_latency);
    _notifier.delete(id);
  }
}

final savedSearchRepositoryProvider = Provider<SavedSearchRepository>((ref) => SavedSearchRepository(ref));
