import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/providers/providers.dart';

/// Email in, reset link "sent" (simulated) out. A small, self-contained
/// two-state flow: form → success confirmation.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _sent = false;
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    context.dismissKeyboard();
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    final success = await ref.read(authProvider.notifier).forgotPassword(_emailController.text.trim());
    if (!mounted) return;
    setState(() {
      _submitting = false;
      _sent = success;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: _sent ? _SuccessView(email: _emailController.text.trim()) : _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.card,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
              ),
              child: const Icon(Iconsax.key, size: 26, color: AppColors.gold),
            ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.85, 0.85), end: const Offset(1, 1)),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Forgot Password?',
              style: AppTextStyles.heroTitleCompact,
            ).animate().fadeIn(delay: 80.ms, duration: 400.ms),
            const SizedBox(height: AppSpacing.sm),
            Text(
              "Enter the email linked to your account and we'll send you a reset link.",
              style: AppTextStyles.bodyMuted,
            ).animate().fadeIn(delay: 140.ms, duration: 400.ms),
            const SizedBox(height: AppSpacing.xxl),
            Text('Email', style: AppTextStyles.caption.copyWith(letterSpacing: 0.4)),
            const SizedBox(height: 6),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              style: AppTextStyles.input,
              onFieldSubmitted: (_) => _submit(),
              decoration: const InputDecoration(hintText: 'you@example.com', prefixIcon: Icon(Iconsax.sms)),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Enter your email';
                if (!value.trim().isValidEmail) return 'Enter a valid email';
                return null;
              },
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
            const SizedBox(height: AppSpacing.xxl),
            PremiumButton.primary(
              label: 'Send Reset Link',
              fullWidth: true,
              isLoading: _submitting,
              onPressed: _submit,
            ).animate().fadeIn(delay: 260.ms, duration: 400.ms),
          ],
        ),
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 88,
            height: 88,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [AppColors.success.withValues(alpha: 0.18), AppColors.success.withValues(alpha: 0)],
              ),
            ),
            child: Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.card,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.success.withValues(alpha: 0.5)),
              ),
              child: const Icon(Iconsax.tick_circle, size: 30, color: AppColors.success),
            ),
          ).animate().fadeIn(duration: 400.ms).scale(
                begin: const Offset(0.7, 0.7),
                end: const Offset(1, 1),
                curve: Curves.easeOutBack,
                duration: 500.ms,
              ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Check Your Email',
            style: AppTextStyles.sectionTitle,
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 120.ms, duration: 400.ms),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'If an account exists for\n$email, a reset link is on its way.',
            style: AppTextStyles.bodyMuted,
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 180.ms, duration: 400.ms),
          const SizedBox(height: AppSpacing.xxl),
          PremiumButton.secondary(
            label: 'Back to Sign In',
            fullWidth: true,
            onPressed: () => context.pop(),
          ).animate().fadeIn(delay: 240.ms, duration: 400.ms),
        ],
      ),
    );
  }
}
