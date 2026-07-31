/// Central place for every enum used across the KAST-ROLZ app, plus small
/// display-label extensions so the UI layer never has to hardcode strings.
library;

enum UserRole { talent, recruiter, admin, guest }

extension UserRoleX on UserRole {
  String get label {
    switch (this) {
      case UserRole.talent:
        return 'Talent';
      case UserRole.recruiter:
        return 'Recruiter';
      case UserRole.admin:
        return 'Admin';
      case UserRole.guest:
        return 'Guest';
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
        return 'Actor';
      case TalentCategory.actress:
        return 'Actress';
      case TalentCategory.model:
        return 'Model';
      case TalentCategory.extra:
        return 'Extra';
      case TalentCategory.voiceActor:
        return 'Voice Actor';
      case TalentCategory.dancer:
        return 'Dancer';
      case TalentCategory.musician:
        return 'Musician';
      case TalentCategory.contentCreator:
        return 'Content Creator';
      case TalentCategory.photographer:
        return 'Photographer';
    }
  }
}

enum Gender { male, female, nonBinary, other }

extension GenderX on Gender {
  String get label {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.nonBinary:
        return 'Non-binary';
      case Gender.other:
        return 'Other';
    }
  }
}

enum AvailabilityStatus { available, busy, limited }

extension AvailabilityStatusX on AvailabilityStatus {
  String get label {
    switch (this) {
      case AvailabilityStatus.available:
        return 'Available';
      case AvailabilityStatus.busy:
        return 'Busy';
      case AvailabilityStatus.limited:
        return 'Limited';
    }
  }
}

enum CastingStatus { open, closed, filled, draft, archived }

extension CastingStatusX on CastingStatus {
  String get label {
    switch (this) {
      case CastingStatus.open:
        return 'Open';
      case CastingStatus.closed:
        return 'Closed';
      case CastingStatus.filled:
        return 'Filled';
      case CastingStatus.draft:
        return 'Draft';
      case CastingStatus.archived:
        return 'Archived';
    }
  }
}

enum ApplicationStatus { pending, accepted, rejected, withdrawn, shortlisted }

extension ApplicationStatusX on ApplicationStatus {
  String get label {
    switch (this) {
      case ApplicationStatus.pending:
        return 'Pending';
      case ApplicationStatus.accepted:
        return 'Accepted';
      case ApplicationStatus.rejected:
        return 'Rejected';
      case ApplicationStatus.withdrawn:
        return 'Withdrawn';
      case ApplicationStatus.shortlisted:
        return 'Shortlisted';
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
        return 'Like';
      case NotificationType.application:
        return 'Application';
      case NotificationType.acceptance:
        return 'Acceptance';
      case NotificationType.rejection:
        return 'Rejection';
      case NotificationType.message:
        return 'Message';
      case NotificationType.reminder:
        return 'Reminder';
      case NotificationType.verification:
        return 'Verification';
      case NotificationType.system:
        return 'System';
    }
  }
}

enum MessageType { text, image, voice, system }

extension MessageTypeX on MessageType {
  String get label {
    switch (this) {
      case MessageType.text:
        return 'Text';
      case MessageType.image:
        return 'Image';
      case MessageType.voice:
        return 'Voice';
      case MessageType.system:
        return 'System';
    }
  }
}

enum ExperienceLevel { beginner, intermediate, professional, celebrity }

extension ExperienceLevelX on ExperienceLevel {
  String get label {
    switch (this) {
      case ExperienceLevel.beginner:
        return 'Beginner';
      case ExperienceLevel.intermediate:
        return 'Intermediate';
      case ExperienceLevel.professional:
        return 'Professional';
      case ExperienceLevel.celebrity:
        return 'Celebrity';
    }
  }
}

enum ReportStatus { pending, resolved, dismissed }

extension ReportStatusX on ReportStatus {
  String get label {
    switch (this) {
      case ReportStatus.pending:
        return 'Pending';
      case ReportStatus.resolved:
        return 'Resolved';
      case ReportStatus.dismissed:
        return 'Dismissed';
    }
  }
}

enum UserStatus { active, banned, pendingVerification, suspended }

extension UserStatusX on UserStatus {
  String get label {
    switch (this) {
      case UserStatus.active:
        return 'Active';
      case UserStatus.banned:
        return 'Banned';
      case UserStatus.pendingVerification:
        return 'Pending Verification';
      case UserStatus.suspended:
        return 'Suspended';
    }
  }
}

/// The kind of organisation/person a [RecruiterModel] represents.
enum CompanyType { director, producer, castingDirector, agency, brand, studio }

extension CompanyTypeX on CompanyType {
  String get label {
    switch (this) {
      case CompanyType.director:
        return 'Director';
      case CompanyType.producer:
        return 'Producer';
      case CompanyType.castingDirector:
        return 'Casting Director';
      case CompanyType.agency:
        return 'Agency';
      case CompanyType.brand:
        return 'Brand';
      case CompanyType.studio:
        return 'Studio';
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
        return 'Film';
      case CastingType.tv:
        return 'TV';
      case CastingType.commercial:
        return 'Commercial';
      case CastingType.theater:
        return 'Theater';
      case CastingType.voiceOver:
        return 'Voice Over';
      case CastingType.fashion:
        return 'Fashion';
      case CastingType.musicVideo:
        return 'Music Video';
      case CastingType.other:
        return 'Other';
    }
  }
}

/// The kind of item a [FavoriteModel] points to.
enum FavoriteItemType { talent, casting, agency }

extension FavoriteItemTypeX on FavoriteItemType {
  String get label {
    switch (this) {
      case FavoriteItemType.talent:
        return 'Talent';
      case FavoriteItemType.casting:
        return 'Casting';
      case FavoriteItemType.agency:
        return 'Agency';
    }
  }
}

/// The kind of entity a [ReportModel] targets.
enum ReportTargetType { user, talent, recruiter, casting, message, review }

extension ReportTargetTypeX on ReportTargetType {
  String get label {
    switch (this) {
      case ReportTargetType.user:
        return 'User';
      case ReportTargetType.talent:
        return 'Talent';
      case ReportTargetType.recruiter:
        return 'Recruiter';
      case ReportTargetType.casting:
        return 'Casting';
      case ReportTargetType.message:
        return 'Message';
      case ReportTargetType.review:
        return 'Review';
    }
  }
}
