import 'package:equatable/equatable.dart';

import 'enums.dart';

/// A user-submitted report against another user, casting, message or review,
/// to be triaged by an admin.
class ReportModel extends Equatable {
  final String id;
  final String reporterId;
  final String targetId;
  final ReportTargetType targetType;
  final String reason;
  final ReportStatus status;
  final DateTime createdAt;

  const ReportModel({
    required this.id,
    required this.reporterId,
    required this.targetId,
    required this.targetType,
    required this.reason,
    this.status = ReportStatus.pending,
    required this.createdAt,
  });

  ReportModel copyWith({
    String? id,
    String? reporterId,
    String? targetId,
    ReportTargetType? targetType,
    String? reason,
    ReportStatus? status,
    DateTime? createdAt,
  }) {
    return ReportModel(
      id: id ?? this.id,
      reporterId: reporterId ?? this.reporterId,
      targetId: targetId ?? this.targetId,
      targetType: targetType ?? this.targetType,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        reporterId,
        targetId,
        targetType,
        reason,
        status,
        createdAt,
      ];
}
