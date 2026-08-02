import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/widgets.dart';

/// Cinematic entry point: a pure-black stage, the gold chameleon mark and
/// KAST-ROLZ wordmark scaling/fading into place, then the tagline. Once the
/// moment has played out we hand off to [RouteNames.home] — the router's
/// redirect guard picks the real destination (onboarding / login / home /
/// dashboard) based on the current auth state.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _scheduleHandoff();
  }

  Future<void> _scheduleHandoff() async {
    await Future.delayed(const Duration(milliseconds: 2600));
    if (!mounted) return;
    context.go(RouteNames.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const KrLogo(size: 128)
                .animate()
                .fadeIn(duration: 900.ms, curve: Curves.easeOut)
                .scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1, 1),
                  duration: 900.ms,
                  curve: Curves.easeOutBack,
                ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              AppStrings.appName,
              textAlign: TextAlign.center,
              style: AppTextStyles.heroTitle.copyWith(
                color: AppColors.gold,
                fontSize: 36,
                letterSpacing: 6,
              ),
            ).animate(delay: 350.ms).fadeIn(duration: 700.ms),
            const SizedBox(height: AppSpacing.lg),
            Container(width: 56, height: 1, color: AppColors.gold)
                .animate(delay: 550.ms)
                .fadeIn(duration: 500.ms)
                .scaleX(begin: 0, end: 1, curve: Curves.easeOut),
            const SizedBox(height: AppSpacing.lg),
            Text(
              AppStrings.appTagline,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMuted.copyWith(letterSpacing: 0.6),
            ).animate(delay: 950.ms).fadeIn(duration: 800.ms),
            const SizedBox(height: AppSpacing.xxxl),
            const KrLoadingIndicator(size: 22, strokeWidth: 2)
                .animate(delay: 1500.ms)
                .fadeIn(duration: 600.ms),
          ],
        ),
      ),
    );
  }
}
