/// Central catalogue of every route path in KAST-ROLZ. Screens and the
/// router both import this file so a path never needs to be retyped (and
/// therefore never drifts) across the app.
library;

abstract final class RouteNames {
  // ---------------------------------------------------------------------
  // Auth / onboarding
  // ---------------------------------------------------------------------
  static const splash = '/splash';
  static const language = '/language';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const otp = '/otp';
  static const chooseRole = '/choose-role';

  // ---------------------------------------------------------------------
  // Talent shell tabs
  // ---------------------------------------------------------------------
  static const home = '/home';
  static const discover = '/discover';
  static const castings = '/castings';

  // ---------------------------------------------------------------------
  // Recruiter shell tabs
  // ---------------------------------------------------------------------
  static const dashboard = '/dashboard';
  static const search = '/search';
  static const postCasting = '/post-casting';

  // ---------------------------------------------------------------------
  // Shared shell tabs
  // ---------------------------------------------------------------------
  static const messages = '/messages';
  static const profile = '/profile';

  // ---------------------------------------------------------------------
  // Extra / detail routes
  // ---------------------------------------------------------------------
  static const talentDetail = '/talent/:id';
  static const castingDetail = '/casting/:id';
  static const agencyDetail = '/agency/:id';
  static const chat = '/chat/:id';
  static const notifications = '/notifications';
  static const favorites = '/favorites';
  static const settings = '/settings';
  static const pricing = '/pricing';
  static const about = '/about';
  static const contact = '/contact';
  static const terms = '/terms';
  static const privacy = '/privacy';
  static const admin = '/admin';
  static const adminUsers = '/admin/users';
  static const adminCastings = '/admin/castings';
  static const adminReports = '/admin/reports';
  static const adminVerification = '/admin/verification';
  static const editProfile = '/edit-profile';
  static const editCasting = '/edit-casting/:id';
  static const applicants = '/applicants/:castingId';

  static String talentDetailPath(String id) => '/talent/$id';
  static String castingDetailPath(String id) => '/casting/$id';
  static String agencyDetailPath(String id) => '/agency/$id';
  static String chatPath(String id) => '/chat/$id';
  static String editCastingPath(String id) => '/edit-casting/$id';
  static String applicantsPath(String castingId) => '/applicants/$castingId';
}
