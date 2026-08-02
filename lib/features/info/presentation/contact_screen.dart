import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/widgets.dart';

/// Contact form + HQ details from https://kast-rolz-call.lovable.app/contact
class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    context.dismissKeyboard();
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _submitting = false);
    _nameController.clear();
    _emailController.clear();
    _messageController.clear();
    context.showSnack(AppStrings.messageSentThanks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: AppStrings.contactUs),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxxl),
        children: [
          Text(AppStrings.sayHello.toUpperCase(), style: AppTextStyles.overline)
              .animate()
              .fadeIn(duration: 300.ms),
          const SizedBox(height: AppSpacing.sm),
          Text(AppStrings.contact, style: AppTextStyles.heroTitleCompact)
              .animate()
              .fadeIn(delay: 40.ms, duration: 350.ms),
          const SizedBox(height: AppSpacing.sm),
          Text(AppStrings.contactIntro, style: AppTextStyles.bodyMuted)
              .animate()
              .fadeIn(delay: 80.ms, duration: 350.ms),
          const SizedBox(height: AppSpacing.xl),
          AnimatedCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppStrings.fullName, style: AppTextStyles.caption),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    style: AppTextStyles.input,
                    decoration: InputDecoration(
                      hintText: AppStrings.hintFirstName,
                      prefixIcon: const Icon(Iconsax.user),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? AppStrings.enterName : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(AppStrings.email, style: AppTextStyles.caption),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    style: AppTextStyles.input,
                    decoration: const InputDecoration(
                      hintText: 'you@example.com',
                      prefixIcon: Icon(Iconsax.sms),
                    ),
                    validator: (v) {
                      final value = v?.trim() ?? '';
                      if (value.isEmpty) return AppStrings.enterEmail;
                      if (!value.isValidEmail) return AppStrings.enterValidEmail;
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(AppStrings.yourMessage, style: AppTextStyles.caption),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _messageController,
                    minLines: 4,
                    maxLines: 6,
                    style: AppTextStyles.input,
                    decoration: InputDecoration(
                      hintText: AppStrings.hintContactMessage,
                      alignLabelWithHint: true,
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? AppStrings.hintContactMessage : null,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  PremiumButton.primary(
                    label: AppStrings.sendMessage,
                    fullWidth: true,
                    isLoading: _submitting,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(delay: 120.ms, duration: 350.ms),
          const SizedBox(height: AppSpacing.xl),
          _InfoTile(
            icon: Iconsax.sms,
            label: AppStrings.contactEmailLabel,
            value: AppStrings.contactEmailValue,
          ).animate().fadeIn(delay: 160.ms, duration: 350.ms),
          const SizedBox(height: AppSpacing.sm),
          _InfoTile(
            icon: Iconsax.location,
            label: AppStrings.contactHqLabel,
            value: AppStrings.contactHqValue,
            subtitle: AppStrings.contactExpanding,
          ).animate().fadeIn(delay: 200.ms, duration: 350.ms),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.subtitle,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: AppColors.gold),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.caption),
                const SizedBox(height: 2),
                Text(value, style: AppTextStyles.body),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!, style: AppTextStyles.bodySmall),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
