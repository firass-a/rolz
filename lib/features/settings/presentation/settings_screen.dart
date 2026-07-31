import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
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
      appBar: const CustomAppBar(title: 'Settings'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxxl),
        children: [
          const _SectionLabel('Preferences'),
          _SettingsCard(
            children: [
              _SwitchRow(
                icon: Iconsax.notification,
                label: 'Push Notifications',
                value: settings.notificationsEnabled,
                onChanged: (_) => notifier.toggleNotifications(),
              ),
              _SwitchRow(
                icon: Iconsax.lock,
                label: 'Private Profile',
                value: settings.privacyPrivateProfile,
                onChanged: (_) => notifier.togglePrivateProfile(),
              ),
              _NavRow(
                icon: Iconsax.global,
                label: 'Language',
                value: settings.language.label,
                onTap: () => notifier.setLanguage(settings.language.name == 'en' ? AppLanguage.fr : AppLanguage.en),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          const _SectionLabel('Support'),
          _SettingsCard(
            children: const [
              _NavRow(icon: Iconsax.message_question, label: 'Help & Support'),
              _NavRow(icon: Iconsax.document_text, label: 'Terms & Privacy Policy'),
              _NavRow(icon: Iconsax.info_circle, label: 'About KAST-ROLZ', value: 'v1.0.0'),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          if (auth.isAuthenticated || auth.isGuest)
            PremiumButton.danger(
              label: auth.isGuest ? 'Exit Guest Mode' : AppStrings.logout,
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
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      secondary: Icon(icon, size: 20, color: AppColors.gold),
      title: Text(label, style: AppTextStyles.body),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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
    return ListTile(
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
          const Icon(Iconsax.arrow_right_3, size: 15, color: AppColors.textMuted),
        ],
      ),
    );
  }
}
