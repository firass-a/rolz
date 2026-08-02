/// Centralised bilingual (English / Arabic) copy for KAST-ROLZ.
///
/// Every UI string resolves through [LocaleController.isArabic].
/// Brand name **KAST-ROLZ**, emails, and demo credentials stay untranslated.
/// Numbers always use Latin digits (1, 2, 3) even in Arabic strings.
library;

import '../l10n/locale_controller.dart';

abstract final class AppStrings {
  // ── Brand ──────────────────────────────────────────────────────────────
  static String get appName => 'KAST-ROLZ';
  static String get appTagline => LocaleController.isArabic
      ? 'حيث تلتقي الموهبة بالفرصة'
      : 'Where Talent Meets Opportunity';
  static String get appTaglineFr => LocaleController.isArabic
      ? 'موعد الموهبة والدور'
      : 'Le rendez-vous du talent et du rôle';
  static String get appSubtitle => LocaleController.isArabic
      ? 'كاستينغ فاخر للجزائر ومنطقة الشرق الأوسط وشمال أفريقيا'
      : 'Premium casting for Algeria & MENA';

  // ── Onboarding ─────────────────────────────────────────────────────────
  static String get onboardTitle1 =>
      LocaleController.isArabic ? 'خشبتك بانتظارك' : 'Your Stage Awaits';
  static String get onboardBody1 => LocaleController.isArabic
      ? 'اكتشف إعلانات كاستينغ فاخرة من أفضل الوكالات والعلامات التجارية والإنتاجات في المنطقة.'
      : 'Discover premium casting calls from top agencies, brands and productions across the region.';
  static String get onboardTitle2 =>
      LocaleController.isArabic ? 'اُكتشف' : 'Get Discovered';
  static String get onboardBody2 => LocaleController.isArabic
      ? 'ابنِ ملفاً سينمائياً، اعرض أعمالك، ودع مسؤولي الكاستينغ يأتون إليك.'
      : 'Build a cinematic profile, showcase your portfolio and let recruiters come to you.';
  static String get onboardTitle3 =>
      LocaleController.isArabic ? 'اختَر بثقة' : 'Cast With Confidence';
  static String get onboardBody3 => LocaleController.isArabic
      ? 'مواهب موثّقة، طلبات سلسة، ومراسلة — كل ذلك في مكان واحد أنيق.'
      : 'Verified talent, seamless applications, and messaging — all in one elegant place.';

  // ── Language screen ────────────────────────────────────────────────────
  static String get chooseLanguageTitle =>
      LocaleController.isArabic ? 'اختر لغتك' : 'Choose your language';
  static String get chooseLanguageSubtitle => LocaleController.isArabic
      ? 'يمكنك تغييرها لاحقاً من الملف الشخصي. ستُطلب منك مجدداً عند إعادة فتح التطبيق.'
      : 'You can change this later in Profile. You\'ll be asked again next time you open the app.';
  static String get languageEnglish => 'English';
  static String get languageArabic => 'العربية';
  static String get continueLabel =>
      LocaleController.isArabic ? 'متابعة' : 'Continue';

  // ── Auth ───────────────────────────────────────────────────────────────
  static String get login =>
      LocaleController.isArabic ? 'تسجيل الدخول' : 'Sign In';
  static String get register =>
      LocaleController.isArabic ? 'إنشاء حساب' : 'Create Account';
  static String get logout =>
      LocaleController.isArabic ? 'تسجيل الخروج' : 'Log Out';
  static String get email =>
      LocaleController.isArabic ? 'البريد الإلكتروني' : 'Email';
  static String get password =>
      LocaleController.isArabic ? 'كلمة المرور' : 'Password';
  static String get confirmPassword =>
      LocaleController.isArabic ? 'تأكيد كلمة المرور' : 'Confirm Password';
  static String get forgotPassword =>
      LocaleController.isArabic ? 'نسيت كلمة المرور؟' : 'Forgot Password?';
  static String get dontHaveAccount => LocaleController.isArabic
      ? 'ليس لديك حساب؟'
      : "Don't have an account?";
  static String get alreadyHaveAccount => LocaleController.isArabic
      ? 'لديك حساب بالفعل؟'
      : 'Already have an account?';
  static String get continueAsGuest =>
      LocaleController.isArabic ? 'المتابعة كزائر' : 'Continue as Guest';
  static String get chooseRole => LocaleController.isArabic
      ? 'كيف ستستخدم KAST-ROLZ؟'
      : 'How will you use KAST-ROLZ?';
  static String get roleTalent =>
      LocaleController.isArabic ? 'أنا موهبة' : "I'm Talent";
  static String get roleTalentSubtitle => LocaleController.isArabic
      ? 'ممثل، عارضة أزياء، راقص والمزيد'
      : 'Actor, model, dancer & more';
  static String get roleRecruiter =>
      LocaleController.isArabic ? 'أنا مسؤول كاستينغ' : "I'm Casting";
  static String get roleRecruiterSubtitle => LocaleController.isArabic
      ? 'وكالة، علامة تجارية، مخرج والمزيد'
      : 'Agency, brand, director & more';

  /// Demo credentials hint shown on the login screen for reviewers/testers.
  static String get demoCredentialsTitle =>
      LocaleController.isArabic ? 'وصول تجريبي' : 'Demo Access';
  static String get demoTalentHint => 'talent@kastrolz.com · demo123';
  static String get demoRecruiterHint => 'recruiter@kastrolz.com · demo123';
  static String get demoAdminHint => 'admin@kastrolz.com · demo123';

  static String get welcomeBack =>
      LocaleController.isArabic ? 'مرحباً بعودتك' : 'Welcome Back';
  static String get signInContinue => LocaleController.isArabic
      ? 'سجّل الدخول لمتابعة رحلتك في الكاستينغ.'
      : 'Sign in to continue your casting journey.';
  static String get orTryDemo => LocaleController.isArabic
      ? 'أو جرّب حساباً تجريبياً'
      : 'or try a demo account';
  static String get demoTalent =>
      LocaleController.isArabic ? 'موهبة' : 'Talent';
  static String get demoRecruiter =>
      LocaleController.isArabic ? 'مسؤول كاستينغ' : 'Recruiter';
  static String get demoAdmin =>
      LocaleController.isArabic ? 'مسؤول' : 'Admin';
  static String get createAccount =>
      LocaleController.isArabic ? 'إنشاء حساب' : 'Create Account';
  static String get joinKastRolz => LocaleController.isArabic
      ? 'انضم إلى KAST-ROLZ وابدأ فصلك الجديد.'
      : 'Join KAST-ROLZ and start your next chapter.';
  static String get fullName =>
      LocaleController.isArabic ? 'الاسم الكامل' : 'Full Name';
  static String get enterName =>
      LocaleController.isArabic ? 'أدخل اسمك' : 'Enter your name';
  static String get enterEmail => LocaleController.isArabic
      ? 'أدخل بريدك الإلكتروني'
      : 'Enter your email';
  static String get enterValidEmail => LocaleController.isArabic
      ? 'أدخل بريداً إلكترونياً صالحاً'
      : 'Enter a valid email';
  static String get enterPassword => LocaleController.isArabic
      ? 'أدخل كلمة المرور'
      : 'Enter your password';
  static String get minPassword => LocaleController.isArabic
      ? '6 أحرف على الأقل'
      : 'Minimum 6 characters';
  static String get atLeast6Characters => LocaleController.isArabic
      ? '6 أحرف على الأقل'
      : 'At least 6 characters';
  static String get confirmYourPassword => LocaleController.isArabic
      ? 'أكّد كلمة المرور'
      : 'Confirm your password';
  static String get reenterPassword => LocaleController.isArabic
      ? 'أعد إدخال كلمة المرور'
      : 'Re-enter your password';
  static String get passwordsDoNotMatch => LocaleController.isArabic
      ? 'كلمتا المرور غير متطابقتين'
      : 'Passwords do not match';
  static String get justBrowsing =>
      LocaleController.isArabic ? 'تصفّح فقط' : 'Just Browsing';
  static String get exploreLimited => LocaleController.isArabic
      ? 'استكشف KAST-ROLZ بوصول محدود'
      : 'Explore KAST-ROLZ with limited access';
  static String get changeRoleLater => LocaleController.isArabic
      ? 'يمكنك تغيير ذلك لاحقاً من ملفك الشخصي.'
      : 'You can always change this later from your profile.';
  static String get pleaseCreateAccount => LocaleController.isArabic
      ? 'يرجى إنشاء حساب أولاً.'
      : 'Please create an account first.';
  static String get invalidCredentials => LocaleController.isArabic
      ? 'البريد الإلكتروني أو كلمة المرور غير صحيحة.'
      : 'Invalid email or password.';
  static String get emailExists => LocaleController.isArabic
      ? 'يوجد حساب بهذا البريد الإلكتروني مسبقاً.'
      : 'An account with this email already exists.';
  static String get forgotPasswordBody => LocaleController.isArabic
      ? 'أدخل بريدك وسنرسل لك رابط إعادة التعيين.'
      : "Enter your email and we'll send you a reset link.";
  static String get forgotPasswordBodyLong => LocaleController.isArabic
      ? 'أدخل البريد المرتبط بحسابك وسنرسل لك رابط إعادة التعيين.'
      : "Enter the email linked to your account and we'll send you a reset link.";
  static String get sendResetLink => LocaleController.isArabic
      ? 'إرسال رابط إعادة التعيين'
      : 'Send Reset Link';
  static String get checkYourEmail =>
      LocaleController.isArabic ? 'تحقق من بريدك' : 'Check Your Email';
  static String resetEmailSent(String email) => LocaleController.isArabic
      ? 'إذا وُجد حساب لـ\n$email، فسيصل رابط إعادة التعيين قريباً.'
      : 'If an account exists for\n$email, a reset link is on its way.';
  static String get backToSignIn =>
      LocaleController.isArabic ? 'العودة لتسجيل الدخول' : 'Back to Sign In';
  static String get verifyYourCode =>
      LocaleController.isArabic ? 'تحقق من الرمز' : 'Verify Your Code';
  static String get verifyCodeBody => LocaleController.isArabic
      ? 'أدخل الرمز المكوّن من 6 أرقام الذي أرسلناه إليك.'
      : 'Enter the 6-digit code we sent you.';
  static String get enterFullCode => LocaleController.isArabic
      ? 'أدخل الرمز المكوّن من 6 أرقام بالكامل.'
      : 'Enter the full 6-digit code.';
  static String get invalidOtp => LocaleController.isArabic
      ? 'هذا الرمز غير صالح. حاول مرة أخرى.'
      : "That code didn't work. Please try again.";
  static String get didntGetCodeResend => LocaleController.isArabic
      ? 'لم يصلك الرمز؟ إعادة الإرسال'
      : "Didn't get a code? Resend";
  static String get identityConfirmed => LocaleController.isArabic
      ? 'تم تأكيد هويتك.'
      : 'Your identity has been confirmed.';
  static String get verify =>
      LocaleController.isArabic ? 'تحقق' : 'Verify';
  static String get resend =>
      LocaleController.isArabic ? 'إعادة الإرسال' : 'Resend';
  static String get verified =>
      LocaleController.isArabic ? 'تم التحقق!' : 'Verified!';
  static String get exitGuestMode =>
      LocaleController.isArabic ? 'الخروج من وضع الزائر' : 'Exit Guest Mode';
  static String get browsingAsGuest => LocaleController.isArabic
      ? 'أنت تتصفّح كزائر'
      : "You're Browsing as Guest";
  static String get guestCtaBody => LocaleController.isArabic
      ? 'أنشئ حساباً مجانياً لبناء ملفك، والتقدّم للكاستينغ، ومراسلة مسؤولي الكاستينغ.'
      : 'Create a free account to build your profile, apply to castings and message recruiters.';

