import 'package:equatable/equatable.dart';

import '../../core/constants/app_strings.dart';
import '../../core/l10n/display_localizer.dart';
import '../../core/l10n/locale_controller.dart';
import 'enums.dart';

/// A casting call/job post created by a [RecruiterModel] (optionally on
/// behalf of an [AgencyModel]) that talents can apply to.
class CastingModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String role;
  final TalentCategory category;
  final CastingType type;
  final String bannerUrl;
  final String thumbnailUrl;
  final String recruiterId;
  final String? agencyId;
  final String location;
  final String city;
  final String country;
  final double salary;
  final String currency;
  final Gender? gender;
  final int ageMin;
  final int ageMax;
  final double? heightMin;
  final double? heightMax;
  final List<String> requirements;
  final List<String> skills;
  final List<String> languages;
  final ExperienceLevel experienceLevel;
  final CastingStatus status;
  final bool isFeatured;
  final bool isUrgent;
  final bool isArchived;
  final DateTime applicationDeadline;
  final DateTime shootStartDate;
  final DateTime shootEndDate;
  final int applicantCount;
  final int viewCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CastingModel({
    required this.id,
    required this.title,
    this.description = '',
    this.role = '',
    required this.category,
    this.type = CastingType.other,
    this.bannerUrl = '',
    this.thumbnailUrl = '',
    required this.recruiterId,
    this.agencyId,
    this.location = '',
    required this.city,
    required this.country,
    this.salary = 0,
    this.currency = 'DZD',
    this.gender,
    this.ageMin = 18,
    this.ageMax = 65,
    this.heightMin,
    this.heightMax,
    this.requirements = const [],
    this.skills = const [],
    this.languages = const [],
    this.experienceLevel = ExperienceLevel.beginner,
    this.status = CastingStatus.open,
    this.isFeatured = false,
    this.isUrgent = false,
    this.isArchived = false,
    required this.applicationDeadline,
    required this.shootStartDate,
    required this.shootEndDate,
    this.applicantCount = 0,
    this.viewCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isOpen => status == CastingStatus.open;

  bool get hasAgency => agencyId != null && agencyId!.isNotEmpty;

  String get ageRangeLabel => '$ageMin-$ageMax yrs';

  String get locationLabel {
    final sep = LocaleController.isArabic ? '، ' : ', ';
    return '${DisplayLocalizer.t(city)}$sep${DisplayLocalizer.t(country)}';
  }

  String get salaryLabel =>
      salary > 0 ? '${salary.toStringAsFixed(0)} $currency' : AppStrings.negotiable;

  bool get isExpired => DateTime.now().isAfter(applicationDeadline);

  CastingModel copyWith({
    String? id,
    String? title,
    String? description,
    String? role,
    TalentCategory? category,
    CastingType? type,
    String? bannerUrl,
    String? thumbnailUrl,
    String? recruiterId,
    String? agencyId,
    String? location,
    String? city,
    String? country,
    double? salary,
    String? currency,
    Gender? gender,
    int? ageMin,
    int? ageMax,
    double? heightMin,
    double? heightMax,
    List<String>? requirements,
    List<String>? skills,
    List<String>? languages,
    ExperienceLevel? experienceLevel,
    CastingStatus? status,
    bool? isFeatured,
    bool? isUrgent,
    bool? isArchived,
    DateTime? applicationDeadline,
    DateTime? shootStartDate,
    DateTime? shootEndDate,
    int? applicantCount,
    int? viewCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CastingModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      role: role ?? this.role,
      category: category ?? this.category,
      type: type ?? this.type,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      recruiterId: recruiterId ?? this.recruiterId,
      agencyId: agencyId ?? this.agencyId,
      location: location ?? this.location,
      city: city ?? this.city,
      country: country ?? this.country,
      salary: salary ?? this.salary,
      currency: currency ?? this.currency,
      gender: gender ?? this.gender,
      ageMin: ageMin ?? this.ageMin,
      ageMax: ageMax ?? this.ageMax,
      heightMin: heightMin ?? this.heightMin,
      heightMax: heightMax ?? this.heightMax,
      requirements: requirements ?? this.requirements,
      skills: skills ?? this.skills,
      languages: languages ?? this.languages,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      status: status ?? this.status,
      isFeatured: isFeatured ?? this.isFeatured,
      isUrgent: isUrgent ?? this.isUrgent,
      isArchived: isArchived ?? this.isArchived,
      applicationDeadline: applicationDeadline ?? this.applicationDeadline,
      shootStartDate: shootStartDate ?? this.shootStartDate,
      shootEndDate: shootEndDate ?? this.shootEndDate,
      applicantCount: applicantCount ?? this.applicantCount,
      viewCount: viewCount ?? this.viewCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        role,
        category,
        type,
        bannerUrl,
        thumbnailUrl,
        recruiterId,
        agencyId,
        location,
        city,
        country,
        salary,
        currency,
        gender,
        ageMin,
        ageMax,
        heightMin,
        heightMax,
        requirements,
        skills,
        languages,
        experienceLevel,
        status,
        isFeatured,
        isUrgent,
        isArchived,
        applicationDeadline,
        shootStartDate,
        shootEndDate,
        applicantCount,
        viewCount,
        createdAt,
        updatedAt,
      ];
}
