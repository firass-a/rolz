/// Riverpod state for [ReportModel]s.
library;

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mock/mock_data.dart';
import '../models/models.dart';

class ReportNotifier extends Notifier<List<ReportModel>> {
  @override
  List<ReportModel> build() {
    MockData.init();
    return List<ReportModel>.from(MockData.reports);
  }

  ReportModel? getById(String id) => state.firstWhereOrNull((r) => r.id == id);

  void create(ReportModel report) {
    state = [report, ...state];
  }

  void update(ReportModel report) {
    state = [
      for (final r in state) if (r.id == report.id) report else r,
    ];
  }

  void delete(String id) {
    state = state.where((r) => r.id != id).toList();
  }

  void updateStatus(String id, ReportStatus status) {
    state = [
      for (final r in state) if (r.id == id) r.copyWith(status: status) else r,
    ];
  }
}

final reportProvider = NotifierProvider<ReportNotifier, List<ReportModel>>(ReportNotifier.new);

final reportsByStatusProvider = Provider.family<List<ReportModel>, ReportStatus>((ref, status) {
  final list = ref.watch(reportProvider).where((r) => r.status == status).toList();
  list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return list;
});

final pendingReportsCountProvider = Provider<int>((ref) {
  return ref.watch(reportsByStatusProvider(ReportStatus.pending)).length;
});