  // ── Navigation ─────────────────────────────────────────────────────────
  static String get navHome =>
      LocaleController.isArabic ? 'الرئيسية' : 'Home';
  static String get navDiscover =>
      LocaleController.isArabic ? 'اكتشف' : 'Discover';
  static String get navCasting =>
      LocaleController.isArabic ? 'الكاستينغ' : 'Casting';
  static String get navCastings =>
      LocaleController.isArabic ? 'الكاستينغ' : 'Castings';
  static String get navMessages =>
      LocaleController.isArabic ? 'الرسائل' : 'Messages';
  static String get navProfile =>
      LocaleController.isArabic ? 'الملف' : 'Profile';
  static String get navDashboard =>
      LocaleController.isArabic ? 'لوحة التحكم' : 'Dashboard';
  static String get navTalent =>
      LocaleController.isArabic ? 'المواهب' : 'Talent';
  static String get navPost =>
      LocaleController.isArabic ? 'نشر' : 'Post';
  static String get navOverview =>
      LocaleController.isArabic ? 'نظرة عامة' : 'Overview';
  static String get navUsers =>
      LocaleController.isArabic ? 'المستخدمون' : 'Users';
  static String get navSearch =>
      LocaleController.isArabic ? 'بحث' : 'Search';

  // ── Common actions ─────────────────────────────────────────────────────
  static String get seeAll =>
      LocaleController.isArabic ? 'عرض الكل' : 'See All';
  static String get viewAll =>
      LocaleController.isArabic ? 'عرض الكل' : 'View All';
  static String get apply =>
      LocaleController.isArabic ? 'قدّم الآن' : 'Apply Now';
  static String get applied =>
      LocaleController.isArabic ? 'تم التقديم' : 'Applied';
  static String get save =>
      LocaleController.isArabic ? 'حفظ' : 'Save';
  static String get saved =>
      LocaleController.isArabic ? 'محفوظ' : 'Saved';
  static String get share =>
      LocaleController.isArabic ? 'مشاركة' : 'Share';
  static String get follow =>
      LocaleController.isArabic ? 'متابعة' : 'Follow';
  static String get following =>
      LocaleController.isArabic ? 'تتم المتابعة' : 'Following';
  static String get message =>
      LocaleController.isArabic ? 'رسالة' : 'Message';
  static String get cancel =>
      LocaleController.isArabic ? 'إلغاء' : 'Cancel';
  static String get confirm =>
      LocaleController.isArabic ? 'تأكيد' : 'Confirm';
  static String get delete =>
      LocaleController.isArabic ? 'حذف' : 'Delete';
  static String get edit =>
      LocaleController.isArabic ? 'تعديل' : 'Edit';
  static String get retry =>
      LocaleController.isArabic ? 'حاول مجدداً' : 'Try Again';
  static String get done =>
      LocaleController.isArabic ? 'تم' : 'Done';
  static String get next =>
      LocaleController.isArabic ? 'التالي' : 'Next';
  static String get skip =>
      LocaleController.isArabic ? 'تخطي' : 'Skip';
  static String get getStarted =>
      LocaleController.isArabic ? 'ابدأ الآن' : 'Get Started';
  static String get search =>
      LocaleController.isArabic ? 'بحث' : 'Search';
  static String get searchHint => LocaleController.isArabic
      ? 'ابحث عن مواهب، كاستينغ، وكالات…'
      : 'Search talent, castings, agencies…';
  static String get filters =>
      LocaleController.isArabic ? 'الفلاتر' : 'Filters';
  static String get clearAll =>
      LocaleController.isArabic ? 'مسح الكل' : 'Clear All';
  static String get applyFilters =>
      LocaleController.isArabic ? 'تطبيق الفلاتر' : 'Apply Filters';
  static String get close =>
      LocaleController.isArabic ? 'إغلاق' : 'Close';
  static String get view =>
      LocaleController.isArabic ? 'عرض' : 'View';
  static String get report =>
      LocaleController.isArabic ? 'إبلاغ' : 'Report';
  static String get accept =>
      LocaleController.isArabic ? 'قبول' : 'Accept';
  static String get reject =>
      LocaleController.isArabic ? 'رفض' : 'Reject';
  static String get shortlist =>
      LocaleController.isArabic ? 'قائمة مختصرة' : 'Shortlist';
  static String get duplicate =>
      LocaleController.isArabic ? 'نسخ' : 'Duplicate';
  static String get archive =>
      LocaleController.isArabic ? 'أرشفة' : 'Archive';
  static String get restore =>
      LocaleController.isArabic ? 'استعادة' : 'Restore';
  static String get approve =>
      LocaleController.isArabic ? 'موافقة' : 'Approve';
  static String get dismiss =>
      LocaleController.isArabic ? 'تجاهل' : 'Dismiss';
  static String get resolve =>
      LocaleController.isArabic ? 'حل' : 'Resolve';
  static String get reopen =>
      LocaleController.isArabic ? 'إعادة فتح' : 'Reopen';
  static String get ban =>
      LocaleController.isArabic ? 'حظر' : 'Ban';
  static String get unban =>
      LocaleController.isArabic ? 'إلغاء الحظر' : 'Unban';
  static String get feature =>
      LocaleController.isArabic ? 'تمييز' : 'Feature';
  static String get unfeature =>
      LocaleController.isArabic ? 'إلغاء التمييز' : 'Unfeature';
  static String get unverify =>
      LocaleController.isArabic ? 'إلغاء التوثيق' : 'Unverify';
  static String get submitReport =>
      LocaleController.isArabic ? 'إرسال البلاغ' : 'Submit Report';
  static String get markAllRead =>
      LocaleController.isArabic ? 'تعليم الكل كمقروء' : 'Mark all read';
  static String get any =>
      LocaleController.isArabic ? 'الكل' : 'Any';
  static String get all =>
      LocaleController.isArabic ? 'الكل' : 'All';
  static String get required =>
      LocaleController.isArabic ? 'مطلوب' : 'Required';
  static String get saveChanges =>
      LocaleController.isArabic ? 'حفظ التغييرات' : 'Save Changes';
  static String get welcomeBackComma =>
      LocaleController.isArabic ? 'مرحباً بعودتك،' : 'Welcome back,';
  static String get guest =>
      LocaleController.isArabic ? 'زائر' : 'Guest';
  static String get there =>
      LocaleController.isArabic ? 'هناك' : 'there';
  static String get results =>
      LocaleController.isArabic ? 'نتيجة' : 'results';
  static String get result =>
      LocaleController.isArabic ? 'نتيجة' : 'result';
  static String get found =>
      LocaleController.isArabic ? 'موجود' : 'found';
  static String get clearHeight =>
      LocaleController.isArabic ? 'مسح الطول' : 'Clear height';
  static String get negotiable =>
      LocaleController.isArabic ? 'قابل للتفاوض' : 'Negotiable';
  static String get online =>
      LocaleController.isArabic ? 'متصل' : 'Online';
  static String get offline =>
      LocaleController.isArabic ? 'غير متصل' : 'Offline';
  static String get typing =>
      LocaleController.isArabic ? 'يكتب…' : 'Typing…';
  static String get today =>
      LocaleController.isArabic ? 'اليوم' : 'Today';
  static String get yesterday =>
      LocaleController.isArabic ? 'أمس' : 'Yesterday';
  static String get photo =>
      LocaleController.isArabic ? 'صورة' : 'Photo';
  static String get contact =>
      LocaleController.isArabic ? 'تواصل' : 'Contact';
  static String get age =>
      LocaleController.isArabic ? 'العمر' : 'Age';
  static String get weight =>
      LocaleController.isArabic ? 'الوزن' : 'Weight';
  static String get eyes =>
      LocaleController.isArabic ? 'العينان' : 'Eyes';
  static String get hair =>
      LocaleController.isArabic ? 'الشعر' : 'Hair';
  static String get level =>
      LocaleController.isArabic ? 'المستوى' : 'Level';
  static String get phone =>
      LocaleController.isArabic ? 'الهاتف' : 'Phone';
  static String get bio =>
      LocaleController.isArabic ? 'نبذة' : 'Bio';
  static String get firstName =>
      LocaleController.isArabic ? 'الاسم الأول' : 'First Name';
  static String get lastName =>
      LocaleController.isArabic ? 'اسم العائلة' : 'Last Name';
  static String get company =>
      LocaleController.isArabic ? 'الشركة' : 'Company';
  static String get companyName =>
      LocaleController.isArabic ? 'اسم الشركة' : 'Company Name';
  static String get status =>
      LocaleController.isArabic ? 'الحالة' : 'Status';
  static String get role =>
      LocaleController.isArabic ? 'الدور' : 'Role';
  static String get type =>
      LocaleController.isArabic ? 'النوع' : 'Type';
  static String get joined =>
      LocaleController.isArabic ? 'انضم' : 'Joined';
  static String get lastSeen =>
      LocaleController.isArabic ? 'آخر ظهور' : 'Last Seen';
  static String get since =>
      LocaleController.isArabic ? 'منذ' : 'Since';
  static String get specialties =>
      LocaleController.isArabic ? 'التخصصات' : 'Specialties';
  static String get rating =>
      LocaleController.isArabic ? 'التقييم' : 'Rating';
  static String get views =>
      LocaleController.isArabic ? 'المشاهدات' : 'Views';
  static String get yrsExp =>
      LocaleController.isArabic ? 'سنوات خبرة' : 'Yrs Exp.';
  static String get castings =>
      LocaleController.isArabic ? 'الكاستينغ' : 'Castings';
  static String get hires =>
      LocaleController.isArabic ? 'التوظيف' : 'Hires';
  static String get talents =>
      LocaleController.isArabic ? 'المواهب' : 'Talents';
  static String get agencies =>
      LocaleController.isArabic ? 'الوكالات' : 'Agencies';
  static String get total =>
      LocaleController.isArabic ? 'الإجمالي' : 'total';
  static String get optional =>
      LocaleController.isArabic ? 'اختياري' : 'optional';
  static String get pending =>
      LocaleController.isArabic ? 'قيد الانتظار' : 'Pending';
  static String get unknown =>
      LocaleController.isArabic ? 'غير معروف' : 'Unknown';
  static String get notSpecified =>
      LocaleController.isArabic ? 'غير محدد.' : 'Not specified.';

