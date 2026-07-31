/// Riverpod state for [AgencyModel]s.
library;

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mock/mock_data.dart';
import '../models/models.dart';

class AgencyNotifier extends Notifier<List<AgencyModel>> {
  @override
  List<AgencyModel> build() {
    MockData.init();
    return List<AgencyModel>.from(MockData.agencies);
  }

  AgencyModel? getById(String id) => state.firstWhereOrNull((a) => a.id == id);

  void create(AgencyModel agency) {
    state = [agency, ...state];
  }

  void update(AgencyModel agency) {
    state = [
      for (final a in state) if (a.id == agency.id) agency else a,
    ];
  }

  void delete(String id) {
    state = state.where((a) => a.id != id).toList();
  }
}

final agencyProvider = NotifierProvider<AgencyNotifier, List<AgencyModel>>(AgencyNotifier.new);

final agencyByIdProvider = Provider.family<AgencyModel?, String>((ref, id) {
  return ref.watch(agencyProvider).firstWhereOrNull((a) => a.id == id);
});
