/// Riverpod state for [CastingModel]s: the raw CRUD notifier, small derived
/// providers, and the [CastingFilters] / [CastingSortBy] value types used by
/// the discover/search screens.
library;

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mock/mock_data.dart';
import '../models/models.dart';

class CastingNotifier extends Notifier<List<CastingModel>> {
  @override
  List<CastingModel> build() {
    MockData.init();
    return List<CastingModel>.from(MockData.castings);
  }

  CastingModel? getById(String id) => state.firstWhereOrNull((c) => c.id == id);

  void create(CastingModel casting) {
    state = [casting, ...state];
  }

  void update(CastingModel casting) {
    state = [
      for (final c in state) if (c.id == casting.id) casting else c,
    ];
  }

  void delete(String id) {
    state = state.where((c) => c.id != id).toList();
  }

  void duplicate(String id) {
    final original = getById(id);
    if (original == null) return;
    final now = DateTime.now();
    final copy = original.copyWith(
      id: 'casting-${now.microsecondsSinceEpoch}',
      title: '${original.title} (Copy)',
      status: CastingStatus.draft,
      isFeatured: false,
      isArchived: false,
      applicantCount: 0,
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
      for (final c in state)
        if (c.id == id)
          c.copyWith(
            isArchived: archived,
            status: archived ? CastingStatus.archived : CastingStatus.open,
            updatedAt: DateTime.now(),
          )
        else
          c,
    ];
  }

  void updateStatus(String id, CastingStatus status) {
    state = [
      for (final c in state)
        if (c.id == id) c.copyWith(status: status, updatedAt: DateTime.now()) else c,
    ];
  }

  void toggleFeatured(String id) {
    state = [
      for (final c in state)
        if (c.id == id) c.copyWith(isFeatured: !c.isFeatured) else c,
    ];
  }

  void toggleUrgent(String id) {
    state = [
      for (final c in state)
        if (c.id == id) c.copyWith(isUrgent: !c.isUrgent) else c,
    ];
  }

  void incrementViewCount(String id) {
    state = [
      for (final c in state)
        if (c.id == id) c.copyWith(viewCount: c.viewCount + 1) else c,
    ];
  }

  void incrementApplicantCount(String id) {
    state = [
      for (final c in state)
        if (c.id == id) c.copyWith(applicantCount: c.applicantCount + 1) else c,
    ];
  }
}

final castingProvider = NotifierProvider<CastingNotifier, List<CastingModel>>(CastingNotifier.new);

/// All non-archived castings, most recently updated first.
final activeCastingsProvider = Provider<List<CastingModel>>((ref) {
  final castings = ref.watch(castingProvider).where((c) => !c.isArchived).toList();
  castings.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  return castings;
});

final featuredCastingsProvider = Provider<List<CastingModel>>((ref) {
  return ref.watch(activeCastingsProvider).where((c) => c.isFeatured).toList();
});

final urgentCastingsProvider = Provider<List<CastingModel>>((ref) {
  return ref.watch(activeCastingsProvider).where((c) => c.isUrgent).toList();
});

final castingByIdProvider = Provider.family<CastingModel?, String>((ref, id) {
  return ref.watch(castingProvider).firstWhereOrNull((c) => c.id == id);
});

final castingsByRecruiterProvider = Provider.family<List<CastingModel>, String>((ref, recruiterId) {
  return ref.watch(castingProvider).where((c) => c.recruiterId == recruiterId).toList();
});

enum CastingSortBy { newest, deadlineSoon, salaryHigh, popular }

const Object _sentinel = Object();

/// Immutable filter/sort selection used by the casting discover & search
/// screens. Construct a new instance (or use [copyWith]) to change filters.
class CastingFilters {
  final String query;
  final TalentCategory? category;
  final CastingType? type;
  final String? city;
  final Gender? gender;
  final CastingStatus? status;
  final bool featured;
  final bool urgent;
  final CastingSortBy sort;

  const CastingFilters({
    this.query = '',
    this.category,
    this.type,
    this.city,
    this.gender,
    this.status,
    this.featured = false,
    this.urgent = false,
    this.sort = CastingSortBy.newest,
  });

  bool get hasActiveFilters =>
      query.isNotEmpty ||
      category != null ||
      type != null ||
      (city != null && city!.isNotEmpty) ||
      gender != null ||
      status != null ||
      featured ||
      urgent;

  CastingFilters copyWith({
    String? query,
    Object? category = _sentinel,
    Object? type = _sentinel,
    Object? city = _sentinel,
    Object? gender = _sentinel,
    Object? status = _sentinel,
    bool? featured,
    bool? urgent,
    CastingSortBy? sort,
  }) {
    return CastingFilters(
      query: query ?? this.query,
      category: identical(category, _sentinel) ? this.category : category as TalentCategory?,
      type: identical(type, _sentinel) ? this.type : type as CastingType?,
      city: identical(city, _sentinel) ? this.city : city as String?,
      gender: identical(gender, _sentinel) ? this.gender : gender as Gender?,
      status: identical(status, _sentinel) ? this.status : status as CastingStatus?,
      featured: featured ?? this.featured,
      urgent: urgent ?? this.urgent,
      sort: sort ?? this.sort,
    );
  }
}
