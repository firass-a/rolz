/// Riverpod state for [ApplicationModel]s.
library;

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mock/mock_data.dart';
import '../models/models.dart';

class ApplicationNotifier extends Notifier<List<ApplicationModel>> {
  @override
  List<ApplicationModel> build() {
    MockData.init();
    return List<ApplicationModel>.from(MockData.applications);
  }

  ApplicationModel? getById(String id) => state.firstWhereOrNull((a) => a.id == id);

  void create(ApplicationModel application) {
    state = [application, ...state];
  }

  void update(ApplicationModel application) {
    state = [
      for (final a in state) if (a.id == application.id) application else a,
    ];
  }

  void delete(String id) {
    state = state.where((a) => a.id != id).toList();
  }

  void updateStatus(String id, ApplicationStatus status) {
    state = [
      for (final a in state)
        if (a.id == id) a.copyWith(status: status, updatedAt: DateTime.now()) else a,
    ];
  }
}

final applicationProvider =
    NotifierProvider<ApplicationNotifier, List<ApplicationModel>>(ApplicationNotifier.new);

final applicationsByTalentProvider = Provider.family<List<ApplicationModel>, String>((ref, talentId) {
  final list = ref.watch(applicationProvider).where((a) => a.talentId == talentId).toList();
  list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return list;
});

final applicationsByCastingProvider = Provider.family<List<ApplicationModel>, String>((ref, castingId) {
  final list = ref.watch(applicationProvider).where((a) => a.castingId == castingId).toList();
  list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return list;
});

final applicationsByRecruiterProvider = Provider.family<List<ApplicationModel>, String>((ref, recruiterId) {
  final list = ref.watch(applicationProvider).where((a) => a.recruiterId == recruiterId).toList();
  list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return list;
});

/// Whether [talentId] has already applied to [castingId].
final hasAppliedProvider = Provider.family<bool, ({String castingId, String talentId})>((ref, args) {
  return ref
      .watch(applicationProvider)
      .any((a) => a.castingId == args.castingId && a.talentId == args.talentId);
});
