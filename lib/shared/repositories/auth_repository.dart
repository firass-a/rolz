/// Simulates an authentication API: fake network delay + validation, backed
/// by [MockData]. Successful registration also spins up the matching
/// [TalentModel] or [RecruiterModel] profile so the rest of the app has
/// something to render immediately after sign-up.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_strings.dart';
import '../mock/mock_data.dart';
import '../models/models.dart';
import '../providers/recruiter_provider.dart';
import '../providers/talent_provider.dart';

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}

class AuthRepository {
  AuthRepository(this._ref);

  final Ref _ref;

  static const _uuid = Uuid();
  static const _latency = Duration(milliseconds: 300);

  Future<UserModel?> login(String email, String password) async {
    await Future.delayed(_latency);
    return MockData.login(email, password);
  }

  Future<UserModel> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required UserRole role,
  }) async {
    await Future.delayed(_latency);

    final emailTaken = MockData.users.any((u) => u.email.toLowerCase() == email.toLowerCase());
    if (emailTaken) {
      throw AuthException(AppStrings.emailExists);
    }

    final id = _uuid.v4();
    final now = DateTime.now();
    final user = UserModel(
      id: id,
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      role: role,
      isVerified: false,
      status: UserStatus.active,
      createdAt: now,
      lastSeen: now,
    );

    // MockData.users is the lookup table MockData.login() reads from, so we
    // sync new accounts into it too — otherwise a freshly registered user
    // could never log back in after logging out.
    MockData.users.add(user);

    switch (role) {
      case UserRole.talent:
        final talent = TalentModel(
          id: 'talent-${id.substring(0, 8)}',
          userId: id,
          firstName: firstName,
          lastName: lastName,
          email: email,
          category: TalentCategory.actor,
          gender: Gender.male,
          age: 18,
          dateOfBirth: DateTime(now.year - 18, now.month, now.day),
          heightCm: 170,
          weightKg: 65,
          city: 'Algiers',
          country: 'Algeria',
          nationality: 'Algerian',
          createdAt: now,
          updatedAt: now,
        );
        _ref.read(talentProvider.notifier).create(talent);
        break;
      case UserRole.recruiter:
        final recruiter = RecruiterModel(
          id: 'recruiter-${id.substring(0, 8)}',
          userId: id,
          firstName: firstName,
          lastName: lastName,
          email: email,
          companyName: '$firstName $lastName',
          companyType: CompanyType.agency,
          city: 'Algiers',
          country: 'Algeria',
          createdAt: now,
        );
        _ref.read(recruiterProvider.notifier).create(recruiter);
        break;
      case UserRole.admin:
      case UserRole.guest:
        break;
    }

    return user;
  }

  Future<bool> verifyOtp(String otp) async {
    await Future.delayed(_latency);
    return true;
  }

  Future<bool> forgotPassword(String email) async {
    await Future.delayed(_latency);
    return true;
  }

  /// Keeps [MockData.users] consistent with profile edits made through
  /// [AuthNotifier.updateProfile].
  void syncUser(UserModel user) {
    final index = MockData.users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      MockData.users[index] = user;
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository(ref));
