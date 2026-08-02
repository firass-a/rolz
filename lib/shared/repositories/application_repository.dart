/// Simulates an applications API. `apply` and `updateStatus` also drive the
/// side effects a real backend would trigger: bumping the casting's
/// applicant count and dropping a notification for the affected talent.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_strings.dart';
import '../models/models.dart';
import '../providers/application_provider.dart';
import '../providers/casting_provider.dart';
import '../providers/recruiter_provider.dart';
import '../providers/talent_provider.dart';
import 'notification_repository.dart';

class ApplicationRepository {
  ApplicationRepository(this._ref);

  final Ref _ref;

  static const _uuid = Uuid();
  static const _latency = Duration(milliseconds: 300);

  ApplicationNotifier get _notifier => _ref.read(applicationProvider.notifier);

  ApplicationModel? getById(String id) => _notifier.getById(id);

  List<ApplicationModel> getByTalent(String talentId) =>
      _ref.read(applicationProvider).where((a) => a.talentId == talentId).toList();

  List<ApplicationModel> getByCasting(String castingId) =>
      _ref.read(applicationProvider).where((a) => a.castingId == castingId).toList();

  /// A talent applies to a casting: creates the [ApplicationModel], bumps
  /// the casting's applicant count, and notifies the recruiter.
  Future<ApplicationModel> apply({
    required String castingId,
    required String talentId,
    String coverLetter = '',
  }) async {
    await Future.delayed(_latency);

    final casting = _ref.read(castingProvider.notifier).getById(castingId);
    final now = DateTime.now();
    final application = ApplicationModel(
      id: _uuid.v4(),
      castingId: castingId,
      talentId: talentId,
      recruiterId: casting?.recruiterId ?? '',
      status: ApplicationStatus.pending,
      coverLetter: coverLetter,
      createdAt: now,
      updatedAt: now,
    );
    _notifier.create(application);
    _ref.read(castingProvider.notifier).incrementApplicantCount(castingId);

    if (casting != null) {
      final recruiterUserId = _ref.read(recruiterProvider.notifier).getById(casting.recruiterId)?.userId;
      if (recruiterUserId != null) {
        _ref.read(notificationRepositoryProvider).add(
              userId: recruiterUserId,
              type: NotificationType.application,
              title: AppStrings.notifNewApplicationTitle,
              body: AppStrings.notifNewApplicationBody(casting.title),
              relatedId: application.id,
            );
      }
    }

    return application;
  }

  Future<void> create(ApplicationModel application) async {
    await Future.delayed(_latency);
    _notifier.create(application);
  }

  Future<void> update(ApplicationModel application) async {
    await Future.delayed(_latency);
    _notifier.update(application);
  }

  Future<void> delete(String id) async {
    await Future.delayed(_latency);
    _notifier.delete(id);
  }

  /// Updates the application's status and, for accept/reject decisions,
  /// notifies the talent.
  Future<void> updateStatus(String id, ApplicationStatus status) async {
    await Future.delayed(_latency);
    final application = getById(id);
    _notifier.updateStatus(id, status);
    if (application == null) return;

    final casting = _ref.read(castingProvider.notifier).getById(application.castingId);
    final castingTitle = casting?.title ?? AppStrings.aCasting;
    final talentUserId = _ref.read(talentProvider.notifier).getById(application.talentId)?.userId;
    if (talentUserId == null) return;

    if (status == ApplicationStatus.accepted) {
      _ref.read(notificationRepositoryProvider).add(
            userId: talentUserId,
            type: NotificationType.acceptance,
            title: AppStrings.notifApplicationAcceptedTitle,
            body: AppStrings.notifApplicationAcceptedBody(castingTitle),
            relatedId: application.id,
          );
    } else if (status == ApplicationStatus.rejected) {
      _ref.read(notificationRepositoryProvider).add(
            userId: talentUserId,
            type: NotificationType.rejection,
            title: AppStrings.notifApplicationUpdateTitle,
            body: AppStrings.notifApplicationRejectedBody(castingTitle),
            relatedId: application.id,
          );
    }
  }
}

final applicationRepositoryProvider = Provider<ApplicationRepository>((ref) => ApplicationRepository(ref));
