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
import '../../../shared/providers/providers.dart';

/// Luxury sign-in form: email/password, a forgot-password link, one-tap
/// demo logins for each role, and a visible reminder of the demo
/// credentials so reviewers never get stuck at the door.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _lastShownError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    context.dismissKeyboard();
    if (!_formKey.currentState!.validate()) return;
    ref.read(authProvider.notifier).login(_emailController.text.trim(), _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.error != null && next.error != _lastShownError) {
        _lastShownError = next.error;
        context.showSnack(next.error!, isError: true);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.xl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.xxl),
                Text(
                  AppStrings.appName,
                  style: AppTextStyles.goldLabel.copyWith(fontSize: 13, letterSpacing: 3),
                ).animate().fadeIn(duration: 400.ms),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Welcome Back',
                  style: AppTextStyles.heroTitleCompact,
                ).animate().fadeIn(delay: 80.ms, duration: 450.ms).slideY(begin: 0.1, end: 0),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Sign in to continue your casting journey.',
                  style: AppTextStyles.bodyMuted,
                ).animate().fadeIn(delay: 140.ms, duration: 450.ms),
                const SizedBox(height: AppSpacing.xxl),
                _LabeledField(
                  label: AppStrings.email,
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    style: AppTextStyles.input,
                    decoration: const InputDecoration(
                      hintText: 'you@example.com',
                      prefixIcon: Icon(Iconsax.sms),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Enter your email';
                      if (!value.trim().isValidEmail) return 'Enter a valid email';
                      return null;
                    },
                  ),
                ).animate().fadeIn(delay: 180.ms, duration: 450.ms).slideY(begin: 0.08, end: 0),
                const SizedBox(height: AppSpacing.lg),
                _LabeledField(
                  label: AppStrings.password,
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    style: AppTextStyles.input,
                    onFieldSubmitted: (_) => _submit(),
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      prefixIcon: const Icon(Iconsax.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Iconsax.eye_slash : Iconsax.eye),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Enter your password';
                      return null;
                    },
                  ),
                ).animate().fadeIn(delay: 220.ms, duration: 450.ms).slideY(begin: 0.08, end: 0),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.push(RouteNames.forgotPassword),
                    child: Text(AppStrings.forgotPassword, style: AppTextStyles.buttonSmall.copyWith(color: AppColors.gold)),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                PremiumButton.primary(
                  label: AppStrings.login,
                  fullWidth: true,
                  isLoading: auth.isLoading,
                  onPressed: _submit,
                ).animate().fadeIn(delay: 260.ms, duration: 450.ms),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: Text('or try a demo account', style: AppTextStyles.caption),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: _DemoChip(
                        icon: Iconsax.user,
                        label: 'Talent',
                        onTap: auth.isLoading ? null : () => ref.read(authProvider.notifier).loginAsTalent(),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _DemoChip(
                        icon: Iconsax.briefcase,
                        label: 'Recruiter',
                        onTap: auth.isLoading ? null : () => ref.read(authProvider.notifier).loginAsRecruiter(),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _DemoChip(
                        icon: Iconsax.shield_tick,
                        label: 'Admin',
                        onTap: auth.isLoading ? null : () => ref.read(authProvider.notifier).loginAsAdmin(),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 320.ms, duration: 450.ms),
                const SizedBox(height: AppSpacing.lg),
                GlassContainer(
                  borderRadius: AppRadius.radiusMd,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Iconsax.info_circle, size: 15, color: AppColors.gold),
                          const SizedBox(width: 6),
                          Text(
                            AppStrings.demoCredentialsTitle,
                            style: AppTextStyles.buttonSmall.copyWith(color: AppColors.gold),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(AppStrings.demoTalentHint, style: AppTextStyles.caption),
                      const SizedBox(height: 2),
                      Text(AppStrings.demoRecruiterHint, style: AppTextStyles.caption),
                      const SizedBox(height: 2),
                      Text(AppStrings.demoAdminHint, style: AppTextStyles.caption),
                    ],
                  ),
                ).animate().fadeIn(delay: 380.ms, duration: 450.ms),
                const SizedBox(height: AppSpacing.xl),
                Center(
                  child: TextButton(
                    onPressed: auth.isLoading ? null : () => ref.read(authProvider.notifier).continueAsGuest(),
                    child: Text(
                      AppStrings.continueAsGuest,
                      style: AppTextStyles.buttonSmall.copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(AppStrings.dontHaveAccount, style: AppTextStyles.bodySmall),
                      TextButton(
                        onPressed: () => context.push(RouteNames.register),
                        child: Text(
                          AppStrings.register,
                          style: AppTextStyles.buttonSmall.copyWith(color: AppColors.gold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption.copyWith(letterSpacing: 0.4)),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

class _DemoChip extends StatelessWidget {
  const _DemoChip({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: AppRadius.radiusMd,
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: AppColors.gold),
            const SizedBox(height: 6),
            Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}