  // ── Search hints ───────────────────────────────────────────────────────
  static String get searchTalents =>
      LocaleController.isArabic ? 'ابحث عن مواهب' : 'Search talents';
  static String get searchCastings =>
      LocaleController.isArabic ? 'ابحث في الكاستينغ…' : 'Search castings…';
  static String get searchConversations => LocaleController.isArabic
      ? 'ابحث في المحادثات…'
      : 'Search conversations…';
  static String get searchInConversation => LocaleController.isArabic
      ? 'ابحث في المحادثة…'
      : 'Search in conversation…';
  static String get searchUsers =>
      LocaleController.isArabic ? 'ابحث عن مستخدمين…' : 'Search users…';
  static String get searchUsersHint => LocaleController.isArabic
      ? 'ابحث بالاسم أو البريد أو الشركة…'
      : 'Search by name, email or company…';
  static String get searchCastingsAdmin => LocaleController.isArabic
      ? 'ابحث في الكاستينغ بالعنوان أو الدور أو المدينة…'
      : 'Search castings by title, role or city…';
  static String get searchTalentsCastingsAgencies => LocaleController.isArabic
      ? 'ابحث عن مواهب، كاستينغ، وكالات…'
      : 'Search talents, castings, agencies…';
  static String get searchKastRolz =>
      LocaleController.isArabic ? 'ابحث في KAST-ROLZ' : 'Search KAST-ROLZ';
  static String get searchKastRolzSubtitle => LocaleController.isArabic
      ? 'اعثر على المواهب والكاستينغ ومسؤولي الكاستينغ والوكالات في مكان واحد.'
      : 'Find talents, castings, recruiters and agencies in one place.';
  static String get messageHint =>
      LocaleController.isArabic ? 'رسالة…' : 'Message…';
  static String get sayHello =>
      LocaleController.isArabic ? 'قل مرحباً' : 'Say hello';
  static String get sayHelloTitle =>
      LocaleController.isArabic ? 'قل مرحباً!' : 'Say Hello!';
  static String sayHelloSubtitle(String name) => LocaleController.isArabic
      ? 'أرسل أول رسالة إلى $name.'
      : 'Send your first message to $name.';
  static String get voiceRecorded => LocaleController.isArabic
      ? 'تم تسجيل الرسالة الصوتية'
      : 'Voice message recorded';
  static String get describeIssue => LocaleController.isArabic
      ? 'صف المشكلة…'
      : 'Describe the issue…';
  static String get reportBodyHint => LocaleController.isArabic
      ? 'أخبرنا بما هو خاطئ. يراجع فريق الإشراف كل بلاغ.'
      : "Tell us what's wrong. Our moderation team reviews every report.";

  // ── Empty / error states ───────────────────────────────────────────────
  static String get emptyGenericTitle =>
      LocaleController.isArabic ? 'لا شيء هنا بعد' : 'Nothing Here Yet';
  static String get emptyGenericSubtitle => LocaleController.isArabic
      ? 'بمجرد أن تبدأ الأمور بالتحرك، ستراها تظهر هنا.'
      : "Once things start moving, you'll see them appear right here.";
  static String get emptySearchTitle =>
      LocaleController.isArabic ? 'لا توجد نتائج' : 'No Results Found';
  static String get emptySearchSubtitle => LocaleController.isArabic
      ? 'حاول تعديل البحث أو الفلاتر للعثور على ما تبحث عنه.'
      : "Try adjusting your search or filters to find what you're looking for.";
  static String get emptyFavoritesTitle =>
      LocaleController.isArabic ? 'لا مفضّلات بعد' : 'No Favorites Yet';
  static String get emptyFavoritesSubtitle => LocaleController.isArabic
      ? 'اضغط على القلب عند الموهبة أو الكاستينغ أو الوكالة لحفظها هنا.'
      : 'Tap the heart on talent, castings or agencies to save them here.';
  static String get emptyMessagesTitle =>
      LocaleController.isArabic ? 'لا محادثات' : 'No Conversations';
  static String get emptyMessagesSubtitle => LocaleController.isArabic
      ? 'ابدأ محادثة من كاستينغ أو ملف موهبة.'
      : 'Start a conversation from a casting or talent profile.';
  static String get emptyNotificationsTitle =>
      LocaleController.isArabic ? 'أنت على اطّلاع' : 'All Caught Up';
  static String get emptyNotificationsSubtitle => LocaleController.isArabic
      ? 'لا توجد إشعارات جديدة حالياً.'
      : 'You have no new notifications for now.';
  static String get noTalentsMatchFilters => LocaleController.isArabic
      ? 'لا توجد مواهب مطابقة لفلاترك بعد. حاول توسيع البحث.'
      : 'No talents match your filters yet. Try widening the search.';
  static String get noCastingsYet =>
      LocaleController.isArabic ? 'لا يوجد كاستينغ بعد' : 'No Castings Yet';
  static String get postFirstCasting => LocaleController.isArabic
      ? 'انشر أول كاستينغ لتبدأ باستقبال الطلبات.'
      : 'Post your first casting to start receiving applications.';
  static String get noApplicantsYet =>
      LocaleController.isArabic ? 'لا متقدمين بعد' : 'No Applicants Yet';
  static String get noApplicantsSubtitle => LocaleController.isArabic
      ? 'بمجرد أن تتقدّم المواهب لهذا الكاستينغ، ستظهر هنا.'
      : "Once talents apply to this casting, they'll show up here.";
  static String get noUsersFound =>
      LocaleController.isArabic ? 'لا مستخدمين' : 'No Users Found';
  static String get noUsersFoundSubtitle => LocaleController.isArabic
      ? 'جرّب مصطلح بحث مختلفاً.'
      : 'Try a different search term.';
  static String get noReports =>
      LocaleController.isArabic ? 'لا بلاغات' : 'No Reports';
  static String get noReportsSubtitle => LocaleController.isArabic
      ? 'لا شيء للمراجعة في هذا الفلتر.'
      : 'Nothing to review for this filter.';
  static String get allCaughtUp =>
      LocaleController.isArabic ? 'أنت على اطّلاع' : 'All Caught Up';
  static String get noConversationsFound => LocaleController.isArabic
      ? 'لا محادثات موجودة'
      : 'No Conversations Found';
  static String get tryDifferentName => LocaleController.isArabic
      ? 'جرّب اسماً أو كلمة مفتاحية مختلفة.'
      : 'Try a different name or keyword.';
  static String get tryDifferentSearch => LocaleController.isArabic
      ? 'جرّب اسماً أو دوراً أو مدينة مختلفة.'
      : 'Try a different name, role or city.';
  static String get noCastingsFound =>
      LocaleController.isArabic ? 'لا كاستينغ موجود' : 'No Castings Found';
  static String get noCastingsFoundSubtitle => LocaleController.isArabic
      ? 'جرّب مصطلح بحث أو فلتر مختلف.'
      : 'Try a different search term or filter.';
  static String get noMessagesFound =>
      LocaleController.isArabic ? 'لا رسائل موجودة' : 'No Messages Found';
  static String get noTalentsYet =>
      LocaleController.isArabic ? 'لا مواهب بعد' : 'No Talents Yet';
  static String get noTalentsYetSubtitle => LocaleController.isArabic
      ? 'لم تُضف هذه الوكالة أي مواهب بعد.'
      : "This agency hasn't added any talents yet.";
  static String get noFeaturedTalentsYet => LocaleController.isArabic
      ? 'لا مواهب مميزة بعد.'
      : 'No featured talents yet.';
  static String get noFeaturedCastingsYet => LocaleController.isArabic
      ? 'لا كاستينغ مميز بعد.'
      : 'No featured castings yet.';
  static String get noCastingsYetShort =>
      LocaleController.isArabic ? 'لا كاستينغ بعد.' : 'No castings yet.';
  static String get noSkillsListed => LocaleController.isArabic
      ? 'لا مهارات مدرجة بعد.'
      : 'No skills listed yet.';
  static String get noLanguagesListed => LocaleController.isArabic
      ? 'لا لغات مدرجة بعد.'
      : 'No languages listed yet.';
  static String get noExperienceCredits => LocaleController.isArabic
      ? 'لا خبرات مضافة بعد.'
      : 'No experience credits added yet.';
  static String get noPortfolioImages => LocaleController.isArabic
      ? 'لا صور أعمال بعد.'
      : 'No portfolio images yet.';
  static String get noReviewsYet =>
      LocaleController.isArabic ? 'لا تقييمات بعد.' : 'No reviews yet.';
  static String get noBioYet => LocaleController.isArabic
      ? 'لم يكتب هذا الموهوب نبذة بعد.'
      : "This talent hasn't written a bio yet.";
  static String get noDescriptionProvided => LocaleController.isArabic
      ? 'لا وصف متوفر.'
      : 'No description provided.';
  static String get noTalentVerificationPending => LocaleController.isArabic
      ? 'لا طلبات توثيق مواهب معلّقة.'
      : 'No talent verification requests pending.';
  static String get noRecruiterVerificationPending => LocaleController.isArabic
      ? 'لا طلبات توثيق مسؤولي كاستينغ معلّقة.'
      : 'No recruiter verification requests pending.';
  static String get conversationNotFound => LocaleController.isArabic
      ? 'المحادثة غير موجودة'
      : 'Conversation Not Found';
  static String get conversationNotFoundSubtitle => LocaleController.isArabic
      ? 'قد تكون هذه المحادثة قد أُزيلت.'
      : 'This conversation may have been removed.';
  static String get talentNotFound =>
      LocaleController.isArabic ? 'الملف غير موجود' : 'Talent Not Found';
  static String get talentNotFoundSubtitle => LocaleController.isArabic
      ? 'قد يكون هذا الملف قد أُزيل أو أُرشف.'
      : 'This profile may have been removed or archived.';
  static String get agencyNotFound =>
      LocaleController.isArabic ? 'الوكالة غير موجودة' : 'Agency Not Found';
  static String get agencyNotFoundSubtitle => LocaleController.isArabic
      ? 'قد يكون ملف هذه الوكالة قد أُزيل.'
      : 'This agency profile may have been removed.';
  static String get castingNotFound =>
      LocaleController.isArabic ? 'الكاستينغ غير موجود' : 'Casting Not Found';
  static String get castingNotFoundSubtitle => LocaleController.isArabic
      ? 'قد يكون هذا الكاستينغ قد أُزيل أو أُغلق.'
      : 'This casting may have been removed or closed.';
  static String get notAuthorized =>
      LocaleController.isArabic ? 'غير مصرّح' : 'Not Authorized';
  static String get notAuthorizedEditCasting => LocaleController.isArabic
      ? 'يمكنك تعديل الكاستينغ الذي نشرته بنفسك فقط.'
      : "You can only edit castings you've posted yourself.";
  static String get signInRequired =>
      LocaleController.isArabic ? 'يلزم تسجيل الدخول' : 'Sign In Required';
  static String get signInRequiredProfile => LocaleController.isArabic
      ? 'أنشئ حساباً لبناء ملفك وتعديله.'
      : 'Create an account to build and edit your profile.';
  static String get signUpToMessage => LocaleController.isArabic
      ? 'سجّل للمراسلة'
      : 'Sign Up to Message';
  static String get signUpToMessageBody => LocaleController.isArabic
      ? 'أنشئ حساباً مجانياً لبدء محادثات مع المواهب ومسؤولي الكاستينغ.'
      : 'Create a free account to start conversations with talents and recruiters.';

