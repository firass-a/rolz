/// GoRouter configuration for KAST-ROLZ: every top-level route, the
/// role-aware bottom-nav shell, and the auth/onboarding/role redirect
/// guards that keep users on the right screen as their session changes.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/presentation/admin_castings_screen.dart';
import '../../features/admin/presentation/admin_dashboard_screen.dart';
import '../../features/admin/presentation/admin_reports_screen.dart';
import '../../features/admin/presentation/admin_users_screen.dart';
import '../../features/admin/presentation/admin_verification_screen.dart';
import '../../features/authentication/presentation/choose_role_screen.dart';
import '../../features/authentication/presentation/forgot_password_screen.dart';
import '../../features/authentication/presentation/language_select_screen.dart';
import '../../features/authentication/presentation/login_screen.dart';
import '../../features/authentication/presentation/onboarding_screen.dart';
import '../../features/authentication/presentation/otp_screen.dart';
import '../../features/authentication/presentation/register_screen.dart';
import '../../features/authentication/presentation/splash_screen.dart';
import '../../features/casting/presentation/applicants_screen.dart';
import '../../features/casting/presentation/casting_detail_screen.dart';
import '../../features/casting/presentation/castings_list_screen.dart';
import '../../features/casting/presentation/edit_casting_screen.dart';
import '../../features/casting/presentation/post_casting_screen.dart';
import '../../features/discover/presentation/discover_screen.dart';
import '../../features/favorites/presentation/favorites_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/home/presentation/recruiter_dashboard_screen.dart';
import '../../features/home/presentation/shell_screen.dart';
import '../../features/messages/presentation/chat_screen.dart';
import '../../features/messages/presentation/conversations_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/info/presentation/about_screen.dart';
import '../../features/info/presentation/contact_screen.dart';
import '../../features/info/presentation/privacy_screen.dart';
import '../../features/info/presentation/terms_screen.dart';
import '../../features/pricing/presentation/pricing_screen.dart';
import '../../features/profile/presentation/agency_detail_screen.dart';
import '../../features/profile/presentation/edit_profile_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/profile/presentation/talent_detail_screen.dart';
import '../../features/search/presentation/find_talent_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../shared/models/models.dart';
import '../../shared/providers/providers.dart';
import 'route_names.dart';

/// Bridges Riverpod auth + settings to go_router's [Listenable]-based
/// `refreshListenable`, so language choice and auth changes re-run redirects.
class _AuthRefreshListenable extends ChangeNotifier {
  _AuthRefreshListenable(this._ref) {
    _authSub = _ref.listen<AuthState>(
      authProvider,
      (previous, next) => notifyListeners(),
      fireImmediately: false,
    );
    _settingsSub = _ref.listen<SettingsState>(
      settingsProvider,
      (previous, next) => notifyListeners(),
      fireImmediately: false,
    );
  }

  final Ref _ref;
  late final ProviderSubscription<AuthState> _authSub;
  late final ProviderSubscription<SettingsState> _settingsSub;

  @override
  void dispose() {
    _authSub.close();
    _settingsSub.close();
    super.dispose();
  }
}

UserRole? _roleOf(AuthState auth) {
  if (auth.isGuest) return UserRole.guest;
  return auth.user?.role;
}

String _homeFor(UserRole? role) => role == UserRole.recruiter ? RouteNames.dashboard : RouteNames.home;

const _preAuthPaths = {
  RouteNames.onboarding,
  RouteNames.login,
  RouteNames.register,
  RouteNames.forgotPassword,
  RouteNames.otp,
  RouteNames.chooseRole,
};

const _talentOnlyTabs = {RouteNames.home, RouteNames.discover, RouteNames.castings};
const _recruiterOnlyTabs = {RouteNames.dashboard, RouteNames.search, RouteNames.postCasting};

