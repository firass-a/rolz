import 'package:equatable/equatable.dart';

import 'enums.dart';

/// A single line of a talent's résumé, e.g. a film credit or a stage role.
class ExperienceEntry extends Equatable {
  final String title;
  final String role;
  final int year;
  final String? description;

  const ExperienceEntry({
    required this.title,
    required this.role,
    required this.year,
    this.description,
  });

  ExperienceEntry copyWith({
    String? title,
    String? role,
    int? year,
    String? description,
  }) {
    return ExperienceEntry(
      title: title ?? this.title,
      role: role ?? this.role,
      year: year ?? this.year,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [title, role, year, description];
}

/// A talent (actor, model, dancer, etc.) profile. It carries a denormalised
/// copy of the essential account fields (name, email, phone) so talent cards
/// and profile screens never need to join against [UserModel].
class TalentModel extends Equatable {
  final String id;
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final TalentCategory category;
  final Gender gender;
  final int age;
  final DateTime dateOfBirth;
  final double heightCm;
  final double weightKg;
  final String eyeColor;
  final String hairColor;
  final String city;
  final String country;
  final String nationality;
  final List<String> languages;
  final List<String> skills;
  final ExperienceLevel experienceLevel;
  final int yearsOfExperience;
  final String biography;
  final String headshotUrl;
  final String coverUrl;
  final List<String> portfolioUrls;
  final List<String> galleryUrls;
  final List<String> videoThumbnails;
  final Map<String, String> socialLinks;
  final AvailabilityStatus availability;
  final double rating;
  final int reviewCount;
  final int viewCount;
  final bool isVerified;
  final bool isFeatured;
  final bool isArchived;
  final String? agencyId;
  final String education;
  final List<ExperienceEntry> experience;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TalentModel({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone = '',
    required this.category,
    required this.gender,
    required this.age,
    required this.dateOfBirth,
    required this.heightCm,
    required this.weightKg,
    this.eyeColor = '',
    this.hairColor = '',
    required this.city,
    required this.country,
    required this.nationality,
    this.languages = const [],
    this.skills = const [],
    this.experienceLevel = ExperienceLevel.beginner,
    this.yearsOfExperience = 0,
    this.biography = '',
    this.headshotUrl = '',
    this.coverUrl = '',
    this.portfolioUrls = const [],
    this.galleryUrls = const [],
    this.videoThumbnails = const [],
    this.socialLinks = const {},
    this.availability = AvailabilityStatus.available,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.viewCount = 0,
    this.isVerified = false,
    this.isFeatured = false,
    this.isArchived = false,
    this.agencyId,
    this.education = '',
    this.experience = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName => '$firstName $lastName'.trim();

  String get initials {
    final f = firstName.isNotEmpty ? firstName[0] : '';
    final l = lastName.isNotEmpty ? lastName[0] : '';
    return '$f$l'.toUpperCase();
  }

  String get locationLabel => '$city, $country';

  String get heightDisplay => '${heightCm.toStringAsFixed(0)} cm';

  bool get hasAgency => agencyId != null && agencyId!.isNotEmpty;

  TalentModel copyWith({
    String? id,
    String? userId,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    TalentCategory? category,
    Gender? gender,
    int? age,
    DateTime? dateOfBirth,
    double? heightCm,
    double? weightKg,
    String? eyeColor,
    String? hairColor,
    String? city,
    String? country,
    String? nationality,
    List<String>? languages,
    List<String>? skills,
    ExperienceLevel? experienceLevel,
    int? yearsOfExperience,
    String? biography,
    String? headshotUrl,
    String? coverUrl,
    List<String>? portfolioUrls,
    List<String>? galleryUrls,
    List<String>? videoThumbnails,
    Map<String, String>? socialLinks,
    AvailabilityStatus? availability,
    double? rating,
    int? reviewCount,
    int? viewCount,
    bool? isVerified,
    bool? isFeatured,
    bool? isArchived,
    String? agencyId,
    String? education,
    List<ExperienceEntry>? experience,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TalentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      category: category ?? this.category,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      eyeColor: eyeColor ?? this.eyeColor,
      hairColor: hairColor ?? this.hairColor,
      city: city ?? this.city,
      country: country ?? this.country,
      nationality: nationality ?? this.nationality,
      languages: languages ?? this.languages,
      skills: skills ?? this.skills,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      biography: biography ?? this.biography,
      headshotUrl: headshotUrl ?? this.headshotUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      portfolioUrls: portfolioUrls ?? this.portfolioUrls,
      galleryUrls: galleryUrls ?? this.galleryUrls,
      videoThumbnails: videoThumbnails ?? this.videoThumbnails,
      socialLinks: socialLinks ?? this.socialLinks,
      availability: availability ?? this.availability,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      viewCount: viewCount ?? this.viewCount,
      isVerified: isVerified ?? this.isVerified,
      isFeatured: isFeatured ?? this.isFeatured,
      isArchived: isArchived ?? this.isArchived,
      agencyId: agencyId ?? this.agencyId,
      education: education ?? this.education,
      experience: experience ?? this.experience,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        firstName,
        lastName,
        email,
        phone,
        category,
        gender,
        age,
        dateOfBirth,
        heightCm,
        weightKg,
        eyeColor,
        hairColor,
        city,
        country,
        nationality,
        languages,
        skills,
        experienceLevel,
        yearsOfExperience,
        biography,
        headshotUrl,
        coverUrl,
        portfolioUrls,
        galleryUrls,
        videoThumbnails,
        socialLinks,
        availability,
        rating,
        reviewCount,
        viewCount,
        isVerified,
        isFeatured,
        isArchived,
        agencyId,
        education,
        experience,
        createdAt,
        updatedAt,
      ];
}