  static String get errorGenericTitle =>
      LocaleController.isArabic ? 'حدث خطأ ما' : 'Something Went Wrong';
  static String get errorGenericSubtitle => LocaleController.isArabic
      ? 'واجهنا مشكلة في التحميل. يرجى المحاولة بعد لحظة.'
      : 'We hit a snag loading this. Please try again in a moment.';
  static String get errorConnectionTitle =>
      LocaleController.isArabic ? 'انقطع الاتصال' : 'Connection Lost';
  static String get errorConnectionSubtitle => LocaleController.isArabic
      ? 'تحقق من اتصالك بالإنترنت وحاول مجدداً.'
      : 'Check your internet connection and try again.';

  // ── Casting labels ─────────────────────────────────────────────────────
  static String get castingRole =>
      LocaleController.isArabic ? 'الدور' : 'Role';
  static String get castingLocation =>
      LocaleController.isArabic ? 'الموقع' : 'Location';
  static String get castingSalary =>
      LocaleController.isArabic ? 'الأجر' : 'Salary';
  static String get castingDeadline =>
      LocaleController.isArabic ? 'الموعد النهائي' : 'Deadline';
  static String get castingFeatured =>
      LocaleController.isArabic ? 'مميز' : 'Featured';
  static String get castingUrgent =>
      LocaleController.isArabic ? 'عاجل' : 'Urgent';
  static String get castingOpen =>
      LocaleController.isArabic ? 'مفتوح' : 'Open';
  static String get castingClosed =>
      LocaleController.isArabic ? 'مغلق' : 'Closed';
  static String get featured =>
      LocaleController.isArabic ? 'مميز' : 'Featured';
  static String get findTalent =>
      LocaleController.isArabic ? 'ابحث عن موهبة' : 'Find Talent';
  static String get postACasting =>
      LocaleController.isArabic ? 'انشر كاستينغ' : 'Post a Casting';
  static String get yourCastings =>
      LocaleController.isArabic ? 'كاستينغاتك' : 'Your Castings';
  static String get applicantsCount =>
      LocaleController.isArabic ? 'متقدمون' : 'applicants';
  static String get openCastings =>
      LocaleController.isArabic ? 'كاستينغ مفتوح' : 'Open Castings';
  static String get totalApplicants =>
      LocaleController.isArabic ? 'إجمالي المتقدمين' : 'Total Applicants';
  static String get pendingReview =>
      LocaleController.isArabic ? 'بانتظار المراجعة' : 'Pending Review';
  static String get successfulHires =>
      LocaleController.isArabic ? 'توظيف ناجح' : 'Successful Hires';
  static String get applications =>
      LocaleController.isArabic ? 'الطلبات' : 'Applications';
  static String get profileViews =>
      LocaleController.isArabic ? 'مشاهدات الملف' : 'Profile Views';
  static String get exploreCastings =>
      LocaleController.isArabic ? 'استكشف الكاستينغ' : 'Explore Castings';
  static String get applicants =>
      LocaleController.isArabic ? 'المتقدمون' : 'Applicants';
  static String get publishCasting =>
      LocaleController.isArabic ? 'نشر الكاستينغ' : 'Publish Casting';
  static String get castingTitle =>
      LocaleController.isArabic ? 'عنوان الكاستينغ' : 'Casting Title';
  static String get applicationDeadline => LocaleController.isArabic
      ? 'موعد انتهاء التقديم'
      : 'Application Deadline';
  static String get description =>
      LocaleController.isArabic ? 'الوصف' : 'Description';
  static String get requirements =>
      LocaleController.isArabic ? 'المتطلبات' : 'Requirements';
  static String get profileRequirements => LocaleController.isArabic
      ? 'متطلبات الملف'
      : 'Profile Requirements';
  static String get postedBy =>
      LocaleController.isArabic ? 'نُشر بواسطة' : 'Posted By';
  static String get similarCastings =>
      LocaleController.isArabic ? 'كاستينغ مشابه' : 'Similar Castings';
  static String get ageRange =>
      LocaleController.isArabic ? 'الفئة العمرية' : 'Age Range';
  static String get height =>
      LocaleController.isArabic ? 'الطول' : 'Height';
  static String get manageThisCasting => LocaleController.isArabic
      ? 'إدارة هذا الكاستينغ'
      : 'Manage This Casting';
  static String get viewApplicants =>
      LocaleController.isArabic ? 'عرض المتقدمين' : 'View Applicants';
  static String get viewProfile =>
      LocaleController.isArabic ? 'عرض الملف' : 'View Profile';
  static String get applicationsClosed => LocaleController.isArabic
      ? 'التقديم مغلق'
      : 'Applications Closed';
  static String get signInAsTalentToApply => LocaleController.isArabic
      ? 'سجّل كموهبة للتقديم'
      : 'Sign In as Talent to Apply';
  static String get editCasting =>
      LocaleController.isArabic ? 'تعديل الكاستينغ' : 'Edit Casting';
  static String get salaryOptional => LocaleController.isArabic
      ? 'الأجر (اختياري)'
      : 'Salary (optional)';
  static String get postCastingSubtitle => LocaleController.isArabic
      ? 'اوصل إلى آلاف المواهب الموثّقة في المنطقة.'
      : 'Reach thousands of verified talents across the region.';
  static String get editCastingSubtitle => LocaleController.isArabic
      ? 'حدّث التفاصيل أدناه — التغييرات تُنشر فوراً.'
      : 'Update the details below — changes go live immediately.';
  static String get castingDescriptionHint => LocaleController.isArabic
      ? 'صف الدور والمتطلبات وتفاصيل التصوير…'
      : 'Describe the role, requirements and shoot details…';
  static String get shootDates =>
      LocaleController.isArabic ? 'مواعيد التصوير' : 'Shoot dates';
  static String shootOn(String date) => LocaleController.isArabic
      ? 'تصوير $date'
      : 'Shoot $date';
  static String youApplied(String timeAgo) => LocaleController.isArabic
      ? 'قدّمت طلبك $timeAgo'
      : 'You applied $timeAgo';
  static String appliedAgo(String timeAgo) => LocaleController.isArabic
      ? 'قدّم $timeAgo'
      : 'Applied $timeAgo';

  // ── Talent ─────────────────────────────────────────────────────────────
  static String get talentVerified =>
      LocaleController.isArabic ? 'موثّق' : 'Verified';
  static String get talentRating =>
      LocaleController.isArabic ? 'التقييم' : 'Rating';
  static String get talentAvailable =>
      LocaleController.isArabic ? 'متاح' : 'Available';
  static String get talentPortfolio =>
      LocaleController.isArabic ? 'الأعمال' : 'Portfolio';
  static String get talentExperience =>
      LocaleController.isArabic ? 'الخبرة' : 'Experience';
  static String get talentProfile =>
      LocaleController.isArabic ? 'ملف الموهبة' : 'Talent Profile';
  static String get about =>
      LocaleController.isArabic ? 'نبذة' : 'About';
  static String get skills =>
      LocaleController.isArabic ? 'المهارات' : 'Skills';
  static String get languages =>
      LocaleController.isArabic ? 'اللغات' : 'Languages';
  static String get physical =>
      LocaleController.isArabic ? 'المواصفات' : 'Physical';
  static String get experience =>
      LocaleController.isArabic ? 'الخبرة' : 'Experience';
  static String get education =>
      LocaleController.isArabic ? 'التعليم' : 'Education';
  static String get portfolio =>
      LocaleController.isArabic ? 'الأعمال' : 'Portfolio';
  static String get videos =>
      LocaleController.isArabic ? 'فيديوهات' : 'Videos';
  static String get reviews =>
      LocaleController.isArabic ? 'التقييمات' : 'Reviews';
  static String get social =>
      LocaleController.isArabic ? 'التواصل' : 'Social';
  static String get changePhoto =>
      LocaleController.isArabic ? 'تغيير الصورة' : 'Change Photo';
  static String get basicInformation =>
      LocaleController.isArabic ? 'المعلومات الأساسية' : 'Basic Information';
  static String get talentDetails =>
      LocaleController.isArabic ? 'تفاصيل الموهبة' : 'Talent Details';
  static String get companyDetails =>
      LocaleController.isArabic ? 'تفاصيل الشركة' : 'Company Details';
  static String get heightCm =>
      LocaleController.isArabic ? 'الطول (سم)' : 'Height (cm)';
  static String get skillsCommaSeparated => LocaleController.isArabic
      ? 'المهارات (مفصولة بفاصلة)'
      : 'Skills (comma separated)';
  static String get editProfile =>
      LocaleController.isArabic ? 'تعديل الملف' : 'Edit Profile';
  static String get favorites =>
      LocaleController.isArabic ? 'المفضلة' : 'Favorites';
  static String get notifications =>
      LocaleController.isArabic ? 'الإشعارات' : 'Notifications';
  static String get conversation =>
      LocaleController.isArabic ? 'محادثة' : 'Conversation';

  // ── Agency ─────────────────────────────────────────────────────────────
  static String get agencyTalents =>
      LocaleController.isArabic ? 'المواهب' : 'Talents';
  static String get agencyCastings =>
      LocaleController.isArabic ? 'الكاستينغ' : 'Castings';
  static String get agencyAbout =>
      LocaleController.isArabic ? 'نبذة' : 'About';
  static String get agency =>
      LocaleController.isArabic ? 'الوكالة' : 'Agency';
  static String get ourTalents =>
      LocaleController.isArabic ? 'مواهبنا' : 'Our Talents';
  static String representedCount(int n) => LocaleController.isArabic
      ? '$n ممثَّل'
      : '$n represented';

  // ── Home / discover sections ───────────────────────────────────────────
  static String get popularCategories => LocaleController.isArabic
      ? 'الفئات الشائعة'
      : 'Popular Categories';
  static String get featuredTalents =>
      LocaleController.isArabic ? 'مواهب مميزة' : 'Featured Talents';
  static String get featuredCastings =>
      LocaleController.isArabic ? 'كاستينغ مميز' : 'Featured Castings';
  static String get trendingCastings =>
      LocaleController.isArabic ? 'كاستينغ رائج' : 'Trending Castings';
  static String get topAgencies =>
      LocaleController.isArabic ? 'أفضل الوكالات' : 'Top Agencies';
  static String get exploreByCraft =>
      LocaleController.isArabic ? 'استكشف حسب التخصص' : 'Explore by craft';
  static String get risingStars =>
      LocaleController.isArabic ? 'نجوم صاعدة' : 'Rising stars';
  static String get curatedForYou =>
      LocaleController.isArabic ? 'مختارة لك' : 'Curated for you';
  static String get hotRightNow =>
      LocaleController.isArabic ? 'الأكثر طلباً الآن' : 'Hot right now';
  static String get trustedPartners =>
      LocaleController.isArabic ? 'شركاء موثوقون' : 'Trusted partners';
  static String get yourNextRoleAwaits => LocaleController.isArabic
      ? 'دورك القادم بانتظارك'
      : 'YOUR NEXT ROLE AWAITS';
  static String get discoverPremiumCastingCalls => LocaleController.isArabic
      ? 'اكتشف إعلانات\nكاستينغ فاخرة'
      : 'Discover Premium\nCasting Calls';
  static String get curatedOpportunities => LocaleController.isArabic
      ? 'فرص مختارة من أفضل الوكالات والإنتاجات في المنطقة.'
      : 'Curated opportunities from top agencies and productions across the region.';

