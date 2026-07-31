import 'package:equatable/equatable.dart';

import 'enums.dart';

/// The base account record shared by every person who can sign in to
/// KAST-ROLZ, regardless of whether they end up as a [TalentModel] or a
/// [RecruiterModel].
class UserModel extends Equatable {
  final String id;
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final UserRole role;
  final String avatarUrl;
  final String coverUrl;
  final String phone;
  final bool isVerified;
  final bool isPremium;
  final UserStatus status;
  final DateTime createdAt;
  final DateTime lastSeen;
  final String bio;

  const UserModel({
    required this.id,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.avatarUrl = '',
    this.coverUrl = '',
    this.phone = '',
    this.isVerified = false,
    this.isPremium = false,
    this.status = UserStatus.active,
    required this.createdAt,
    required this.lastSeen,
    this.bio = '',
  });

  /// Full display name, e.g. "Amina Sofiane".
  String get fullName => '$firstName $lastName'.trim();

  /// Two-letter initials, e.g. "AS", used for avatar fallbacks.
  String get initials {
    final f = firstName.isNotEmpty ? firstName[0] : '';
    final l = lastName.isNotEmpty ? lastName[0] : '';
    return '$f$l'.toUpperCase();
  }

  bool get isOnline => DateTime.now().difference(lastSeen).inMinutes < 5;

  UserModel copyWith({
    String? id,
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    UserRole? role,
    String? avatarUrl,
    String? coverUrl,
    String? phone,
    bool? isVerified,
    bool? isPremium,
    UserStatus? status,
    DateTime? createdAt,
    DateTime? lastSeen,
    String? bio,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      phone: phone ?? this.phone,
      isVerified: isVerified ?? this.isVerified,
      isPremium: isPremium ?? this.isPremium,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      lastSeen: lastSeen ?? this.lastSeen,
      bio: bio ?? this.bio,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        password,
        firstName,
        lastName,
        role,
        avatarUrl,
        coverUrl,
        phone,
        isVerified,
        isPremium,
        status,
        createdAt,
        lastSeen,
        bio,
      ];
}
