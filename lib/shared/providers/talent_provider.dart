/// Riverpod state for [TalentModel]s: the raw CRUD notifier, small derived
/// providers, and the [TalentFilters] / [TalentSortBy] value types used by
/// the discover/search screens.
library;

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mock/mock_data.dart';
import '../models/models.dart';

class TalentNotifier extends Notifier<List<TalentModel>> {
  @override
  List<TalentModel> build() {
    MockData.init();
    return List<TalentModel>.from(MockData.talents);
  }

  TalentModel? getById(String id) => state.firstWhereOrNull((t) => t.id == id);

  void create(TalentModel talent) {
    state = [talent, ...state];
  }

  void update(TalentModel talent) {
    state = [
      for (final t in state) if (t.id == talent.id) talent else t,
    ];
  }

  void delete(String id) {
    state = state.where((t) => t.id != id).toList();
  }

  void duplicate(String id) {
    final original = getById(id);
    if (original == null) return;
    final now = DateTime.now();
    final copy = original.copyWith(
      id: 'talent-${now.microsecondsSinceEpoch}',
      firstName: '${original.firstName} (Copy)',
      isFeatured: false,
      isVerified: false,
      viewCount: 0,
      createdAt: now,
      updatedAt: now,
    );
    state = [copy, ...state];
  }

  void archive(String id) => _setArchived(id, true);

  void restore(String id) => _setArchived(id, false);

  void _setArchived(String id, bool archived) {
    state = [
      for (final t in state)
        if (t.id == id) t.copyWith(isArchived: archived, updatedAt: DateTime.now()) else t,
    ];
  }

  void toggleFeatured(String id) {
    state = [
      for (final t in state)
        if (t.id == id) t.copyWith(isFeatured: !t.isFeatured) else t,
    ];
  }

  void incrementViewCount(String id) {
    state = [
      for (final t in state)
        if (t.id == id) t.copyWith(viewCount: t.viewCount + 1) else t,
    ];
  }

  void updateRatingSummary(String id, {required double rating, required int reviewCount}) {
    state = [
      for (final t in state)
        if (t.id == id) t.copyWith(rating: rating, reviewCount: reviewCount) else t,
    ];
  }
}

final talentProvider = NotifierProvider<TalentNotifier, List<TalentModel>>(TalentNotifier.new);

/// All non-archived talents, most recently updated first.
final activeTalentsProvider = Provider<List<TalentModel>>((ref) {
  final talents = ref.watch(talentProvider).where((t) => !t.isArchived).toList();
  talents.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  return talents;
});

final featuredTalentsProvider = Provider<List<TalentModel>>((ref) {
  return ref.watch(activeTalentsProvider).where((t) => t.isFeatured).toList();
});

final talentByIdProvider = Provider.family<TalentModel?, String>((ref, id) {
  return ref.watch(talentProvider).firstWhereOrNull((t) => t.id == id);
});

final talentByUserIdProvider = Provider.family<TalentModel?, String>((ref, userId) {
  return ref.watch(talentProvider).firstWhereOrNull((t) => t.userId == userId);
});

final talentsByAgencyProvider = Provider.family<List<TalentModel>, String>((ref, agencyId) {
  return ref.watch(talentProvider).where((t) => t.agencyId == agencyId).toList();
});

enum TalentSortBy { rating, newest, views, name }

/// Sentinel used by [TalentFilters.copyWith] so nullable filter fields can be
/// explicitly cleared (passing `null` alone can't be distinguished from "no
/// change" for a `Type?` parameter).
const Object _sentinel = Object();

/// Immutable filter/sort selection used by the talent discover & search
/// screens. Construct a new instance (or use [copyWith]) to change filters.
class TalentFilters {
  final String query;
  final TalentCategory? category;
  final Gender? gender;
  final int? ageMin;
  final int? ageMax;
  final double? heightMin;
  final double? heightMax;
  final double? weightMin;
  final double? weightMax;
  final List<String> languages;
  final String? nationality;
  final String? city;
  final String? country;
  final ExperienceLevel? experienceLevel;
  final List<String> skills;
  final AvailabilityStatus? availability;
  final bool verifiedOnly;
  final TalentSortBy sortBy;

  const TalentFilters({
    this.query = '',
    this.category,
    this.gender,
    this.ageMin,
    this.ageMax,
    this.heightMin,
    this.heightMax,
    this.weightMin,
    this.weightMax,
    this.languages = const [],
    this.nationality,
    this.city,
    this.country,
    this.experienceLevel,
    this.skills = const [],
    this.availability,
    this.verifiedOnly = false,
    this.sortBy = TalentSortBy.newest,
  });

  bool get hasActiveFilters =>
      query.isNotEmpty ||
      category != null ||
      gender != null ||
      ageMin != null ||
      ageMax != null ||
      heightMin != null ||
      heightMax != null ||
      weightMin != null ||
      weightMax != null ||
      languages.isNotEmpty ||
      (nationality != null && nationality!.isNotEmpty) ||
      (city != null && city!.isNotEmpty) ||
      (country != null && country!.isNotEmpty) ||
      experienceLevel != null ||
      skills.isNotEmpty ||
      availability != null ||
      verifiedOnly;

  TalentFilters copyWith({
    String? query,
    Object? category = _sentinel,
    Object? gender = _sentinel,
    Object? ageMin = _sentinel,
    Object? ageMax = _sentinel,
    Object? heightMin = _sentinel,
    Object? heightMax = _sentinel,
    Object? weightMin = _sentinel,
    Object? weightMax = _sentinel,
    List<String>? languages,
    Object? nationality = _sentinel,
    Object? city = _sentinel,
    Object? country = _sentinel,
    Object? experienceLevel = _sentinel,
    List<String>? skills,
    Object? availability = _sentinel,
    bool? verifiedOnly,
    TalentSortBy? sortBy,
  }) {
    return TalentFilters(
      query: query ?? this.query,
      category: identical(category, _sentinel) ? this.category : category as TalentCategory?,
      gender: identical(gender, _sentinel) ? this.gender : gender as Gender?,
      ageMin: identical(ageMin, _sentinel) ? this.ageMin : ageMin as int?,
      ageMax: identical(ageMax, _sentinel) ? this.ageMax : ageMax as int?,
      heightMin: identical(heightMin, _sentinel) ? this.heightMin : heightMin as double?,
      heightMax: identical(heightMax, _sentinel) ? this.heightMax : heightMax as double?,
      weightMin: identical(weightMin, _sentinel) ? this.weightMin : weightMin as double?,
      weightMax: identical(weightMax, _sentinel) ? this.weightMax : weightMax as double?,
      languages: languages ?? this.languages,
      nationality: identical(nationality, _sentinel) ? this.nationality : nationality as String?,
      city: identical(city, _sentinel) ? this.city : city as String?,
      country: identical(country, _sentinel) ? this.country : country as String?,
      experienceLevel:
          identical(experienceLevel, _sentinel) ? this.experienceLevel : experienceLevel as ExperienceLevel?,
      skills: skills ?? this.skills,
      availability: identical(availability, _sentinel) ? this.availability : availability as AvailabilityStatus?,
      verifiedOnly: verifiedOnly ?? this.verifiedOnly,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}