  // ── Confirmations ──────────────────────────────────────────────────────
  static String get confirmDeleteTitle =>
      LocaleController.isArabic ? 'حذف هذا؟' : 'Delete this?';
  static String get confirmDeleteBody => LocaleController.isArabic
      ? 'لا يمكن التراجع عن هذا الإجراء. هل أنت متأكد أنك تريد المتابعة؟'
      : 'This action cannot be undone. Are you sure you want to continue?';
  static String get confirmBanTitle =>
      LocaleController.isArabic ? 'حظر هذا المستخدم؟' : 'Ban this user?';
  static String get confirmBanBody => LocaleController.isArabic
      ? 'سيفقدون الوصول إلى KAST-ROLZ فوراً. يمكنك التراجع عن ذلك لاحقاً.'
      : 'They will lose access to KAST-ROLZ immediately. You can reverse this later.';
  static String get confirmLogoutTitle =>
      LocaleController.isArabic ? 'تسجيل الخروج؟' : 'Log out?';
  static String get confirmLogoutBody => LocaleController.isArabic
      ? 'يمكنك تسجيل الدخول مجدداً في أي وقت.'
      : 'You can always sign back in anytime.';
  static String get archiveThisCasting => LocaleController.isArabic
      ? 'أرشفة هذا الكاستينغ؟'
      : 'Archive this casting?';
  static String get restoreThisCasting => LocaleController.isArabic
      ? 'استعادة هذا الكاستينغ؟'
      : 'Restore this casting?';
  static String get archiveCastingBody => LocaleController.isArabic
      ? 'سيُخفى من الاكتشاف ويُعلَّم كمؤرشف.'
      : 'It will be hidden from discovery and marked archived.';
  static String get archiveCastingBodyDetail => LocaleController.isArabic
      ? 'الكاستينغ المؤرشف يتوقف عن قبول طلبات جديدة ويختفي من الاكتشاف.'
      : 'Archived castings stop accepting new applications and disappear from discovery.';
  static String get restoreCastingBody => LocaleController.isArabic
      ? 'سيُعاد فتح هذا الكاستينغ ويصبح مرئياً مجدداً.'
      : 'This casting will reopen and become visible again.';
  static String get deleteThisCasting => LocaleController.isArabic
      ? 'حذف هذا الكاستينغ؟'
      : 'Delete this casting?';
  static String get deleteCastingBody => LocaleController.isArabic
      ? 'سيُزال الإعلان نهائياً ولا يمكن التراجع.'
      : 'This permanently removes the listing and cannot be undone.';
  static String get deleteCastingBodyDetail => LocaleController.isArabic
      ? 'لا يمكن التراجع عن هذا الإجراء. ستبقى الطلبات المرتبطة به لكن الإعلان سيختفي.'
      : 'This action cannot be undone. All applications tied to it will remain but the listing will disappear.';
  static String get deleteUserBody => LocaleController.isArabic
      ? 'سيُزال الحساب والملف نهائياً. لا يمكن التراجع.'
      : 'This permanently removes their account and profile. This cannot be undone.';
  static String get banUser =>
      LocaleController.isArabic ? 'حظر المستخدم' : 'Ban User';
  static String get editUser =>
      LocaleController.isArabic ? 'تعديل المستخدم' : 'Edit User';

  // ── Filters ────────────────────────────────────────────────────────────
  static String get category =>
      LocaleController.isArabic ? 'الفئة' : 'Category';
  static String get gender =>
      LocaleController.isArabic ? 'الجنس' : 'Gender';
  static String get availability =>
      LocaleController.isArabic ? 'التوفّر' : 'Availability';
  static String get language =>
      LocaleController.isArabic ? 'اللغة' : 'Language';
  static String get heightRange =>
      LocaleController.isArabic ? 'نطاق الطول' : 'Height Range';
  static String get heightMinCm =>
      LocaleController.isArabic ? 'الحد الأدنى للطول (سم)' : 'Height Min (cm)';
  static String get experienceMinY => LocaleController.isArabic
      ? 'الحد الأدنى للخبرة (سنة)'
      : 'Experience Min (y)';
  static String get location =>
      LocaleController.isArabic ? 'الموقع' : 'Location';
  static String get nationality =>
      LocaleController.isArabic ? 'الجنسية' : 'Nationality';
  static String get experienceLevel =>
      LocaleController.isArabic ? 'مستوى الخبرة' : 'Experience Level';
  static String get sortBy =>
      LocaleController.isArabic ? 'ترتيب حسب' : 'Sort By';
  static String get verifiedOnly =>
      LocaleController.isArabic ? 'الموثّقون فقط' : 'Verified Only';
  static String get city =>
      LocaleController.isArabic ? 'المدينة' : 'City';
  static String get sortTopRated =>
      LocaleController.isArabic ? 'الأعلى تقييماً' : 'Top Rated';
  static String get sortNewest =>
      LocaleController.isArabic ? 'الأحدث' : 'Newest';
  static String get sortMostViewed =>
      LocaleController.isArabic ? 'الأكثر مشاهدة' : 'Most Viewed';
  static String get sortName =>
      LocaleController.isArabic ? 'الاسم' : 'Name';
  static String get sortNameAZ =>
      LocaleController.isArabic ? 'الاسم (أ-ي)' : 'Name (A-Z)';
  static String get verifiedProfilesOnly => LocaleController.isArabic
      ? 'الملفات الموثّقة فقط'
      : 'Verified profiles only';
  static String get searchEllipsis =>
      LocaleController.isArabic ? 'بحث…' : 'Search…';
  static String get castingTitleHint => LocaleController.isArabic
      ? 'مثال: ممثلة رئيسية — فيلم روائي'
      : 'e.g. Lead Actress — Feature Film';
  static String get roleHint => LocaleController.isArabic
      ? 'مثال: دور رئيسي، دور ثانوي…'
      : 'e.g. Lead role, supporting role…';
  static String get cityHint =>
      LocaleController.isArabic ? 'الجزائر العاصمة' : 'Algiers';
  static String get yrs =>
      LocaleController.isArabic ? 'سنة' : 'yrs';
  static String get cm =>
      LocaleController.isArabic ? 'سم' : 'cm';
  static String get kg =>
      LocaleController.isArabic ? 'كغ' : 'kg';
  static String heightCmPlus(int cm) =>
      LocaleController.isArabic ? '$cm سم+' : '$cm cm+';
  static String ageRangeTrailing(int min, int max) => LocaleController.isArabic
      ? '$min – $max سنة'
      : '$min – $max yrs';
  static String heightRangeTrailing(int min, int max) =>
      LocaleController.isArabic ? '$min – $max سم' : '$min – $max cm';
  static String totalCount(int n) =>
      LocaleController.isArabic ? '$n إجمالي' : '$n total';
  static String viewApplicantsCount(int n) => LocaleController.isArabic
      ? 'عرض المتقدمين ($n)'
      : 'View Applicants ($n)';
  static String applicantsFor(String title) => LocaleController.isArabic
      ? 'المتقدمون · $title'
      : 'Applicants · $title';

  // ── Enum labels ────────────────────────────────────────────────────────
  static String get roleTalentLabel =>
      LocaleController.isArabic ? 'موهبة' : 'Talent';
  static String get roleRecruiterLabel =>
      LocaleController.isArabic ? 'مسؤول كاستينغ' : 'Recruiter';
  static String get roleAdminLabel =>
      LocaleController.isArabic ? 'مسؤول' : 'Admin';
  static String get roleGuestLabel =>
      LocaleController.isArabic ? 'زائر' : 'Guest';

  static String get catActor =>
      LocaleController.isArabic ? 'ممثل' : 'Actor';
  static String get catActress =>
      LocaleController.isArabic ? 'ممثلة' : 'Actress';
  static String get catModel =>
      LocaleController.isArabic ? 'عارضة أزياء' : 'Model';
  static String get catExtra =>
      LocaleController.isArabic ? 'كومبارس' : 'Extra';
  static String get catVoiceActor =>
      LocaleController.isArabic ? 'ممثل صوت' : 'Voice Actor';
  static String get catDancer =>
      LocaleController.isArabic ? 'راقص' : 'Dancer';
  static String get catMusician =>
      LocaleController.isArabic ? 'موسيقي' : 'Musician';
  static String get catContentCreator =>
      LocaleController.isArabic ? 'صانع محتوى' : 'Content Creator';
  static String get catPhotographer =>
      LocaleController.isArabic ? 'مصوّر' : 'Photographer';

  static String get genderMale =>
      LocaleController.isArabic ? 'ذكر' : 'Male';
  static String get genderFemale =>
      LocaleController.isArabic ? 'أنثى' : 'Female';
  static String get genderNonBinary =>
      LocaleController.isArabic ? 'غير ثنائي' : 'Non-binary';
  static String get genderOther =>
      LocaleController.isArabic ? 'آخر' : 'Other';

  static String get availAvailable =>
      LocaleController.isArabic ? 'متاح' : 'Available';
  static String get availBusy =>
      LocaleController.isArabic ? 'مشغول' : 'Busy';
  static String get availLimited =>
      LocaleController.isArabic ? 'محدود' : 'Limited';

  static String get statusOpen =>
      LocaleController.isArabic ? 'مفتوح' : 'Open';
  static String get statusClosed =>
      LocaleController.isArabic ? 'مغلق' : 'Closed';
  static String get statusFilled =>
      LocaleController.isArabic ? 'مكتمل' : 'Filled';
  static String get statusDraft =>
      LocaleController.isArabic ? 'مسودة' : 'Draft';
  static String get statusArchived =>
      LocaleController.isArabic ? 'مؤرشف' : 'Archived';

  static String get appPending =>
      LocaleController.isArabic ? 'قيد الانتظار' : 'Pending';
  static String get appAccepted =>
      LocaleController.isArabic ? 'مقبول' : 'Accepted';
  static String get appRejected =>
      LocaleController.isArabic ? 'مرفوض' : 'Rejected';
  static String get appWithdrawn =>
      LocaleController.isArabic ? 'منسحب' : 'Withdrawn';
  static String get appShortlisted =>
      LocaleController.isArabic ? 'مختصر' : 'Shortlisted';

  static String get expBeginner =>
      LocaleController.isArabic ? 'مبتدئ' : 'Beginner';
  static String get expIntermediate =>
      LocaleController.isArabic ? 'متوسط' : 'Intermediate';
  static String get expProfessional =>
      LocaleController.isArabic ? 'محترف' : 'Professional';
  static String get expCelebrity =>
      LocaleController.isArabic ? 'مشهور' : 'Celebrity';

  static String get castingTypeFilm =>
      LocaleController.isArabic ? 'فيلم' : 'Film';
  static String get castingTypeTv =>
      LocaleController.isArabic ? 'تلفزيون' : 'TV';
  static String get castingTypeCommercial =>
      LocaleController.isArabic ? 'إعلان' : 'Commercial';
  static String get castingTypeTheater =>
      LocaleController.isArabic ? 'مسرح' : 'Theater';
  static String get castingTypeVoiceOver =>
      LocaleController.isArabic ? 'تعليق صوتي' : 'Voice Over';
  static String get castingTypeFashion =>
      LocaleController.isArabic ? 'أزياء' : 'Fashion';
  static String get castingTypeMusicVideo =>
      LocaleController.isArabic ? 'فيديو كليب' : 'Music Video';
  static String get castingTypeOther =>
      LocaleController.isArabic ? 'آخر' : 'Other';

