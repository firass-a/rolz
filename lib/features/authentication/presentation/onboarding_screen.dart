import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/providers/providers.dart';

class _OnboardPage {
  const _OnboardPage({required this.icon, required this.title, required this.body});
  final IconData icon;
  final String title;
  final String body;
}

const _pages = [
  _OnboardPage(
    icon: Iconsax.discover,
    title: AppStrings.onboardTitle1,
    body: AppStrings.onboardBody1,
  ),
  _OnboardPage(
    icon: Iconsax.camera,
    title: AppStrings.onboardTitle2,
    body: AppStrings.onboardBody2,
  ),
  _OnboardPage(
    icon: Iconsax.shield_tick,
    title: AppStrings.onboardTitle3,
    body: AppStrings.onboardBody3,
  ),
];

/// Three-page introduction to KAST-ROLZ: discover opportunities, get
/// discovered/post castings, book roles with confidence. Finishing the
/// flow (or skipping it) marks onboarding complete and hands off to the
/// router, which sends unauthenticated users to sign in.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  bool get _isLast => _page == _pages.length - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _finish() {
    ref.read(authProvider.notifier).completeOnboarding();
    context.go(RouteNames.login);
  }

  void _next() {
    if (_isLast) {
      _finish();
      return;
    }
    _controller.nextPage(duration: 350.ms, curve: Curves.easeOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                child: TextButton(
                  onPressed: _isLast ? null : _finish,
                  child: Text(
                    AppStrings.skip,
                    style: AppTextStyles.buttonSmall.copyWith(
                      color: _isLast ? Colors.transparent : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, index) => _OnboardPageView(page: _pages[index]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (i) {
                  final active = i == _page;
                  return AnimatedContainer(
                    duration: 250.ms,
                    curve: Curves.easeOut,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: active ? AppColors.gold : AppColors.border,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xl),
              child: PremiumButton.primary(
                label: _isLast ? AppStrings.getStarted : AppStrings.next,
                fullWidth: true,
                trailingIcon: _isLast ? null : Iconsax.arrow_right_3,
                onPressed: _next,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardPageView extends StatelessWidget {
  const _OnboardPageView({required this.page});

  final _OnboardPage page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 132,
            height: 132,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [AppColors.gold.withValues(alpha: 0.18), AppColors.gold.withValues(alpha: 0)],
              ),
            ),
            child: Container(
              width: 92,
              height: 92,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.card,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
                boxShadow: AppShadows.goldSoft,
              ),
              child: Icon(page.icon, size: 40, color: AppColors.gold),
            ),
          ).animate().fadeIn(duration: 500.ms).scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1, 1),
                curve: Curves.easeOutBack,
                duration: 550.ms,
              ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: AppTextStyles.heroTitleCompact,
          ).animate().fadeIn(delay: 120.ms, duration: 450.ms).slideY(begin: 0.15, end: 0, curve: Curves.easeOut),
          const SizedBox(height: AppSpacing.md),
          Text(
            page.body,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMuted,
          ).animate().fadeIn(delay: 220.ms, duration: 450.ms).slideY(begin: 0.15, end: 0, curve: Curves.easeOut),
        ],
      ),
    );
  }
}
