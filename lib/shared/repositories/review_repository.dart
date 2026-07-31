/// Simulates a reviews API on top of [ReviewNotifier]. Creating/deleting a
/// review also recomputes and syncs the target talent's `rating` /
/// `reviewCount` summary fields via [TalentNotifier].
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/models.dart';
import '../providers/review_provider.dart';
import '../providers/talent_provider.dart';

class ReviewRepository {
  ReviewRepository(this._ref);

  final Ref _ref;

  static const _uuid = Uuid();
  static const _latency = Duration(milliseconds: 300);

  ReviewNotifier get _notifier => _ref.read(reviewProvider.notifier);

  ReviewModel? getById(String id) => _notifier.getById(id);

  List<ReviewModel> forTalent(String talentId) =>
      _ref.read(reviewProvider).where((r) => r.talentId == talentId).toList();

  Future<ReviewModel> create({
    required String talentId,
    required String reviewerId,
    required String reviewerName,
    required double rating,
    String comment = '',
  }) async {
    await Future.delayed(_latency);
    final review = ReviewModel(
      id: _uuid.v4(),
      talentId: talentId,
      reviewerId: reviewerId,
      reviewerName: reviewerName,
      rating: rating,
      comment: comment,
      createdAt: DateTime.now(),
    );
    _notifier.create(review);
    _syncTalentRating(talentId);
    return review;
  }

  Future<void> update(ReviewModel review) async {
    await Future.delayed(_latency);
    _notifier.update(review);
    _syncTalentRating(review.talentId);
  }

  Future<void> delete(String id) async {
    await Future.delayed(_latency);
    final review = getById(id);
    _notifier.delete(id);
    if (review != null) _syncTalentRating(review.talentId);
  }

  void _syncTalentRating(String talentId) {
    final reviews = forTalent(talentId);
    final avg = reviews.isEmpty
        ? 0.0
        : double.parse(
            (reviews.fold<double>(0, (acc, r) => acc + r.rating) / reviews.length).toStringAsFixed(1),
          );
    _ref.read(talentProvider.notifier).updateRatingSummary(
          talentId,
          rating: avg,
          reviewCount: reviews.length,
        );
  }
}

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) => ReviewRepository(ref));