  static String get companyDirector =>
      LocaleController.isArabic ? 'مخرج' : 'Director';
  static String get companyProducer =>
      LocaleController.isArabic ? 'منتج' : 'Producer';
  static String get companyCastingDirector => LocaleController.isArabic
      ? 'مدير كاستينغ'
      : 'Casting Director';
  static String get companyAgency =>
      LocaleController.isArabic ? 'وكالة' : 'Agency';
  static String get companyBrand =>
      LocaleController.isArabic ? 'علامة تجارية' : 'Brand';
  static String get companyStudio =>
      LocaleController.isArabic ? 'استوديو' : 'Studio';

  static String get userActive =>
      LocaleController.isArabic ? 'نشط' : 'Active';
  static String get userBanned =>
      LocaleController.isArabic ? 'محظور' : 'Banned';
  static String get userPendingVerification => LocaleController.isArabic
      ? 'بانتظار التوثيق'
      : 'Pending Verification';
  static String get userSuspended =>
      LocaleController.isArabic ? 'موقوف' : 'Suspended';

  static String get reportPending =>
      LocaleController.isArabic ? 'قيد الانتظار' : 'Pending';
  static String get reportResolved =>
      LocaleController.isArabic ? 'تم الحل' : 'Resolved';
  static String get reportDismissed =>
      LocaleController.isArabic ? 'مرفوض' : 'Dismissed';

  static String get favTalent =>
      LocaleController.isArabic ? 'موهبة' : 'Talent';
  static String get favCasting =>
      LocaleController.isArabic ? 'كاستينغ' : 'Casting';
  static String get favAgency =>
      LocaleController.isArabic ? 'وكالة' : 'Agency';

  static String get notifLike =>
      LocaleController.isArabic ? 'إعجاب' : 'Like';
  static String get notifApplication =>
      LocaleController.isArabic ? 'طلب' : 'Application';
  static String get notifAcceptance =>
      LocaleController.isArabic ? 'قبول' : 'Acceptance';
  static String get notifRejection =>
      LocaleController.isArabic ? 'رفض' : 'Rejection';
  static String get notifMessage =>
      LocaleController.isArabic ? 'رسالة' : 'Message';
  static String get notifReminder =>
      LocaleController.isArabic ? 'تذكير' : 'Reminder';
  static String get notifVerification =>
      LocaleController.isArabic ? 'توثيق' : 'Verification';
  static String get notifSystem =>
      LocaleController.isArabic ? 'النظام' : 'System';

  static String get msgTypeText =>
      LocaleController.isArabic ? 'نص' : 'Text';
  static String get msgTypeImage =>
      LocaleController.isArabic ? 'صورة' : 'Image';
  static String get msgTypeVoice =>
      LocaleController.isArabic ? 'صوت' : 'Voice';
  static String get msgTypeSystem =>
      LocaleController.isArabic ? 'النظام' : 'System';

  static String get reportTargetUser =>
      LocaleController.isArabic ? 'مستخدم' : 'User';
  static String get reportTargetTalent =>
      LocaleController.isArabic ? 'موهبة' : 'Talent';
  static String get reportTargetRecruiter =>
      LocaleController.isArabic ? 'مسؤول كاستينغ' : 'Recruiter';
  static String get reportTargetCasting =>
      LocaleController.isArabic ? 'كاستينغ' : 'Casting';
  static String get reportTargetMessage =>
      LocaleController.isArabic ? 'رسالة' : 'Message';
  static String get reportTargetReview =>
      LocaleController.isArabic ? 'تقييم' : 'Review';

  // ── Formatters (simple + parameterized) ────────────────────────────────
  static String get undisclosed =>
      LocaleController.isArabic ? 'غير معلن' : 'Undisclosed';
  static String get unpaidTfp =>
      LocaleController.isArabic ? 'بدون أجر / TFP' : 'Unpaid / TFP';
  static String get fromSalary =>
      LocaleController.isArabic ? 'من' : 'From';
  static String get anyAge =>
      LocaleController.isArabic ? 'أي عمر' : 'Any age';
  static String get upToAge =>
      LocaleController.isArabic ? 'حتى' : 'Up to';
  static String get yrsSuffix =>
      LocaleController.isArabic ? 'سنة' : 'yrs';
  static String get unitCm => LocaleController.isArabic ? 'سم' : 'cm';
  static String get unitM => LocaleController.isArabic ? 'م' : 'm';
  static String get unitKm => LocaleController.isArabic ? 'كم' : 'km';
  static String get noDeadline =>
      LocaleController.isArabic ? 'بدون موعد نهائي' : 'No deadline';
  static String get closesToday =>
      LocaleController.isArabic ? 'يُغلق اليوم' : 'Closes today';
  static String get closesTomorrow =>
      LocaleController.isArabic ? 'يُغلق غداً' : 'Closes tomorrow';
  static String get ratingNew =>
      LocaleController.isArabic ? 'جديد' : 'New';
  static String get justNow =>
      LocaleController.isArabic ? 'الآن' : 'Just now';

  static String resultsCount(int n) => LocaleController.isArabic
      ? '$n نتيجة'
      : '$n result${n == 1 ? '' : 's'}';

  static String foundCount(int n) => LocaleController.isArabic
      ? '$n موجود'
      : '$n found';

  static String applicantsLabel(int n) => LocaleController.isArabic
      ? '$n متقدم'
      : '$n applicant${n == 1 ? '' : 's'}';

  static String closesInDays(int days) => LocaleController.isArabic
      ? 'يُغلق خلال $days أيام'
      : 'Closes in $days days';

  static String closedDaysAgo(int days) => LocaleController.isArabic
      ? 'أُغلق منذ $days يوم'
      : 'Closed ${days}d ago';

  static String closesOn(String date) => LocaleController.isArabic
      ? 'يُغلق في $date'
      : 'Closes $date';

  static String minutesAgo(int n) => LocaleController.isArabic
      ? 'منذ $n د'
      : '${n}m ago';

  static String hoursAgo(int n) => LocaleController.isArabic
      ? 'منذ $n س'
      : '${n}h ago';

  static String daysAgo(int n) => LocaleController.isArabic
      ? 'منذ $n يوم'
      : '${n}d ago';

  static String weeksAgo(int n) => LocaleController.isArabic
      ? 'منذ $n أسبوع'
      : '${n}w ago';

  static String monthsAgo(int n) => LocaleController.isArabic
      ? 'منذ $n شهر'
      : '${n}mo ago';

  static String yearsAgo(int n) => LocaleController.isArabic
      ? 'منذ $n سنة'
      : '${n}y ago';

  static String fromSalaryAmount(String amount) => LocaleController.isArabic
      ? 'من $amount'
      : 'From $amount';

  static String upToAgeValue(int max) => LocaleController.isArabic
      ? 'حتى $max سنة'
      : 'Up to $max yrs';

  static String agePlus(int min) => LocaleController.isArabic
      ? '$min+ سنة'
      : '$min+ yrs';

  static String ageValue(int age) => LocaleController.isArabic
      ? '$age سنة'
      : '$age yrs';

  static String ageRangeValue(int min, int max) => LocaleController.isArabic
      ? '$min–$max سنة'
      : '$min–$max yrs';

  static String heightCmValue(int cm) => LocaleController.isArabic
      ? '$cm سم'
      : '$cm cm';

  static String yearsPlus(int years) => '$years+';

  // ── Pricing ────────────────────────────────────────────────────────────
  static String get pricing =>
      LocaleController.isArabic ? 'الأسعار' : 'Pricing';
  static String get pricingTitle => LocaleController.isArabic
      ? 'أسعار بسيطة وسينمائية'
      : 'Simple, cinematic pricing';
  static String get pricingSubtitle => LocaleController.isArabic
      ? 'خطط للمواهب. اشتراكات قوية للشركات.'
      : 'Plans for talents. Powerful subscriptions for companies.';
  static String get pricingForTalents =>
      LocaleController.isArabic ? 'للمواهب' : 'For Talents';
  static String get pricingForRecruiters =>
      LocaleController.isArabic ? 'لمسؤولي الكاستينغ' : 'For Recruiters';
  static String get planStandard =>
      LocaleController.isArabic ? 'ستاندرد' : 'Standard';
  static String get planPremium =>
      LocaleController.isArabic ? 'بريميوم' : 'Premium';
  static String get planStudio =>
      LocaleController.isArabic ? 'استوديو' : 'Studio';
  static String get planEnterprise =>
      LocaleController.isArabic ? 'مؤسسة' : 'Enterprise';
  static String get priceStandard => '\$4.99';
  static String get pricePremium => '\$9.99';
  static String get priceStudio => '\$89.99';
  static String get priceContactSales => LocaleController.isArabic
      ? 'تواصل مع المبيعات'
      : 'CONTACT SALES';
  static String get perMonth =>
      LocaleController.isArabic ? '/ شهر' : '/ month';
  static String get tryFirstMonthFree => LocaleController.isArabic
      ? 'جرّب الشهر الأول مجاناً'
      : 'Try 1st month free';
  static String get mostPopular =>
      LocaleController.isArabic ? 'الأكثر شعبية' : 'Most popular';
  static String get startStandard =>
      LocaleController.isArabic ? 'ابدأ بستاندرد' : 'Start Standard';
  static String get goPremium =>
      LocaleController.isArabic ? 'احصل على بريميوم' : 'Go Premium';
  static String get subscribeStudio =>
      LocaleController.isArabic ? 'اشترك في استوديو' : 'Subscribe';
  static String get contactSales =>
      LocaleController.isArabic ? 'تواصل مع المبيعات' : 'Contact sales';
  static String get pricingComingSoon => LocaleController.isArabic
      ? 'الدفع قريباً — سنخبرك عند التفعيل.'
      : 'Checkout coming soon — we\'ll notify you when it\'s live.';
  static String get salesContactSoon => LocaleController.isArabic
      ? 'فريق المبيعات سيتواصل معك قريباً.'
      : 'Our sales team will reach out shortly.';

  // Talent Standard features
  static String get featureProProfilePhoto => LocaleController.isArabic
      ? 'ملف احترافي / صور فقط'
      : 'Professional profile / Photo only';
  static String get feature5Applications => LocaleController.isArabic
      ? '5 طلبات / شهر'
      : '5 applications / month';
  static String get featureBasicVisibility => LocaleController.isArabic
      ? 'ظهور أساسي في البحث'
      : 'Basic search visibility';

  // Talent Premium features
  static String get featureVerifiedBadge =>
      LocaleController.isArabic ? 'شارة موثّقة' : 'Verified badge';
  static String get featureProProfileMedia => LocaleController.isArabic
      ? 'ملف احترافي / صور وفيديوهات'
      : 'Professional profile / Pictures & videos';
  static String get featureUnlimitedApplications => LocaleController.isArabic
      ? 'طلبات غير محدودة'
      : 'Unlimited applications';
  static String get featurePriorityListing =>
      LocaleController.isArabic ? 'ظهور أولوي' : 'Priority listing';
  static String get featureAdvancedAnalytics => LocaleController.isArabic
      ? 'تحليلات متقدمة'
      : 'Advanced analytics';
  static String get featureFeaturedPortfolio => LocaleController.isArabic
      ? 'معرض أعمال مميز'
      : 'Featured portfolio';
  static String get featureMessaging =>
      LocaleController.isArabic ? 'المراسلة' : 'Messaging';

