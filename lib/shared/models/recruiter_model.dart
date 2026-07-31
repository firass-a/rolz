import 'package:equatable/equatable.dart';

import 'enums.dart';

/// A recruiter (director, producer, casting director, agency, brand or
/// studio) who posts castings and hires talents.
class RecruiterModel extends Equatable {
  final String id;
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String avatarUrl;
  final String companyName;
  final String companyLogo;
  final String companyCover;
  final CompanyType companyType;
  final String city;
  final String country;
  final String bio;
  final String website;
  final bool isVerified;
  final int castingCount;
  final int hireCount;
  final double rating;
  final DateTime createdAt;

  const RecruiterModel({
    required this.id,
    required this.userId,
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phone = '',
    this.avatarUrl = '',
    required this.companyName,
    this.companyLogo = '',
    this.companyCover = '',
    required this.companyType,
    required this.city,
    required this.country,
    this.bio = '',
    this.website = '',
    this.isVerified = false,
    this.castingCount = 0,
    this.hireCount = 0,
    this.rating = 0.0,
    required this.createdAt,
  });

  String get fullName => '$firstName $lastName'.trim();

  String get locationLabel => '$city, $country';

  RecruiterModel copyWith({
    String? id,
    String? userId,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? avatarUrl,
    String? companyName,
    String? companyLogo,
    String? companyCover,
    CompanyType? companyType,
    String? city,
    String? country,
    String? bio,
    String? website,
    bool? isVerified,
    int? castingCount,
    int? hireCount,
    double? rating,
    DateTime? createdAt,
  }) {
    return RecruiterModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      companyName: companyName ?? this.companyName,
      companyLogo: companyLogo ?? this.companyLogo,
      companyCover: companyCover ?? this.companyCover,
      companyType: companyType ?? this.companyType,
      city: city ?? this.city,
      country: country ?? this.country,
      bio: bio ?? this.bio,
      website: website ?? this.website,
      isVerified: isVerified ?? this.isVerified,
      castingCount: castingCount ?? this.castingCount,
      hireCount: hireCount ?? this.hireCount,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
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
        avatarUrl,
        companyName,
        companyLogo,
        companyCover,
        companyType,
        city,
        country,
        bio,
        website,
        isVerified,
        castingCount,
        hireCount,
        rating,
        createdAt,
      ];
}
