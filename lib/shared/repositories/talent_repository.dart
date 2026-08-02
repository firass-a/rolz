/// Simulates a talents API. Every mutating call delegates to
/// [TalentNotifier] so the Riverpod state stays the single source of truth;
/// this class only adds the "network" feel (a short delay) plus read-side
/// helpers such as filtering/sorting that don't belong on the notifier.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import '../providers/talent_provider.dart';

/// Applies [filters] to [talents] and returns a new sorted list. Shared by
/// [TalentRepository.search] and the reactive `filteredTalentsProvider` in
/// `discover_filters_provider.dart` so filtering logic only lives in one
/// place.
List<TalentModel> applyTalentFilters(List<TalentModel> talents, TalentFilters filters) {
  var results = talents.where((t) => !t.isArchived).toList();

  if (filters.query.trim().isNotEmpty) {
    final q = filters.query.trim().toLowerCase();
    results = results.where((t) {
      return t.fullName.toLowerCase().contains(q) ||
          t.city.toLowerCase().contains(q) ||
          t.country.toLowerCase().contains(q) ||
          t.category.label.toLowerCase().contains(q) ||
          t.skills.any((s) => s.toLowerCase().contains(q));
    }).toList();
  }
  if (filters.category != null) {
    results = results.where((t) => t.category == filters.category).toList();
  }
  if (filters.gender != null) {
    results = results.where((t) => t.gender == filters.gender).toList();
  }
  if (filters.ageMin != null) {
    results = results.where((t) => t.age >= filters.ageMin!).toList();
  }
  if (filters.ageMax != null) {
    results = results.where((t) => t.age <= filters.ageMax!).toList();
  }
  if (filters.heightMin != null) {
    results = results.where((t) => t.heightCm >= filters.heightMin!).toList();
  }
  if (filters.heightMax != null) {
    results = results.where((t) => t.heightCm <= filters.heightMax!).toList();
  }
  if (filters.weightMin != null) {
    results = results.where((t) => t.weightKg >= filters.weightMin!).toList();
  }
  if (filters.weightMax != null) {
    results = results.where((t) => t.weightKg <= filters.weightMax!).toList();
  }
  if (filters.languages.isNotEmpty) {
    results = results.where((t) {
      final talentLangs = t.languages.map((l) => l.toLowerCase()).toSet();
      return filters.languages.every((l) => talentLangs.contains(l.toLowerCase()));
    }).toList();
  }
  if (filters.nationality != null && filters.nationality!.isNotEmpty) {
    final nationality = filters.nationality!.toLowerCase();
    results = results.where((t) => t.nationality.toLowerCase().contains(nationality)).toList();
  }
  if (filters.city != null && filters.city!.isNotEmpty) {
    final city = filters.city!.toLowerCase();
    results = results.where((t) => t.city.toLowerCase().contains(city)).toList();
  }
  if (filters.country != null && filters.country!.isNotEmpty) {
    results = results.where((t) => t.country == filters.country).toList();
  }
  if (filters.experienceLevel != null) {
    results = results.where((t) => t.experienceLevel == filters.experienceLevel).toList();
  }
  if (filters.experienceMinYears != null) {
    results = results.where((t) => t.yearsOfExperience >= filters.experienceMinYears!).toList();
  }
  if (filters.skills.isNotEmpty) {
    results = results.where((t) {
      final talentSkills = t.skills.map((s) => s.toLowerCase()).toSet();
      return filters.skills.every((s) => talentSkills.contains(s.toLowerCase()));
    }).toList();
  }
  if (filters.availability != null) {
    results = results.where((t) => t.availability == filters.availability).toList();
  }
  if (filters.verifiedOnly) {
    results = results.where((t) => t.isVerified).toList();
  }

  switch (filters.sortBy) {
    case TalentSortBy.rating:
      results.sort((a, b) => b.rating.compareTo(a.rating));
      break;
    case TalentSortBy.newest:
      results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      break;
    case TalentSortBy.views:
      results.sort((a, b) => b.viewCount.compareTo(a.viewCount));
      break;
    case TalentSortBy.name:
      results.sort((a, b) => a.fullName.compareTo(b.fullName));
      break;
  }
  return results;
}

class TalentRepository {
  TalentRepository(this._ref);

  final Ref _ref;

  static const _latency = Duration(milliseconds: 300);

  TalentNotifier get _notifier => _ref.read(talentProvider.notifier);

  List<TalentModel> get _all => _ref.read(talentProvider);

  TalentModel? getById(String id) => _notifier.getById(id);

  List<TalentModel> get featured => _all.where((t) => t.isFeatured && !t.isArchived).toList();

  List<TalentModel> search(TalentFilters filters) => applyTalentFilters(_all, filters);

  Future<TalentModel> create(TalentModel talent) async {
    await Future.delayed(_latency);
    _notifier.create(talent);
    return talent;
  }

  Future<TalentModel> update(TalentModel talent) async {
    await Future.delayed(_latency);
    _notifier.update(talent.copyWith(updatedAt: DateTime.now()));
    return talent;
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

  void toggleFeatured(String id) => _notifier.toggleFeatured(id);

  void incrementViewCount(String id) => _notifier.incrementViewCount(id);
}

final talentRepositoryProvider = Provider<TalentRepository>((ref) => TalentRepository(ref));
