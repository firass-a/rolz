/// Riverpod state for authentication. [authProvider] is the single source
/// of truth for the current user across the whole app — every other
/// "current user" helper below just derives from it.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mock/mock_data.dart';
import '../models/models.dart';
import '../repositories/auth_repository.dart';
import 'recruiter_provider.dart';
import 'talent_provider.dart';

class AuthState {
  final UserModel? user;
  final bool isAuthenticated;
  final bool isGuest;
  final bool hasCompletedOnboarding;
  final bool isLoading;
  final String? error;

  /// Role picked on the "who are you?" screen, before the registration
  /// form is filled in and [AuthNotifier.register] is called.
  final UserRole? selectedRole;

  const AuthState({
    this.user,
    this.isAuthenticated = false,
    this.isGuest = false,
    this.hasCompletedOnboarding = false,
    this.isLoading = false,
    this.error,
    this.selectedRole,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isAuthenticated,
    bool? isGuest,
    bool? hasCompletedOnboarding,
    bool? isLoading,
    String? error,
    UserRole? selectedRole,
    bool clearError = false,
  }) {
    return AuthState(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isGuest: isGuest ?? this.isGuest,
      hasCompletedOnboarding: hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      selectedRole: selectedRole ?? this.selectedRole,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    MockData.init();
    return const AuthState();
  }

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final user = await _repo.login(email, password);
    if (user == null) {
      state = state.copyWith(isLoading: false, error: 'Invalid email or password.');
      return;
    }
    state = AuthState(
      user: user,
      isAuthenticated: true,
      isGuest: false,
      hasCompletedOnboarding: true,
      isLoading: false,
    );
  }

  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required UserRole role,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repo.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        role: role,
      );
      state = AuthState(
        user: user,
        isAuthenticated: true,
        isGuest: false,
        hasCompletedOnboarding: true,
        isLoading: false,
      );
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    }
  }

  void logout() {
    state = AuthState(hasCompletedOnboarding: state.hasCompletedOnboarding);
  }

  void continueAsGuest() {
    state = AuthState(
      isAuthenticated: false,
      isGuest: true,
      hasCompletedOnboarding: true,
    );
  }

  void completeOnboarding() {
    state = state.copyWith(hasCompletedOnboarding: true);
  }

  void selectRole(UserRole role) {
    state = state.copyWith(selectedRole: role);
  }

  Future<bool> verifyOtp(String otp) async {
    state = state.copyWith(isLoading: true, clearError: true);
    await _repo.verifyOtp(otp);
    final user = state.user;
    if (user != null) {
      state = state.copyWith(user: user.copyWith(isVerified: true), isLoading: false);
    } else {
      state = state.copyWith(isLoading: false);
    }
    return true;
  }

  Future<bool> forgotPassword(String email) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final success = await _repo.forgotPassword(email);
    state = state.copyWith(isLoading: false);
    return success;
  }

  void updateProfile(UserModel updatedUser) {
    _repo.syncUser(updatedUser);
    state = state.copyWith(user: updatedUser);

    if (updatedUser.role == UserRole.talent) {
      final talent = ref.read(talentByUserIdProvider(updatedUser.id));
      if (talent != null) {
        ref.read(talentProvider.notifier).update(talent.copyWith(
              firstName: updatedUser.firstName,
              lastName: updatedUser.lastName,
              email: updatedUser.email,
              phone: updatedUser.phone,
              headshotUrl: updatedUser.avatarUrl.isNotEmpty ? updatedUser.avatarUrl : talent.headshotUrl,
              biography: updatedUser.bio.isNotEmpty ? updatedUser.bio : talent.biography,
            ));
      }
    } else if (updatedUser.role == UserRole.recruiter) {
      final recruiter = ref.read(recruiterByUserIdProvider(updatedUser.id));
      if (recruiter != null) {
        ref.read(recruiterProvider.notifier).update(recruiter.copyWith(
              firstName: updatedUser.firstName,
              lastName: updatedUser.lastName,
              email: updatedUser.email,
              phone: updatedUser.phone,
              avatarUrl: updatedUser.avatarUrl.isNotEmpty ? updatedUser.avatarUrl : recruiter.avatarUrl,
              bio: updatedUser.bio.isNotEmpty ? updatedUser.bio : recruiter.bio,
            ));
      }
    }
  }

  // ---------------------------------------------------------------------
  // Demo quick-login helpers, wired to the seeded MockData demo accounts.
  // ---------------------------------------------------------------------

  Future<void> loginAsTalent() => login('talent@kastrolz.com', 'demo123');

  Future<void> loginAsRecruiter() => login('recruiter@kastrolz.com', 'demo123');

  Future<void> loginAsAdmin() => login('admin@kastrolz.com', 'demo123');
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

final currentUserProvider = Provider<UserModel?>((ref) => ref.watch(authProvider).user);

final currentRoleProvider = Provider<UserRole?>((ref) => ref.watch(authProvider).user?.role);

/// The [TalentModel] linked to the current user, or `null` if they aren't a
/// talent (or aren't signed in).
final currentTalentProvider = Provider<TalentModel?>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null || user.role != UserRole.talent) return null;
  return ref.watch(talentByUserIdProvider(user.id));
});

/// The [RecruiterModel] linked to the current user, or `null` if they
/// aren't a recruiter (or aren't signed in).
final currentRecruiterProvider = Provider<RecruiterModel?>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null || user.role != UserRole.recruiter) return null;
  return ref.watch(recruiterByUserIdProvider(user.id));
});