  // Recruiter Studio features
  static String get feature10Castings => LocaleController.isArabic
      ? 'نشر 10 كاستينغ / شهر'
      : 'Post 10 castings / month';
  static String get featureUnlimitedTalentSearch => LocaleController.isArabic
      ? 'بحث مواهب غير محدود'
      : 'Unlimited talent search';
  static String get featureApplicantTracking => LocaleController.isArabic
      ? 'تتبع المتقدمين'
      : 'Applicant tracking';

  // Recruiter Enterprise features
  static String get featureUnlimitedCastings => LocaleController.isArabic
      ? 'كاستينغ غير محدود'
      : 'Unlimited castings';
  static String get featureCustomAiMatching => LocaleController.isArabic
      ? 'مطابقة ذكاء اصطناعي مخصصة'
      : 'Custom AI matching';
  static String get featurePrioritySupport =>
      LocaleController.isArabic ? 'دعم أولوي' : 'Priority support';

  // ── Settings ───────────────────────────────────────────────────────────
  static String get settings =>
      LocaleController.isArabic ? 'الإعدادات' : 'Settings';
  static String get preferences =>
      LocaleController.isArabic ? 'التفضيلات' : 'Preferences';
  static String get pushNotifications => LocaleController.isArabic
      ? 'إشعارات الدفع'
      : 'Push Notifications';
  static String get privateProfile =>
      LocaleController.isArabic ? 'ملف خاص' : 'Private Profile';
  static String get support =>
      LocaleController.isArabic ? 'الدعم' : 'Support';
  static String get helpSupport =>
      LocaleController.isArabic ? 'المساعدة والدعم' : 'Help & Support';
  static String get termsPrivacy => LocaleController.isArabic
      ? 'الشروط وسياسة الخصوصية'
      : 'Terms & Privacy Policy';
  static String get aboutKastRolz =>
      LocaleController.isArabic ? 'عن KAST-ROLZ' : 'About KAST-ROLZ';
  static String get termsOfService =>
      LocaleController.isArabic ? 'شروط الخدمة' : 'Terms of Service';
  static String get privacyPolicy =>
      LocaleController.isArabic ? 'سياسة الخصوصية' : 'Privacy Policy';
  static String get contactUs =>
      LocaleController.isArabic ? 'تواصل معنا' : 'Contact Us';
  static String get legal =>
      LocaleController.isArabic ? 'قانوني' : 'Legal';

  // About (from kast-rolz-call.lovable.app/about)
  static String get aboutIntro => LocaleController.isArabic
      ? 'KAST-ROLZ في مهمة لرقمنة صناعة الكاستينغ وتحديثها — بدءاً من الجزائر، مروراً بمنطقة الشرق الأوسط وشمال أفريقيا، وبناء جسور مع الاقتصاد الإبداعي العالمي. نجمع بين تصميم سينمائي، ومواهب موثّقة، ومطابقة ذكية لمساعدة القصص العظيمة على إيجاد طاقمها.'
      : 'KAST-ROLZ is on a mission to digitize and modernize the casting industry — starting in Algeria, expanding across MENA, and building bridges with the global creative economy. We combine cinematic design, verified talent and intelligent matching to help great stories find their cast.';
  static String get ourMission =>
      LocaleController.isArabic ? 'مهمتنا' : 'Our Mission';
  static String get ourMissionBody => LocaleController.isArabic
      ? 'منح كل مبدع — من الممثل لأول مرة إلى شركة الإنتاج الراسخة — منصة احترافية بلا حدود ليُكتشف ويُوظَّف ويُحتفى به.'
      : 'Give every creative — from first-time actor to established production company — a professional, borderless stage to be discovered, hired and celebrated.';
  static String get ourVision =>
      LocaleController.isArabic ? 'رؤيتنا' : 'Vision';
  static String get ourVisionBody => LocaleController.isArabic
      ? 'أن نكون منصة الكاستينغ المرجعية في الجزائر ومنطقة الشرق الأوسط وشمال أفريقيا، وجسراً موثوقاً لاكتشاف المواهب الإبداعية عالمياً — بما في ذلك شراكات ضمن منظومات الابتكار الكورية والدولية.'
      : 'To be the reference casting platform in Algeria and the MENA region, and a trusted bridge for creative talent to be discovered globally — including partnerships within the Korean and international innovation ecosystems.';

  // Contact (from kast-rolz-call.lovable.app/contact)
  static String get contactIntro => LocaleController.isArabic
      ? 'المستثمرون والشركاء والصحافة — يسعدنا أن نسمع منكم.'
      : "Investors, partners and press — we'd love to hear from you.";
  static String get contactEmailLabel =>
      LocaleController.isArabic ? 'البريد' : 'Email';
  static String get contactEmailValue => 'hello@kastrolz.com';
  static String get contactHqLabel =>
      LocaleController.isArabic ? 'المقر' : 'HQ';
  static String get contactHqValue =>
      LocaleController.isArabic ? 'الجزائر العاصمة، الجزائر' : 'Algiers, Algeria';
  static String get contactExpanding => LocaleController.isArabic
      ? 'نتوسع في الشرق الأوسط وشمال أفريقيا · عالمياً'
      : 'Expanding to MENA · Global';
  static String get sendMessage =>
      LocaleController.isArabic ? 'إرسال الرسالة' : 'Send message';
  static String get yourMessage =>
      LocaleController.isArabic ? 'رسالتك' : 'Message';
  static String get messageSentThanks => LocaleController.isArabic
      ? 'شكراً لك — سنعود إليك قريباً.'
      : "Thanks — we'll get back to you shortly.";
  static String get hintContactMessage => LocaleController.isArabic
      ? 'كيف يمكننا المساعدة؟'
      : 'How can we help?';

  // Terms (from kast-rolz-call.lovable.app/terms)
  static String get termsBody1 => LocaleController.isArabic
      ? 'باستخدامك لـ KAST-ROLZ فإنك توافق على التصرف باحتراف، وتقديم معلومات دقيقة، واحترام حقوق باقي أعضاء المجتمع.'
      : 'By using KAST-ROLZ you agree to act professionally, provide accurate information and respect the rights of other members of the community.';
  static String get termsBody2 => LocaleController.isArabic
      ? 'أي إساءة استخدام — بما في ذلك انتحال الهوية أو الرسائل المزعجة أو الكاستينغ المضلل — قد تؤدي إلى تعليق حسابك.'
      : 'Any misuse — including impersonation, spam, or misleading castings — may lead to suspension of your account.';
  static String get termsBody3 => LocaleController.isArabic
      ? 'ستُنشر الشروط الكاملة قبل الإطلاق العام. لأي استفسار، تواصل معنا على legal@kastrolz.com.'
      : 'Full terms will be published prior to public launch. For any question, reach out to legal@kastrolz.com.';

  // Privacy (from kast-rolz-call.lovable.app/privacy)
  static String get privacyBody1 => LocaleController.isArabic
      ? 'تحترم KAST-ROLZ خصوصيتك. تصف هذه الصفحة كيف نجمع البيانات الشخصية ونستخدمها ونحميها على منصتنا.'
      : 'KAST-ROLZ respects your privacy. This page describes how we collect, use and protect personal data on our platform.';
  static String get privacyBody2 => LocaleController.isArabic
      ? 'نجمع فقط المعلومات اللازمة لتشغيل الخدمة — مثل ملفك الشخصي ومعرض أعمالك وطلبات الكاستينغ والمراسلات — ولا نبيع بياناتك أبداً لأطراف ثالثة.'
      : 'We collect only the information necessary to operate the service — such as your profile, portfolio, casting applications and communications — and never sell your data to third parties.';
  static String get privacyBody3 => LocaleController.isArabic
      ? 'يمكنك طلب الوصول إلى بياناتك الشخصية أو تصحيحها أو حذفها في أي وقت عبر التواصل مع privacy@kastrolz.com.'
      : 'You may request access, correction or deletion of your personal data at any time by contacting privacy@kastrolz.com.';

  // ── Admin ──────────────────────────────────────────────────────────────
  static String get adminConsole =>
      LocaleController.isArabic ? 'لوحة الإدارة' : 'Admin Console';
  static String get platformOverview =>
      LocaleController.isArabic ? 'نظرة عامة على المنصة' : 'Platform Overview';
  static String get manageUsers =>
      LocaleController.isArabic ? 'إدارة المستخدمين' : 'Manage Users';
  static String get manageUsersSubtitle => LocaleController.isArabic
      ? 'إيقاف أو توثيق أو حظر الحسابات'
      : 'Suspend, verify or ban accounts';
  static String get reviewReports =>
      LocaleController.isArabic ? 'مراجعة البلاغات' : 'Review Reports';
  static String get reviewReportsSubtitle => LocaleController.isArabic
      ? 'مراجعة بلاغات المجتمع'
      : 'Review community reports';
  static String get verificationQueue => LocaleController.isArabic
      ? 'قائمة التوثيق'
      : 'Verification Queue';
  static String get verificationQueueSubtitle => LocaleController.isArabic
      ? 'الموافقة على شارات المواهب ومسؤولي الكاستينغ'
      : 'Approve talent & recruiter badges';
  static String get castingOversight => LocaleController.isArabic
      ? 'الإشراف على الكاستينغ'
      : 'Casting Oversight';
  static String get castingOversightSubtitle => LocaleController.isArabic
      ? 'مراجعة وإشراف على الكاستينغ المباشر'
      : 'Audit and moderate live castings';
  static String get moderationTools =>
      LocaleController.isArabic ? 'أدوات الإشراف' : 'Moderation Tools';
  static String get totalUsers =>
      LocaleController.isArabic ? 'إجمالي المستخدمين' : 'Total Users';
  static String get pendingReports =>
      LocaleController.isArabic ? 'بلاغات معلّقة' : 'Pending Reports';
  static String get verifiedTalents =>
      LocaleController.isArabic ? 'مواهب موثّقة' : 'Verified Talents';
  static String get allUsers =>
      LocaleController.isArabic ? 'كل المستخدمين' : 'All Users';
  static String get castingsPosted => LocaleController.isArabic
      ? 'كاستينغ منشور'
      : 'Castings Posted';
  static String get recruiters =>
      LocaleController.isArabic ? 'مسؤولو الكاستينغ' : 'Recruiters';

