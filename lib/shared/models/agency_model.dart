import 'package:equatable/equatable.dart';

/// A talent agency that represents (and can be linked to) multiple talents.
class AgencyModel extends Equatable {
  final String id;
  final String name;
  final String logoUrl;
  final String coverUrl;
  final String description;
  final String city;
  final String country;
  final String website;
  final int talentCount;
  final bool isVerified;
  final List<String> specialties;
  final double rating;
  final DateTime createdAt;

  const AgencyModel({
    required this.id,
    required this.name,
    this.logoUrl = '',
    this.coverUrl = '',
    this.description = '',
    required this.city,
    required this.country,
    this.website = '',
    this.talentCount = 0,
    this.isVerified = false,
    this.specialties = const [],
    this.rating = 0.0,
    required this.createdAt,
  });

  String get locationLabel => '$city, $country';

  AgencyModel copyWith({
    String? id,
    String? name,
    String? logoUrl,
    String? coverUrl,
    String? description,
    String? city,
    String? country,
    String? website,
    int? talentCount,
    bool? isVerified,
    List<String>? specialties,
    double? rating,
    DateTime? createdAt,
  }) {
    return AgencyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      description: description ?? this.description,
      city: city ?? this.city,
      country: country ?? this.country,
      website: website ?? this.website,
      talentCount: talentCount ?? this.talentCount,
      isVerified: isVerified ?? this.isVerified,
      specialties: specialties ?? this.specialties,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        logoUrl,
        coverUrl,
        description,
        city,
        country,
        website,
        talentCount,
        isVerified,
        specialties,
        rating,
        createdAt,
      ];
}
