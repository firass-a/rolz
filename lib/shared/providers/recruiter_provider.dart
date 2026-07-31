/// Riverpod state for [RecruiterModel]s.
library;

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mock/mock_data.dart';
import '../models/models.dart';

class RecruiterNotifier extends Notifier<List<RecruiterModel>> {
  @override
  List<RecruiterModel> build() {
    MockData.init();
    return List<RecruiterModel>.from(MockData.recruiters);
  }

  RecruiterModel? getById(String id) => state.firstWhereOrNull((r) => r.id == id);

  RecruiterModel? getByUserId(String userId) => state.firstWhereOrNull((r) => r.userId == userId);

  void create(RecruiterModel recruiter) {
    state = [recruiter, ...state];
  }

  void update(RecruiterModel recruiter) {
    state = [
      for (final r in state) if (r.id == recruiter.id) recruiter else r,
    ];
  }

  void delete(String id) {
    state = state.where((r) => r.id != id).toList();
  }

  void incrementCastingCount(String id) {
    state = [
      for (final r in state)
        if (r.id == id) r.copyWith(castingCount: r.castingCount + 1) else r,
    ];
  }

  void incrementHireCount(String id) {
    state = [
      for (final r in state)
        if (r.id == id) r.copyWith(hireCount: r.hireCount + 1) else r,
    ];
  }
}

final recruiterProvider = NotifierProvider<RecruiterNotifier, List<RecruiterModel>>(RecruiterNotifier.new);

final recruiterByIdProvider = Provider.family<RecruiterModel?, String>((ref, id) {
  return ref.watch(recruiterProvider).firstWhereOrNull((r) => r.id == id);
});

final recruiterByUserIdProvider = Provider.family<RecruiterModel?, String>((ref, userId) {
  return ref.watch(recruiterProvider).firstWhereOrNull((r) => r.userId == userId);
});
