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
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/providers.dart';
import 'register_screen.dart';

class _RoleOption {
  const _RoleOption({
    required this.role,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final UserRole role;
  final IconData icon;
  final String title;
  final String subtitle;
}

const _options = [
  _RoleOption(
    role: UserRole.talent,
    icon: Iconsax.user,
    title: AppStrings.roleTalent,
    subtitle: AppStrings.roleTalentSubtitle,
  ),
  _RoleOption(
    role: UserRole.recruiter,
    icon: Iconsax.briefcase,
    title: AppStrings.roleRecruiter,
    subtitle: AppStrings.roleRecruiterSubtitle,
  ),
  _RoleOption(
    role: UserRole.guest,
    icon: Iconsax.eye,
    title: 'Just Browsing',
    subtitle: 'Explore KAST-ROLZ with limited access',
  ),
];

/// Three elegant role cards — Talent, Recruiter, Guest. When arriving from
/// [RegisterScreen] (via [draft]), picking Talent/Recruiter finalises
/// account creation; picking Guest (from anywhere) just drops the user
/// straight into guest browsing.
class ChooseRoleScreen extends ConsumerStatefulWidget {
  const ChooseRoleScreen({super.key, this.draft});

  final RegisterDraft? draft;

  @override
  ConsumerState<ChooseRoleScreen> createState() => _ChooseRoleScreenState();
}

class _ChooseRoleScreenState extends ConsumerState<ChooseRoleScreen> {
  UserRole? _selected;

  Future<void> _continue() async {
    final role = _selected;
    if (role == null) return;

    if (role == UserRole.guest) {
      ref.read(authProvider.notifier).continueAsGuest();
      return;
    }

    final draft = widget.draft;
    if (draft == null) {
      context.showSnack('Please create an account first.', isError: true);
      context.push(RouteNames.register);
      return;
    }

    ref.read(authProvider.notifier).selectRole(role);
    await ref.read(authProvider.notifier).register(
          firstName: draft.firstName,
          lastName: draft.lastName,
          email: draft.email,
          password: draft.password,
          role: role,
        );

    if (!mounted) return;
    final error = ref.read(authProvider).error;
    if (error != null) {
      context.showSnack(error, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.chooseRole,
                style: AppTextStyles.heroTitleCompact,
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'You can always change this later from your profile.',
                style: AppTextStyles.bodyMuted,
              ).animate().fadeIn(delay: 80.ms, duration: 400.ms),
              const SizedBox(height: AppSpacing.xxl),
              Expanded(
                child: ListView.separated(
                  itemCount: _options.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final option = _options[index];
                    final selected = _selected == option.role;
                    return _RoleCard(
                      option: option,
                      selected: selected,
                      onTap: () => setState(() => _selected = option.role),
                    ).animate().fadeIn(delay: (140 + index * 80).ms, duration: 400.ms).slideY(begin: 0.1, end: 0);
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              PremiumButton.primary(
                label: AppStrings.getStarted,
                fullWidth: true,
                isLoading: auth.isLoading,
                onPressed: _selected == null ? null : _continue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({required this.option, required this.selected, required this.onTap});

  final _RoleOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      onTap: onTap,
      borderColor: selected ? AppColors.gold : AppColors.border,
      color: selected ? AppColors.gold.withValues(alpha: 0.08) : AppColors.card,
      elevated: selected,
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.gold : AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: selected ? AppColors.gold : AppColors.border),
            ),
            child: Icon(option.icon, size: 24, color: selected ? const Color(0xFF14110A) : AppColors.gold),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(option.title, style: AppTextStyles.cardTitle),
                const SizedBox(height: 2),
                Text(option.subtitle, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? AppColors.gold : Colors.transparent,
              border: Border.all(color: selected ? AppColors.gold : AppColors.borderLight, width: 1.6),
            ),
            child: selected ? const Icon(Icons.check_rounded, size: 15, color: Color(0xFF14110A)) : null,
          ),
        ],
      ),
    );
  }
}
