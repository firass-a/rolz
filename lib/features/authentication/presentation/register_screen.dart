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

/// The form data collected on this screen, carried forward to
/// [RouteNames.chooseRole] via `extra` so the account is only created once
/// the user has also picked a role.
class RegisterDraft {
  const RegisterDraft({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String password;
}

/// Full name, email, password + confirmation. On success the collected
/// details are handed to the role-selection screen, which finalises
/// account creation once a role has been chosen.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    context.dismissKeyboard();
    if (!_formKey.currentState!.validate()) return;

    final parts = _nameController.text.trim().split(RegExp(r'\s+'));
    final firstName = parts.first;
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    context.push(
      RouteNames.chooseRole,
      extra: RegisterDraft(
        firstName: firstName,
        lastName: lastName,
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Account',
                  style: AppTextStyles.heroTitleCompact,
                ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Join KAST-ROLZ and start your next chapter.',
                  style: AppTextStyles.bodyMuted,
                ).animate().fadeIn(delay: 80.ms, duration: 400.ms),
                const SizedBox(height: AppSpacing.xxl),
                _Field(
                  label: 'Full Name',
                  controller: _nameController,
                  hint: 'Amina Sofiane',
                  icon: Iconsax.user,
                  textInputAction: TextInputAction.next,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter your name' : null,
                  delay: 120,
                ),
                const SizedBox(height: AppSpacing.lg),
                _Field(
                  label: AppStrings.email,
                  controller: _emailController,
                  hint: 'you@example.com',
                  icon: Iconsax.sms,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Enter your email';
                    if (!v.trim().isValidEmail) return 'Enter a valid email';
                    return null;
                  },
                  delay: 160,
                ),
                const SizedBox(height: AppSpacing.lg),
                _Field(
                  label: AppStrings.password,
                  controller: _passwordController,
                  hint: 'Minimum 6 characters',
                  icon: Iconsax.lock,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  onToggleObscure: () => setState(() => _obscurePassword = !_obscurePassword),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter a password';
                    if (v.length < 6) return 'At least 6 characters';
                    return null;
                  },
                  delay: 200,
                ),
                const SizedBox(height: AppSpacing.lg),
                _Field(
                  label: AppStrings.confirmPassword,
                  controller: _confirmController,
                  hint: 'Re-enter your password',
                  icon: Iconsax.lock,
                  obscureText: _obscureConfirm,
                  textInputAction: TextInputAction.done,
                  onToggleObscure: () => setState(() => _obscureConfirm = !_obscureConfirm),
                  onFieldSubmitted: (_) => _submit(),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Confirm your password';
                    if (v != _passwordController.text) return 'Passwords do not match';
                    return null;
                  },
                  delay: 240,
                ),
                const SizedBox(height: AppSpacing.xxl),
                PremiumButton.primary(
                  label: 'Continue',
                  fullWidth: true,
                  trailingIcon: Iconsax.arrow_right_3,
                  onPressed: _submit,
                ).animate().fadeIn(delay: 280.ms, duration: 400.ms),
                const SizedBox(height: AppSpacing.lg),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(AppStrings.alreadyHaveAccount, style: AppTextStyles.bodySmall),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          AppStrings.login,
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

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.textInputAction,
    this.onToggleObscure,
    this.onFieldSubmitted,
    this.validator,
    this.delay = 0,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final VoidCallback? onToggleObscure;
  final ValueChanged<String>? onFieldSubmitted;
  final String? Function(String?)? validator;
  final int delay;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption.copyWith(letterSpacing: 0.4)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          style: AppTextStyles.input,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            suffixIcon: onToggleObscure == null
                ? null
                : IconButton(
                    icon: Icon(obscureText ? Iconsax.eye_slash : Iconsax.eye),
                    onPressed: onToggleObscure,
                  ),
          ),
          validator: validator,
        ),
      ],
    ).animate().fadeIn(delay: delay.ms, duration: 400.ms).slideY(begin: 0.08, end: 0);
  }
}
