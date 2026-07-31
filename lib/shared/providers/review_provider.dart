/// Riverpod state for [ReviewModel]s.
library;

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mock/mock_data.dart';
import '../models/models.dart';

class ReviewNotifier extends Notifier<List<ReviewModel>> {
  @override
  List<ReviewModel> build() {
    MockData.init();
    return List<ReviewModel>.from(MockData.reviews);
  }

  ReviewModel? getById(String id) => state.firstWhereOrNull((r) => r.id == id);

  void create(ReviewModel review) {
    state = [review, ...state];
  }

  void update(ReviewModel review) {
    state = [
      for (final r in state) if (r.id == review.id) review else r,
    ];
  }

  void delete(String id) {
    state = state.where((r) => r.id != id).toList();
  }
}

final reviewProvider = NotifierProvider<ReviewNotifier, List<ReviewModel>>(ReviewNotifier.new);

final reviewsForTalentProvider = Provider.family<List<ReviewModel>, String>((ref, talentId) {
  final list = ref.watch(reviewProvider).where((r) => r.talentId == talentId).toList();
  list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return list;
});

final averageRatingForTalentProvider = Provider.family<double, String>((ref, talentId) {
  final reviews = ref.watch(reviewsForTalentProvider(talentId));
  if (reviews.isEmpty) return 0;
  final sum = reviews.fold<double>(0, (acc, r) => acc + r.rating);
  return double.parse((sum / reviews.length).toStringAsFixed(1));
});