  // ── Snackbars / feedback ───────────────────────────────────────────────
  static String get profileUpdated => LocaleController.isArabic
      ? 'تم تحديث الملف بنجاح!'
      : 'Profile updated successfully!';
  static String get profileUpdatedShort =>
      LocaleController.isArabic ? 'تم تحديث الملف.' : 'Profile updated.';
  static String get castingPublished => LocaleController.isArabic
      ? 'تم نشر الكاستينغ بنجاح!'
      : 'Casting published successfully!';
  static String get castingUpdated => LocaleController.isArabic
      ? 'تم تحديث الكاستينغ بنجاح!'
      : 'Casting updated successfully!';
  static String get castingDuplicated => LocaleController.isArabic
      ? 'تم نسخ الكاستينغ كمسودة.'
      : 'Casting duplicated as a draft.';
  static String get castingArchived =>
      LocaleController.isArabic ? 'تم أرشفة الكاستينغ.' : 'Casting archived.';
  static String get castingRestored =>
      LocaleController.isArabic ? 'تمت استعادة الكاستينغ.' : 'Casting restored.';
  static String get castingDeleted =>
      LocaleController.isArabic ? 'تم حذف الكاستينغ.' : 'Casting deleted.';
  static String get castingClosedSnack =>
      LocaleController.isArabic ? 'تم إغلاق الكاستينغ.' : 'Casting closed.';
  static String get castingNowFeatured => LocaleController.isArabic
      ? 'الكاستينغ مميز الآن.'
      : 'Casting is now featured.';
  static String get removedFromFeatured => LocaleController.isArabic
      ? 'أُزيل من المميز.'
      : 'Removed from featured.';
  static String get applicationSubmitted =>
      LocaleController.isArabic ? 'تم إرسال الطلب!' : 'Application submitted!';
  static String get addedToFavorites =>
      LocaleController.isArabic ? 'أُضيف إلى المفضلة.' : 'Added to favorites.';
  static String get removedFromFavorites => LocaleController.isArabic
      ? 'أُزيل من المفضلة.'
      : 'Removed from favorites.';
  static String get reportSubmitted => LocaleController.isArabic
      ? 'تم إرسال البلاغ. سيراجعه فريقنا قريباً.'
      : 'Report submitted. Our team will review it shortly.';
  static String get reportDismissedSnack =>
      LocaleController.isArabic ? 'تم تجاهل البلاغ.' : 'Report dismissed.';
  static String get reportResolvedSnack =>
      LocaleController.isArabic ? 'تم حل البلاغ.' : 'Report resolved.';
  static String get reportReopenedSnack =>
      LocaleController.isArabic ? 'أُعيد فتح البلاغ.' : 'Report reopened.';
  static String get signInToMessage => LocaleController.isArabic
      ? 'سجّل الدخول لبدء محادثة.'
      : 'Sign in to start a conversation.';
  static String get signInToFavorites => LocaleController.isArabic
      ? 'سجّل الدخول لحفظ المفضلة.'
      : 'Sign in to save favorites.';
  static String get signInToReport => LocaleController.isArabic
      ? 'سجّل الدخول للإبلاغ عن ملف.'
      : 'Sign in to report a profile.';
  static String get signInToReportCasting => LocaleController.isArabic
      ? 'سجّل الدخول للإبلاغ عن كاستينغ.'
      : 'Sign in to report a casting.';
  static String get ownProfileSnack => LocaleController.isArabic
      ? 'هذا ملفك الشخصي.'
      : "That's your own profile.";
  static String get onlyTalentCanApply => LocaleController.isArabic
      ? 'حسابات المواهب فقط يمكنها التقديم للكاستينغ.'
      : 'Only talent accounts can apply to castings.';
  static String get onlyRecruiterCanPost => LocaleController.isArabic
      ? 'حسابات مسؤولي الكاستينغ فقط يمكنها نشر الكاستينغ.'
      : 'Only recruiter accounts can post castings.';
  static String get photoUploadComingSoon => LocaleController.isArabic
      ? 'رفع الصور قادم قريباً.'
      : 'Photo upload is coming soon.';
  static String get recruiterProfileComingSoon => LocaleController.isArabic
      ? 'ملف مسؤول الكاستينغ قادم قريباً.'
      : 'Recruiter profile coming soon.';
  static String shareLinkCopied(String name) => LocaleController.isArabic
      ? 'تم نسخ رابط مشاركة $name إلى الحافظة.'
      : 'Share link for $name copied to clipboard.';
  static String applicationMarkedAs(String status) => LocaleController.isArabic
      ? 'تم تعليم الطلب كـ$status.'
      : 'Application marked as $status.';
  static String verificationRejected(String name) => LocaleController.isArabic
      ? 'رُفض طلب توثيق $name.'
      : 'Verification request for $name rejected.';
  static String requestedAgo(String timeAgo) => LocaleController.isArabic
      ? 'طُلب $timeAgo'
      : 'Requested $timeAgo';
  static String reportedBy(String name) => LocaleController.isArabic
      ? 'أبلغ عنه $name'
      : 'Reported by $name';
  static String reportSubject(String label) => LocaleController.isArabic
      ? 'إبلاغ عن $label'
      : 'Report $label';
  static String openingPlatform(String platform) => LocaleController.isArabic
      ? 'جارٍ فتح $platform…'
      : 'Opening $platform…';
  static String get unknownUser =>
      LocaleController.isArabic ? 'مستخدم غير معروف' : 'Unknown user';
  static String get unknownTalent =>
      LocaleController.isArabic ? 'موهبة غير معروفة' : 'Unknown talent';
  static String get unknownRecruiter => LocaleController.isArabic
      ? 'مسؤول كاستينغ غير معروف'
      : 'Unknown recruiter';
  static String get unknownCasting =>
      LocaleController.isArabic ? 'كاستينغ غير معروف' : 'Unknown casting';
  static String get deletedMessage =>
      LocaleController.isArabic ? 'رسالة محذوفة' : 'Deleted message';
  static String get deletedReview =>
      LocaleController.isArabic ? 'تقييم محذوف' : 'Deleted review';
  static String get kastRolzUser =>
      LocaleController.isArabic ? 'مستخدم KAST-ROLZ' : 'KAST-ROLZ User';
  static String get kastRolzRecruiter => LocaleController.isArabic
      ? 'مسؤول كاستينغ KAST-ROLZ'
      : 'KAST-ROLZ Recruiter';

  // ── Parameterized admin / profile / chat / notifications ───────────────
  static String pendingReportsToolSubtitle(int n) => LocaleController.isArabic
      ? '$n بلاغ معلّق'
      : '$n pending report${n == 1 ? '' : 's'}';

  static String pendingCount(int n) => LocaleController.isArabic
      ? '$n معلّق'
      : '$n pending';

  static String isNowVerified(String name) => LocaleController.isArabic
      ? '$name موثّق الآن.'
      : '$name is now verified.';

  static String isNowUnverified(String name) => LocaleController.isArabic
      ? 'أُلغي توثيق $name.'
      : '$name is now unverified.';

  static String banNamed(String name) =>
      LocaleController.isArabic ? 'حظر $name؟' : 'Ban $name?';

  static String deleteNamed(String name) =>
      LocaleController.isArabic ? 'حذف $name؟' : 'Delete $name?';

  static String hasBeenBanned(String name) => LocaleController.isArabic
      ? 'تم حظر $name.'
      : '$name has been banned.';

  static String hasBeenUnbanned(String name) => LocaleController.isArabic
      ? 'أُلغي حظر $name.'
      : '$name has been unbanned.';

  static String wasDeleted(String name) => LocaleController.isArabic
      ? 'تم حذف $name.'
      : '$name was deleted.';

  static String talentsTabCount(int n) => LocaleController.isArabic
      ? 'المواهب ($n)'
      : 'Talents ($n)';

  static String recruitersTabCount(int n) => LocaleController.isArabic
      ? 'مسؤولو الكاستينغ ($n)'
      : 'Recruiters ($n)';

  static String reviewsCount(int n) => LocaleController.isArabic
      ? '$n تقييم'
      : '$n review${n == 1 ? '' : 's'}';

  static String weightKgValue(num kg) => LocaleController.isArabic
      ? '${kg.toStringAsFixed(0)} كغ'
      : '${kg.toStringAsFixed(0)} kg';

  static String get aCasting =>
      LocaleController.isArabic ? 'كاستينغ' : 'a casting';

  static String get notifNewApplicationTitle =>
      LocaleController.isArabic ? 'طلب جديد' : 'New application';

  static String notifNewApplicationBody(String castingTitle) =>
      LocaleController.isArabic
          ? 'تقدّمت موهبة إلى "$castingTitle".'
          : 'A talent applied to "$castingTitle".';

  static String get notifApplicationAcceptedTitle =>
      LocaleController.isArabic ? 'تم قبول الطلب' : 'Application accepted';

  static String notifApplicationAcceptedBody(String castingTitle) =>
      LocaleController.isArabic
          ? 'أخبار سارة! تم قبول طلبك لـ "$castingTitle".'
          : 'Great news! Your application to "$castingTitle" was accepted.';

  static String get notifApplicationUpdateTitle =>
      LocaleController.isArabic ? 'تحديث الطلب' : 'Application update';

  static String notifApplicationRejectedBody(String castingTitle) =>
      LocaleController.isArabic
          ? 'لم يُقبل طلبك لـ "$castingTitle" هذه المرة.'
          : 'Your application to "$castingTitle" was not retained this time.';

  static String get voiceMessageContent =>
      LocaleController.isArabic ? '[رسالة صوتية]' : '[Voice message]';

  static String get sayHelloWave =>
      LocaleController.isArabic ? 'قل مرحباً 👋' : 'Say hello 👋';

  static String get hintFirstName =>
      LocaleController.isArabic ? 'أمينة' : 'Amina';
  static String get hintLastName =>
      LocaleController.isArabic ? 'سفيان' : 'Sofiane';
  static String get hintPhone => '+213 5XX XX XX XX';
  static String get hintBio => LocaleController.isArabic
      ? 'أخبر العالم قليلاً عن نفسك…'
      : 'Tell the world a little about yourself…';
  static String get hintCity =>
      LocaleController.isArabic ? 'الجزائر' : 'Algiers';
  static String get hintHeight => '175';
  static String get hintSkills => LocaleController.isArabic
      ? 'تمثيل، رقص، عربية…'
      : 'Acting, Dance, Arabic…';
  static String get hintCompanyName => LocaleController.isArabic
      ? 'أطلس فيلمز للإنتاج'
      : 'Atlas Films Production';

  static String get autoReply1 => LocaleController.isArabic
      ? 'شكراً لتواصلك، سأرد عليك قريباً!'
      : "Thanks for reaching out, I'll get back to you shortly!";
  static String get autoReply2 => LocaleController.isArabic
      ? 'رائع، أتطلّع لذلك.'
      : 'Sounds great, looking forward to it.';
  static String get autoReply3 => LocaleController.isArabic
      ? 'بالتأكيد — دعني أتحقق من جدولي وأؤكّد.'
      : 'Sure thing — let me check my schedule and confirm.';
  static String get autoReply4 => LocaleController.isArabic
      ? 'مثالي، يناسبني ذلك.'
      : 'Perfect, that works on my end.';
  static String get autoReply5 => LocaleController.isArabic
      ? 'حسناً، شكراً على التحديث!'
      : 'Got it, thank you for the update!';
  static String get autoReply6 => LocaleController.isArabic
      ? 'بالتأكيد، أنا متاح لذلك.'
      : "Absolutely, I'm available for that.";
  static String get autoReply7 => LocaleController.isArabic
      ? 'شكراً جزيلاً، إلى اللقاء قريباً!'
      : 'Merci beaucoup, à très bientôt !';
  static String get autoReply8 => LocaleController.isArabic
      ? 'تم — سأرسل المزيد من التفاصيل قريباً.'
      : "Noted — I'll send more details soon.";

  static List<String> get autoReplies => [
        autoReply1,
        autoReply2,
        autoReply3,
        autoReply4,
        autoReply5,
        autoReply6,
        autoReply7,
        autoReply8,
      ];
}
