/// Simulates an agencies API on top of [AgencyNotifier].
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import '../providers/agency_provider.dart';

class AgencyRepository {
  AgencyRepository(this._ref);

  final Ref _ref;

  static const _latency = Duration(milliseconds: 300);

  AgencyNotifier get _notifier => _ref.read(agencyProvider.notifier);

  AgencyModel? getById(String id) => _notifier.getById(id);

  List<AgencyModel> search(String query) {
    final all = _ref.read(agencyProvider);
    if (query.trim().isEmpty) return all;
    final q = query.trim().toLowerCase();
    return all.where((a) {
      return a.name.toLowerCase().contains(q) ||
          a.city.toLowerCase().contains(q) ||
          a.specialties.any((s) => s.toLowerCase().contains(q));
    }).toList();
  }

  Future<AgencyModel> create(AgencyModel agency) async {
    await Future.delayed(_latency);
    _notifier.create(agency);
    return agency;
  }

  Future<AgencyModel> update(AgencyModel agency) async {
    await Future.delayed(_latency);
    _notifier.update(agency);
    return agency;
  }

  Future<void> delete(String id) async {
    await Future.delayed(_latency);
    _notifier.delete(id);
  }
}

final agencyRepositoryProvider = Provider<AgencyRepository>((ref) => AgencyRepository(ref));
