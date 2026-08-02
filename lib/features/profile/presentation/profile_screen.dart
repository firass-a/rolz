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
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/providers.dart';

/// Account hub: identity header, role-aware quick stats, and the primary
/// navigation into edit-profile, favorites, notifications, settings and
/// (for admins) the admin console — plus sign out.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: AppStrings.navProfile, showBackButton: false),
      body: auth.isGuest ? const _GuestProfile() : _AccountProfile(auth: auth),
    );
  }
}

class _AccountProfile extends ConsumerWidget {
  const _AccountProfile({required this.auth});

  final AuthState auth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = auth.user!;
    final settings = ref.watch(settingsProvider);
    final talent = user.role == UserRole.talent ? ref.watch(talentByUserIdProvider(user.id)) : null;
    final recruiter = user.role == UserRole.recruiter ? ref.watch(recruiterByUserIdProvider(user.id)) : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xxxl),
      child: Column(
        children: [
          KrAvatar(
            imageUrl: user.avatarUrl,
            initials: user.initials,
            size: KrAvatarSize.xl,
            verified: user.isVerified,
          ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.85, 0.85), end: const Offset(1, 1)),
          const SizedBox(height: AppSpacing.md),
          Text(
            recruiter?.companyName ?? user.fullName,
            style: AppTextStyles.sectionTitle,
          ).animate().fadeIn(delay: 80.ms, duration: 400.ms),
          const SizedBox(height: 4),
          Text(user.email, style: AppTextStyles.bodySmall).animate().fadeIn(delay: 120.ms, duration: 400.ms),
          const SizedBox(height: AppSpacing.sm),
          StatusBadge.gold(user.role.label, showDot: false).animate().fadeIn(delay: 160.ms, duration: 400.ms),
          const SizedBox(height: AppSpacing.xl),
          if (talent != null) ...[
            Row(
              children: [
                Expanded(child: KrStatCard(icon: Iconsax.star_1, value: Formatters.formatRating(talent.rating), label: AppStrings.rating, animateCounter: false)),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: KrStatCard(icon: Iconsax.eye, value: Formatters.formatCount(talent.viewCount), label: AppStrings.views, animateCounter: false)),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: KrStatCard(icon: Iconsax.medal_star, value: '${talent.yearsOfExperience}', label: AppStrings.yrsExp)),
              ],
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
            const SizedBox(height: AppSpacing.xl),
          ] else if (recruiter != null) ...[
            Row(
              children: [
                Expanded(child: KrStatCard(icon: Iconsax.briefcase, value: '${recruiter.castingCount}', label: AppStrings.castings)),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: KrStatCard(icon: Iconsax.crown_1, value: '${recruiter.hireCount}', label: AppStrings.hires)),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: KrStatCard(icon: Iconsax.star_1, value: Formatters.formatRating(recruiter.rating), label: AppStrings.rating, animateCounter: false)),
              ],
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
            const SizedBox(height: AppSpacing.xl),
          ],
          _LanguageToggle(
            isArabic: settings.language == AppLanguage.ar,
            onChanged: (arabic) => ref.read(settingsProvider.notifier).setLanguage(
                  arabic ? AppLanguage.ar : AppLanguage.en,
                  markChosen: false,
                ),
          ).animate().fadeIn(delay: 220.ms, duration: 400.ms),
          const SizedBox(height: AppSpacing.md),
          _MenuSection(
            items: [
              _MenuItem(icon: Iconsax.user_edit, label: AppStrings.editProfile, onTap: () => context.push(RouteNames.editProfile)),
              _MenuItem(icon: Iconsax.crown_1, label: AppStrings.pricing, onTap: () => context.push(RouteNames.pricing)),
              _MenuItem(icon: Iconsax.heart, label: AppStrings.favorites, onTap: () => context.push(RouteNames.favorites)),
              _MenuItem(icon: Iconsax.notification, label: AppStrings.notifications, onTap: () => context.push(RouteNames.notifications)),
              if (user.role == UserRole.admin)
                _MenuItem(icon: Iconsax.shield_tick, label: AppStrings.adminConsole, onTap: () => context.push(RouteNames.admin)),
              _MenuItem(icon: Iconsax.setting_2, label: AppStrings.settings, onTap: () => context.push(RouteNames.settings)),
            ],
          ).animate().fadeIn(delay: 260.ms, duration: 400.ms),
          const SizedBox(height: AppSpacing.md),
          _MenuSection(
            items: [
              _MenuItem(icon: Iconsax.info_circle, label: AppStrings.aboutKastRolz, onTap: () => context.push(RouteNames.about)),
              _MenuItem(icon: Iconsax.sms, label: AppStrings.contactUs, onTap: () => context.push(RouteNames.contact)),
              _MenuItem(icon: Iconsax.document_text, label: AppStrings.termsOfService, onTap: () => context.push(RouteNames.terms)),
              _MenuItem(icon: Iconsax.shield_tick, label: AppStrings.privacyPolicy, onTap: () => context.push(RouteNames.privacy)),
            ],
          ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
          const SizedBox(height: AppSpacing.xl),
          PremiumButton.danger(
            label: AppStrings.logout,
            fullWidth: true,
            icon: Iconsax.logout,
            onPressed: () => _confirmLogout(context, ref),
          ).animate().fadeIn(delay: 340.ms, duration: 400.ms),
        ],
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.confirmLogoutTitle),
        content: Text(AppStrings.confirmLogoutBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(AppStrings.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppStrings.logout, style: const TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      ref.read(authProvider.notifier).logout();
    }
  }
}

