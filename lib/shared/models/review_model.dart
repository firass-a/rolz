import 'package:equatable/equatable.dart';

/// A recruiter's review left on a talent's profile after a booking.
class ReviewModel extends Equatable {
  final String id;
  final String talentId;
  final String reviewerId;
  final String reviewerName;
  final double rating;
  final String comment;
  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.talentId,
    required this.reviewerId,
    required this.reviewerName,
    required this.rating,
    this.comment = '',
    required this.createdAt,
  });

  ReviewModel copyWith({
    String? id,
    String? talentId,
    String? reviewerId,
    String? reviewerName,
    double? rating,
    String? comment,
    DateTime? createdAt,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      talentId: talentId ?? this.talentId,
      reviewerId: reviewerId ?? this.reviewerId,
      reviewerName: reviewerName ?? this.reviewerName,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        talentId,
        reviewerId,
        reviewerName,
        rating,
        comment,
        createdAt,
      ];
}
