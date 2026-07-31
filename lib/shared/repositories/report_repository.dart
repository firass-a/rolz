/// Simulates a reports API on top of [ReportNotifier], used by the admin
/// moderation surfaces.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/models.dart';
import '../providers/report_provider.dart';

class ReportRepository {
  ReportRepository(this._ref);

  final Ref _ref;

  static const _uuid = Uuid();
  static const _latency = Duration(milliseconds: 300);

  ReportNotifier get _notifier => _ref.read(reportProvider.notifier);

  ReportModel? getById(String id) => _notifier.getById(id);

  List<ReportModel> all() => _ref.read(reportProvider);

  List<ReportModel> byStatus(ReportStatus status) =>
      _ref.read(reportProvider).where((r) => r.status == status).toList();

  Future<ReportModel> create({
    required String reporterId,
    required String targetId,
    required ReportTargetType targetType,
    required String reason,
  }) async {
    await Future.delayed(_latency);
    final report = ReportModel(
      id: _uuid.v4(),
      reporterId: reporterId,
      targetId: targetId,
      targetType: targetType,
      reason: reason,
      createdAt: DateTime.now(),
    );
    _notifier.create(report);
    return report;
  }

  Future<void> update(ReportModel report) async {
    await Future.delayed(_latency);
    _notifier.update(report);
  }

  Future<void> delete(String id) async {
    await Future.delayed(_latency);
    _notifier.delete(id);
  }

  Future<void> updateStatus(String id, ReportStatus status) async {
    await Future.delayed(_latency);
    _notifier.updateStatus(id, status);
  }
}

final reportRepositoryProvider = Provider<ReportRepository>((ref) => ReportRepository(ref));
