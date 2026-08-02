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

/// App preferences: notifications, privacy and a bit of "about" chrome,
/// plus the always-important sign-out action. Backed by [settingsProvider]
/// for the toggles and [authProvider] for account actions.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final auth = ref.watch(authProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: AppStrings.settings),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxxl),
        children: [
          _SectionLabel(AppStrings.preferences),
          _SettingsCard(
            children: [
              _SwitchRow(
                icon: Iconsax.notification,
                label: AppStrings.pushNotifications,
                value: settings.notificationsEnabled,
                onChanged: (_) => notifier.toggleNotifications(),
              ),
              _SwitchRow(
                icon: Iconsax.lock,
                label: AppStrings.privateProfile,
                value: settings.privacyPrivateProfile,
                onChanged: (_) => notifier.togglePrivateProfile(),
              ),
              _NavRow(
                icon: Iconsax.global,
                label: AppStrings.language,
                value: settings.language == AppLanguage.ar
                    ? AppStrings.languageArabic
                    : AppStrings.languageEnglish,
                onTap: () => notifier.setLanguage(
                  settings.language == AppLanguage.en ? AppLanguage.ar : AppLanguage.en,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          _SectionLabel(AppStrings.support),
          _SettingsCard(
            children: [
              _NavRow(
                icon: Iconsax.info_circle,
                label: AppStrings.aboutKastRolz,
                value: 'v1.0.0',
                onTap: () => context.push(RouteNames.about),
              ),
              _NavRow(
                icon: Iconsax.sms,
                label: AppStrings.contactUs,
                onTap: () => context.push(RouteNames.contact),
              ),
              _NavRow(
                icon: Iconsax.document_text,
                label: AppStrings.termsOfService,
                onTap: () => context.push(RouteNames.terms),
              ),
              _NavRow(
                icon: Iconsax.shield_tick,
                label: AppStrings.privacyPolicy,
                onTap: () => context.push(RouteNames.privacy),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          if (auth.isAuthenticated || auth.isGuest)
            PremiumButton.danger(
              label: auth.isGuest ? AppStrings.exitGuestMode : AppStrings.logout,
              fullWidth: true,
              icon: Iconsax.logout,
              onPressed: () => ref.read(authProvider.notifier).logout(),
            ),
        ].animate(interval: 40.ms).fadeIn(duration: 250.ms),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm, left: 4),
      child: Text(label.toUpperCase(), style: AppTextStyles.overline),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: children.asMap().entries.expand((entry) {
          final isLast = entry.key == children.length - 1;
          return [
            entry.value,
            if (!isLast) const Divider(height: 1, indent: AppSpacing.lg, endIndent: AppSpacing.lg),
          ];
        }).toList(),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({required this.icon, required this.label, required this.value, required this.onChanged});

  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        secondary: Icon(icon, size: 20, color: AppColors.gold),
        title: Text(label, style: AppTextStyles.body),
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  const _NavRow({required this.icon, required this.label, this.value, this.onTap});

  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        leading: Icon(icon, size: 20, color: AppColors.gold),
        title: Text(label, style: AppTextStyles.body),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (value != null) ...[
              Text(value!, style: AppTextStyles.bodySmall),
              const SizedBox(width: 6),
            ],
            Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? Iconsax.arrow_left_3
                  : Iconsax.arrow_right_3,
              size: 15,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
