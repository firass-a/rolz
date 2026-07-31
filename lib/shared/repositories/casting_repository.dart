/// Simulates a castings API. Every mutating call delegates to
/// [CastingNotifier] so the Riverpod state stays the single source of
/// truth; this class only adds the "network" feel (a short delay) plus
/// read-side helpers such as filtering/sorting.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import '../providers/casting_provider.dart';

/// Applies [filters] to [castings] and returns a new sorted list. Shared by
/// [CastingRepository.search] and the reactive `filteredCastingsProvider` in
/// `discover_filters_provider.dart`.
List<CastingModel> applyCastingFilters(List<CastingModel> castings, CastingFilters filters) {
  var results = castings.where((c) => !c.isArchived).toList();

  if (filters.query.trim().isNotEmpty) {
    final q = filters.query.trim().toLowerCase();
    results = results.where((c) {
      return c.title.toLowerCase().contains(q) ||
          c.description.toLowerCase().contains(q) ||
          c.role.toLowerCase().contains(q) ||
          c.city.toLowerCase().contains(q) ||
          c.skills.any((s) => s.toLowerCase().contains(q));
    }).toList();
  }
  if (filters.category != null) {
    results = results.where((c) => c.category == filters.category).toList();
  }
  if (filters.type != null) {
    results = results.where((c) => c.type == filters.type).toList();
  }
  if (filters.city != null && filters.city!.isNotEmpty) {
    results = results.where((c) => c.city == filters.city).toList();
  }
  if (filters.gender != null) {
    results = results.where((c) => c.gender == null || c.gender == filters.gender).toList();
  }
  if (filters.status != null) {
    results = results.where((c) => c.status == filters.status).toList();
  }
  if (filters.featured) {
    results = results.where((c) => c.isFeatured).toList();
  }
  if (filters.urgent) {
    results = results.where((c) => c.isUrgent).toList();
  }

  switch (filters.sort) {
    case CastingSortBy.newest:
      results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      break;
    case CastingSortBy.deadlineSoon:
      results.sort((a, b) => a.applicationDeadline.compareTo(b.applicationDeadline));
      break;
    case CastingSortBy.salaryHigh:
      results.sort((a, b) => b.salary.compareTo(a.salary));
      break;
    case CastingSortBy.popular:
      results.sort((a, b) => b.applicantCount.compareTo(a.applicantCount));
      break;
  }
  return results;
}

class CastingRepository {
  CastingRepository(this._ref);

  final Ref _ref;

  static const _latency = Duration(milliseconds: 300);

  CastingNotifier get _notifier => _ref.read(castingProvider.notifier);

  List<CastingModel> get _all => _ref.read(castingProvider);

  CastingModel? getById(String id) => _notifier.getById(id);

  List<CastingModel> getByRecruiter(String recruiterId) =>
      _all.where((c) => c.recruiterId == recruiterId).toList();

  List<CastingModel> search(CastingFilters filters) => applyCastingFilters(_all, filters);

  Future<CastingModel> create(CastingModel casting) async {
    await Future.delayed(_latency);
    _notifier.create(casting);
    return casting;
  }

  Future<CastingModel> update(CastingModel casting) async {
    await Future.delayed(_latency);
    _notifier.update(casting.copyWith(updatedAt: DateTime.now()));
    return casting;
  }

  Future<void> delete(String id) async {
    await Future.delayed(_latency);
    _notifier.delete(id);
  }

  Future<void> duplicate(String id) async {
    await Future.delayed(_latency);
    _notifier.duplicate(id);
  }

  Future<void> archive(String id) async {
    await Future.delayed(_latency);
    _notifier.archive(id);
  }

  Future<void> restore(String id) async {
    await Future.delayed(_latency);
    _notifier.restore(id);
  }

  Future<void> updateStatus(String id, CastingStatus status) async {
    await Future.delayed(_latency);
    _notifier.updateStatus(id, status);
  }

  void toggleFeatured(String id) => _notifier.toggleFeatured(id);

  void toggleUrgent(String id) => _notifier.toggleUrgent(id);

  void incrementViewCount(String id) => _notifier.incrementViewCount(id);
}

final castingRepositoryProvider = Provider<CastingRepository>((ref) => CastingRepository(ref));
