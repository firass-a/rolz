/// Simulates a recruiters API on top of [RecruiterNotifier].
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import '../providers/recruiter_provider.dart';

class RecruiterRepository {
  RecruiterRepository(this._ref);

  final Ref _ref;

  static const _latency = Duration(milliseconds: 300);

  RecruiterNotifier get _notifier => _ref.read(recruiterProvider.notifier);

  RecruiterModel? getById(String id) => _notifier.getById(id);

  RecruiterModel? getByUserId(String userId) => _notifier.getByUserId(userId);

  List<RecruiterModel> search(String query) {
    final all = _ref.read(recruiterProvider);
    if (query.trim().isEmpty) return all;
    final q = query.trim().toLowerCase();
    return all.where((r) {
      return r.companyName.toLowerCase().contains(q) ||
          r.fullName.toLowerCase().contains(q) ||
          r.city.toLowerCase().contains(q);
    }).toList();
  }

  Future<RecruiterModel> create(RecruiterModel recruiter) async {
    await Future.delayed(_latency);
    _notifier.create(recruiter);
    return recruiter;
  }

  Future<RecruiterModel> update(RecruiterModel recruiter) async {
    await Future.delayed(_latency);
    _notifier.update(recruiter);
    return recruiter;
  }

  Future<void> delete(String id) async {
    await Future.delayed(_latency);
    _notifier.delete(id);
  }
}

final recruiterRepositoryProvider = Provider<RecruiterRepository>((ref) => RecruiterRepository(ref));