const _guestRestrictedPrefixes = [
  RouteNames.postCasting,
  RouteNames.admin,
  RouteNames.editProfile,
  '/edit-casting',
  '/applicants',
];

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshListenable = _AuthRefreshListenable(ref);
  ref.onDispose(refreshListenable.dispose);

  return GoRouter(
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: false,
    refreshListenable: refreshListenable,
    redirect: (context, state) => _redirect(ref, state),
    routes: [
      GoRoute(path: RouteNames.language, builder: (context, state) => const LanguageSelectScreen()),
      GoRoute(path: RouteNames.splash, builder: (context, state) => const SplashScreen()),
      GoRoute(path: RouteNames.onboarding, builder: (context, state) => const OnboardingScreen()),
      GoRoute(path: RouteNames.login, builder: (context, state) => const LoginScreen()),
      GoRoute(path: RouteNames.register, builder: (context, state) => const RegisterScreen()),
      GoRoute(
        path: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(path: RouteNames.otp, builder: (context, state) => const OtpScreen()),
      GoRoute(
        path: RouteNames.chooseRole,
        builder: (context, state) => ChooseRoleScreen(draft: state.extra as RegisterDraft?),
      ),

      // ---------------------------------------------------------------
      // Main app shell — a single StatefulShellRoute whose branches cover
      // both the talent and recruiter tab sets. ShellScreen decides which
      // subset of branches to surface based on the signed-in role.
      // ---------------------------------------------------------------
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => ShellScreen(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: RouteNames.home, builder: (context, state) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: RouteNames.discover, builder: (context, state) => const DiscoverScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: RouteNames.castings, builder: (context, state) => const CastingsListScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: RouteNames.dashboard,
              builder: (context, state) => const RecruiterDashboardScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: RouteNames.search,
              builder: (context, state) => const FindTalentScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: RouteNames.postCasting, builder: (context, state) => const PostCastingScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: RouteNames.messages, builder: (context, state) => const ConversationsScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: RouteNames.profile, builder: (context, state) => const ProfileScreen()),
          ]),
        ],
      ),

      // ---------------------------------------------------------------
      // Extra / detail routes
      // ---------------------------------------------------------------
      GoRoute(
        path: RouteNames.talentDetail,
        builder: (context, state) => TalentDetailScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: RouteNames.castingDetail,
        builder: (context, state) => CastingDetailScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: RouteNames.agencyDetail,
        builder: (context, state) => AgencyDetailScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: RouteNames.chat,
        builder: (context, state) => ChatScreen(conversationId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: RouteNames.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(path: RouteNames.favorites, builder: (context, state) => const FavoritesScreen()),
      GoRoute(path: RouteNames.settings, builder: (context, state) => const SettingsScreen()),
      GoRoute(path: RouteNames.pricing, builder: (context, state) => const PricingScreen()),
      GoRoute(path: RouteNames.about, builder: (context, state) => const AboutScreen()),
      GoRoute(path: RouteNames.contact, builder: (context, state) => const ContactScreen()),
      GoRoute(path: RouteNames.terms, builder: (context, state) => const TermsScreen()),
      GoRoute(path: RouteNames.privacy, builder: (context, state) => const PrivacyScreen()),
      GoRoute(path: RouteNames.admin, builder: (context, state) => const AdminDashboardScreen()),
      GoRoute(path: RouteNames.adminUsers, builder: (context, state) => const AdminUsersScreen()),
      GoRoute(path: RouteNames.adminCastings, builder: (context, state) => const AdminCastingsScreen()),
      GoRoute(path: RouteNames.adminReports, builder: (context, state) => const AdminReportsScreen()),
      GoRoute(path: RouteNames.adminVerification, builder: (context, state) => const AdminVerificationScreen()),
      GoRoute(
        path: RouteNames.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.editCasting,
        builder: (context, state) => EditCastingScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: RouteNames.applicants,
        builder: (context, state) => ApplicantsScreen(castingId: state.pathParameters['castingId']!),
      ),
    ],
  );
});

String? _redirect(Ref ref, GoRouterState state) {
  final auth = ref.read(authProvider);
  final settings = ref.read(settingsProvider);
  final loc = state.matchedLocation;
  final isAuthed = auth.isAuthenticated || auth.isGuest;
  final role = _roleOf(auth);

  // Wait until prefs are loaded before deciding language gate.
  if (!settings.hydrated) {
    // Hold on splash (or language) until SharedPreferences hydrate.
    return (loc == RouteNames.splash || loc == RouteNames.language) ? null : RouteNames.splash;
  }

  // Language must be chosen before anything else.
  if (!settings.hasChosenLanguage) {
    return loc == RouteNames.language ? null : RouteNames.language;
  }

  if (loc == RouteNames.language) {
    return RouteNames.splash;
  }

  // The splash screen owns its own timing/animation and decides when to
  // hand off — never redirect away from it automatically.
  if (loc == RouteNames.splash) return null;

  // Brand-new, unauthenticated sessions must see onboarding first.
  if (!auth.hasCompletedOnboarding && !isAuthed) {
    return loc == RouteNames.onboarding ? null : RouteNames.onboarding;
  }

  if (!isAuthed) {
    return _preAuthPaths.contains(loc) ? null : RouteNames.login;
  }

  // From here on, the user is authenticated or browsing as a guest.
  if (_preAuthPaths.contains(loc)) {
    return _homeFor(role);
  }

  if (auth.isGuest && _guestRestrictedPrefixes.any((p) => loc.startsWith(p))) {
    return _homeFor(role);
  }

  if (role == UserRole.recruiter && _talentOnlyTabs.contains(loc)) {
    return RouteNames.dashboard;
  }

  if (role != UserRole.recruiter && _recruiterOnlyTabs.contains(loc)) {
    return _homeFor(role);
  }

  if (loc.startsWith(RouteNames.admin) && role != UserRole.admin) {
    return _homeFor(role);
  }

  return null;
}