class _GuestProfile extends ConsumerWidget {
  const _GuestProfile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, AppSpacing.xxxl),
      child: Column(
        children: [
          const KrAvatar(initials: 'G', size: KrAvatarSize.xl),
          const SizedBox(height: AppSpacing.lg),
          Text(AppStrings.browsingAsGuest, style: AppTextStyles.sectionTitle, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.sm),
          Text(
            AppStrings.guestCtaBody,
            style: AppTextStyles.bodyMuted,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          _LanguageToggle(
            isArabic: settings.language == AppLanguage.ar,
            onChanged: (arabic) => ref.read(settingsProvider.notifier).setLanguage(
                  arabic ? AppLanguage.ar : AppLanguage.en,
                  markChosen: false,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          _MenuSection(
            items: [
              _MenuItem(icon: Iconsax.info_circle, label: AppStrings.aboutKastRolz, onTap: () => context.push(RouteNames.about)),
              _MenuItem(icon: Iconsax.sms, label: AppStrings.contactUs, onTap: () => context.push(RouteNames.contact)),
              _MenuItem(icon: Iconsax.document_text, label: AppStrings.termsOfService, onTap: () => context.push(RouteNames.terms)),
              _MenuItem(icon: Iconsax.shield_tick, label: AppStrings.privacyPolicy, onTap: () => context.push(RouteNames.privacy)),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          PremiumButton.primary(
            label: AppStrings.register,
            fullWidth: true,
            onPressed: () => context.push(RouteNames.register),
          ),
          const SizedBox(height: AppSpacing.md),
          PremiumButton.secondary(
            label: AppStrings.login,
            fullWidth: true,
            onPressed: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}

class _LanguageToggle extends StatelessWidget {
  const _LanguageToggle({required this.isArabic, required this.onChanged});

  final bool isArabic;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: SwitchListTile(
          value: isArabic,
          onChanged: onChanged,
          secondary: const Icon(Iconsax.global, size: 20, color: AppColors.gold),
          title: Text(AppStrings.language, style: AppTextStyles.body),
          subtitle: Text(
            isArabic ? AppStrings.languageArabic : AppStrings.languageEnglish,
            style: AppTextStyles.bodySmall,
          ),
          activeThumbColor: AppColors.gold,
          contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        ),
      ),
    );
  }
}

class _MenuItem {
  const _MenuItem({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
}

class _MenuSection extends StatelessWidget {
  const _MenuSection({required this.items});

  final List<_MenuItem> items;

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: items.asMap().entries.map((entry) {
          final isLast = entry.key == items.length - 1;
          final item = entry.value;
          return Column(
            children: [
              Material(
                color: Colors.transparent,
                child: ListTile(
                  onTap: item.onTap,
                  leading: Icon(item.icon, size: 20, color: AppColors.gold),
                  title: Text(item.label, style: AppTextStyles.body),
                  trailing: Icon(
                    Directionality.of(context) == TextDirection.rtl
                        ? Iconsax.arrow_left_3
                        : Iconsax.arrow_right_3,
                    size: 16,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              if (!isLast) const Divider(height: 1, indent: AppSpacing.lg, endIndent: AppSpacing.lg),
            ],
          );
        }).toList(),
      ),
    );
  }
}
