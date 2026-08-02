/// Central place for every enum used across the KAST-ROLZ app, plus small
/// display-label extensions so the UI layer never has to hardcode strings.
library;

import '../../core/constants/app_strings.dart';

enum UserRole { talent, recruiter, admin, guest }

extension UserRoleX on UserRole {
  String get label {
    switch (this) {
      case UserRole.talent:
        return AppStrings.roleTalentLabel;
      case UserRole.recruiter:
        return AppStrings.roleRecruiterLabel;
      case UserRole.admin:
        return AppStrings.roleAdminLabel;
      case UserRole.guest:
        return AppStrings.roleGuestLabel;
    }
  }
}

enum TalentCategory {
  actor,
  actress,
  model,
  extra,
  voiceActor,
  dancer,
  musician,
  contentCreator,
  photographer,
}

extension TalentCategoryX on TalentCategory {
  String get label {
    switch (this) {
      case TalentCategory.actor:
        return AppStrings.catActor;
      case TalentCategory.actress:
        return AppStrings.catActress;
      case TalentCategory.model:
        return AppStrings.catModel;
      case TalentCategory.extra:
        return AppStrings.catExtra;
      case TalentCategory.voiceActor:
        return AppStrings.catVoiceActor;
      case TalentCategory.dancer:
        return AppStrings.catDancer;
      case TalentCategory.musician:
        return AppStrings.catMusician;
      case TalentCategory.contentCreator:
        return AppStrings.catContentCreator;
      case TalentCategory.photographer:
        return AppStrings.catPhotographer;
    }
  }
}

enum Gender { male, female, nonBinary, other }

extension GenderX on Gender {
  String get label {
    switch (this) {
      case Gender.male:
        return AppStrings.genderMale;
      case Gender.female:
        return AppStrings.genderFemale;
      case Gender.nonBinary:
        return AppStrings.genderNonBinary;
      case Gender.other:
        return AppStrings.genderOther;
    }
  }
}

enum AvailabilityStatus { available, busy, limited }

extension AvailabilityStatusX on AvailabilityStatus {
  String get label {
    switch (this) {
      case AvailabilityStatus.available:
        return AppStrings.availAvailable;
      case AvailabilityStatus.busy:
        return AppStrings.availBusy;
      case AvailabilityStatus.limited:
        return AppStrings.availLimited;
    }
  }
}

enum CastingStatus { open, closed, filled, draft, archived }

extension CastingStatusX on CastingStatus {
  String get label {
    switch (this) {
      case CastingStatus.open:
        return AppStrings.statusOpen;
      case CastingStatus.closed:
        return AppStrings.statusClosed;
      case CastingStatus.filled:
        return AppStrings.statusFilled;
      case CastingStatus.draft:
        return AppStrings.statusDraft;
      case CastingStatus.archived:
        return AppStrings.statusArchived;
    }
  }
}

enum ApplicationStatus { pending, accepted, rejected, withdrawn, shortlisted }

extension ApplicationStatusX on ApplicationStatus {
  String get label {
    switch (this) {
      case ApplicationStatus.pending:
        return AppStrings.appPending;
      case ApplicationStatus.accepted:
        return AppStrings.appAccepted;
      case ApplicationStatus.rejected:
        return AppStrings.appRejected;
      case ApplicationStatus.withdrawn:
        return AppStrings.appWithdrawn;
      case ApplicationStatus.shortlisted:
        return AppStrings.appShortlisted;
    }
  }
}

enum NotificationType {
  like,
  application,
  acceptance,
  rejection,
  message,
  reminder,
  verification,
  system,
}

extension NotificationTypeX on NotificationType {
  String get label {
    switch (this) {
      case NotificationType.like:
        return AppStrings.notifLike;
      case NotificationType.application:
        return AppStrings.notifApplication;
      case NotificationType.acceptance:
        return AppStrings.notifAcceptance;
      case NotificationType.rejection:
        return AppStrings.notifRejection;
      case NotificationType.message:
        return AppStrings.notifMessage;
      case NotificationType.reminder:
        return AppStrings.notifReminder;
      case NotificationType.verification:
        return AppStrings.notifVerification;
      case NotificationType.system:
        return AppStrings.notifSystem;
    }
  }
}

enum MessageType { text, image, voice, system }

