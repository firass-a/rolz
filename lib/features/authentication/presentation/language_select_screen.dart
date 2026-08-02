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

/// First screen of the app: pick English or Arabic before anything else.
class LanguageSelectScreen extends ConsumerWidget {
  const LanguageSelectScreen({super.key});

  Future<void> _select(BuildContext context, WidgetRef ref, AppLanguage language) async {
    await ref.read(settingsProvider.notifier).chooseLanguage(language);
    if (!context.mounted) return;
    context.go(RouteNames.splash);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(settingsProvider).language;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xxl, AppSpacing.xl, AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Center(child: KrLogo(size: 112))
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
              const SizedBox(height: AppSpacing.xl),
              Text(
                AppStrings.appName,
                textAlign: TextAlign.center,
                style: AppTextStyles.goldLabel.copyWith(fontSize: 14, letterSpacing: 4),
              ).animate().fadeIn(delay: 80.ms, duration: 400.ms),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                AppStrings.chooseLanguageTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.heroTitleCompact,
              ).animate().fadeIn(delay: 120.ms, duration: 400.ms),
              const SizedBox(height: AppSpacing.sm),
              Text(
                AppStrings.chooseLanguageSubtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMuted,
              ).animate().fadeIn(delay: 160.ms, duration: 400.ms),
              const SizedBox(height: AppSpacing.xxl),
              _LanguageCard(
                label: AppStrings.languageEnglish,
                subtitle: 'English',
                icon: Iconsax.global,
                selected: selected == AppLanguage.en,
                onTap: () => _select(context, ref, AppLanguage.en),
              ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.08, end: 0),
              const SizedBox(height: AppSpacing.md),
              _LanguageCard(
                label: AppStrings.languageArabic,
                subtitle: 'Arabic',
                icon: Iconsax.global,
                selected: selected == AppLanguage.ar,
                onTap: () => _select(context, ref, AppLanguage.ar),
              ).animate().fadeIn(delay: 260.ms, duration: 400.ms).slideY(begin: 0.08, end: 0),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: AppRadius.radiusLg,
          border: Border.all(
            color: selected ? AppColors.gold : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
          boxShadow: selected ? AppShadows.goldSoft : null,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.12),
                borderRadius: AppRadius.radiusMd,
              ),
              child: Icon(icon, color: AppColors.gold, size: 22),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.cardTitle),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle_rounded, color: AppColors.gold, size: 22),
          ],
        ),
      ),
    );
  }
}
