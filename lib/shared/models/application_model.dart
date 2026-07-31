import 'package:equatable/equatable.dart';

import 'enums.dart';

/// A talent's application to a [CastingModel].
class ApplicationModel extends Equatable {
  final String id;
  final String castingId;
  final String talentId;
  final String recruiterId;
  final ApplicationStatus status;
  final String coverLetter;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String notes;

  const ApplicationModel({
    required this.id,
    required this.castingId,
    required this.talentId,
    required this.recruiterId,
    this.status = ApplicationStatus.pending,
    this.coverLetter = '',
    required this.createdAt,
    required this.updatedAt,
    this.notes = '',
  });

  bool get isPending => status == ApplicationStatus.pending;

  bool get isAccepted => status == ApplicationStatus.accepted;

  ApplicationModel copyWith({
    String? id,
    String? castingId,
    String? talentId,
    String? recruiterId,
    ApplicationStatus? status,
    String? coverLetter,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? notes,
  }) {
    return ApplicationModel(
      id: id ?? this.id,
      castingId: castingId ?? this.castingId,
      talentId: talentId ?? this.talentId,
      recruiterId: recruiterId ?? this.recruiterId,
      status: status ?? this.status,
      coverLetter: coverLetter ?? this.coverLetter,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        castingId,
        talentId,
        recruiterId,
        status,
        coverLetter,
        createdAt,
        updatedAt,
        notes,
      ];
}