extension MessageTypeX on MessageType {
  String get label {
    switch (this) {
      case MessageType.text:
        return AppStrings.msgTypeText;
      case MessageType.image:
        return AppStrings.msgTypeImage;
      case MessageType.voice:
        return AppStrings.msgTypeVoice;
      case MessageType.system:
        return AppStrings.msgTypeSystem;
    }
  }
}

enum ExperienceLevel { beginner, intermediate, professional, celebrity }

extension ExperienceLevelX on ExperienceLevel {
  String get label {
    switch (this) {
      case ExperienceLevel.beginner:
        return AppStrings.expBeginner;
      case ExperienceLevel.intermediate:
        return AppStrings.expIntermediate;
      case ExperienceLevel.professional:
        return AppStrings.expProfessional;
      case ExperienceLevel.celebrity:
        return AppStrings.expCelebrity;
    }
  }
}

enum ReportStatus { pending, resolved, dismissed }

extension ReportStatusX on ReportStatus {
  String get label {
    switch (this) {
      case ReportStatus.pending:
        return AppStrings.reportPending;
      case ReportStatus.resolved:
        return AppStrings.reportResolved;
      case ReportStatus.dismissed:
        return AppStrings.reportDismissed;
    }
  }
}

enum UserStatus { active, banned, pendingVerification, suspended }

extension UserStatusX on UserStatus {
  String get label {
    switch (this) {
      case UserStatus.active:
        return AppStrings.userActive;
      case UserStatus.banned:
        return AppStrings.userBanned;
      case UserStatus.pendingVerification:
        return AppStrings.userPendingVerification;
      case UserStatus.suspended:
        return AppStrings.userSuspended;
    }
  }
}

/// The kind of organisation/person a [RecruiterModel] represents.
enum CompanyType { director, producer, castingDirector, agency, brand, studio }

extension CompanyTypeX on CompanyType {
  String get label {
    switch (this) {
      case CompanyType.director:
        return AppStrings.companyDirector;
      case CompanyType.producer:
        return AppStrings.companyProducer;
      case CompanyType.castingDirector:
        return AppStrings.companyCastingDirector;
      case CompanyType.agency:
        return AppStrings.companyAgency;
      case CompanyType.brand:
        return AppStrings.companyBrand;
      case CompanyType.studio:
        return AppStrings.companyStudio;
    }
  }
}

/// The kind of production a [CastingModel] is for. Used to power the
/// "film / TV / commercial / theater / voice / fashion" filters in the app.
enum CastingType { film, tv, commercial, theater, voiceOver, fashion, musicVideo, other }

extension CastingTypeX on CastingType {
  String get label {
    switch (this) {
      case CastingType.film:
        return AppStrings.castingTypeFilm;
      case CastingType.tv:
        return AppStrings.castingTypeTv;
      case CastingType.commercial:
        return AppStrings.castingTypeCommercial;
      case CastingType.theater:
        return AppStrings.castingTypeTheater;
      case CastingType.voiceOver:
        return AppStrings.castingTypeVoiceOver;
      case CastingType.fashion:
        return AppStrings.castingTypeFashion;
      case CastingType.musicVideo:
        return AppStrings.castingTypeMusicVideo;
      case CastingType.other:
        return AppStrings.castingTypeOther;
    }
  }
}

/// The kind of item a [FavoriteModel] points to.
enum FavoriteItemType { talent, casting, agency }

extension FavoriteItemTypeX on FavoriteItemType {
  String get label {
    switch (this) {
      case FavoriteItemType.talent:
        return AppStrings.favTalent;
      case FavoriteItemType.casting:
        return AppStrings.favCasting;
      case FavoriteItemType.agency:
        return AppStrings.favAgency;
    }
  }
}

/// The kind of entity a [ReportModel] targets.
enum ReportTargetType { user, talent, recruiter, casting, message, review }

extension ReportTargetTypeX on ReportTargetType {
  String get label {
    switch (this) {
      case ReportTargetType.user:
        return AppStrings.reportTargetUser;
      case ReportTargetType.talent:
        return AppStrings.reportTargetTalent;
      case ReportTargetType.recruiter:
        return AppStrings.reportTargetRecruiter;
      case ReportTargetType.casting:
        return AppStrings.reportTargetCasting;
      case ReportTargetType.message:
        return AppStrings.reportTargetMessage;
      case ReportTargetType.review:
        return AppStrings.reportTargetReview;
    }
  }
}
