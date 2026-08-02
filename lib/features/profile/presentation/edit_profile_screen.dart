import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/providers.dart';

/// Edits the signed-in user's account — basic identity fields for everyone,
/// plus a role-aware section: talents get bio/city/skills/availability/
/// height, recruiters get company/city/bio. Saves through
/// [authProvider.updateProfile] (which itself keeps the linked talent or
/// recruiter record's shared fields in sync) plus a direct notifier update
/// for the role-specific fields it doesn't touch.
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();

  // Talent-only fields.
  final _cityController = TextEditingController();
  final _skillsController = TextEditingController();
  final _heightController = TextEditingController();
  AvailabilityStatus _availability = AvailabilityStatus.available;

  // Recruiter-only fields.
  final _companyNameController = TextEditingController();
  final _companyCityController = TextEditingController();

  bool _hydrated = false;
  bool _submitting = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _cityController.dispose();
    _skillsController.dispose();
    _heightController.dispose();
    _companyNameController.dispose();
    _companyCityController.dispose();
    super.dispose();
  }

  void _hydrate(UserModel user, TalentModel? talent, RecruiterModel? recruiter) {
    if (_hydrated) return;
    _hydrated = true;
    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _phoneController.text = user.phone;
    _bioController.text = user.bio;

    if (talent != null) {
      _cityController.text = talent.city;
      _skillsController.text = talent.skills.join(', ');
      _heightController.text = talent.heightCm > 0 ? talent.heightCm.toStringAsFixed(0) : '';
      _availability = talent.availability;
    }
    if (recruiter != null) {
      _companyNameController.text = recruiter.companyName;
      _companyCityController.text = recruiter.city;
    }
  }

  Future<void> _submit(UserModel user, TalentModel? talent, RecruiterModel? recruiter) async {
    context.dismissKeyboard();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);

    final updatedUser = user.copyWith(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      phone: _phoneController.text.trim(),
      bio: _bioController.text.trim(),
    );
    ref.read(authProvider.notifier).updateProfile(updatedUser);

    if (talent != null) {
      final refreshed = ref.read(talentByUserIdProvider(user.id)) ?? talent;
      final skills = _skillsController.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
      ref.read(talentProvider.notifier).update(refreshed.copyWith(
            city: _cityController.text.trim().isEmpty ? refreshed.city : _cityController.text.trim(),
            skills: skills,
            availability: _availability,
            heightCm: double.tryParse(_heightController.text.trim()) ?? refreshed.heightCm,
            updatedAt: DateTime.now(),
          ));
    }

    if (recruiter != null) {
      final refreshed = ref.read(recruiterByUserIdProvider(user.id)) ?? recruiter;
      ref.read(recruiterProvider.notifier).update(refreshed.copyWith(
            companyName: _companyNameController.text.trim().isEmpty ? refreshed.companyName : _companyNameController.text.trim(),
            city: _companyCityController.text.trim().isEmpty ? refreshed.city : _companyCityController.text.trim(),
          ));
    }

    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    setState(() => _submitting = false);
    context.showSnack(AppStrings.profileUpdated);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    if (user == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(title: AppStrings.editProfile),
        body: Center(
          child: EmptyState(
            icon: Iconsax.user_edit,
            title: AppStrings.signInRequired,
            subtitle: AppStrings.signInRequiredProfile,
          ),
        ),
      );
    }

    final talent = user.role == UserRole.talent ? ref.watch(talentByUserIdProvider(user.id)) : null;
    final recruiter = user.role == UserRole.recruiter ? ref.watch(recruiterByUserIdProvider(user.id)) : null;
    _hydrate(user, talent, recruiter);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: AppStrings.editProfile),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      KrAvatar(
                        imageUrl: user.avatarUrl,
                        initials: user.initials,
                        size: KrAvatarSize.xl,
                        verified: user.isVerified,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      GestureDetector(
                        onTap: () => context.showSnack(AppStrings.photoUploadComingSoon),
                        child: Text(AppStrings.changePhoto, style: AppTextStyles.buttonSmall.copyWith(color: AppColors.gold)),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms),
                const SizedBox(height: AppSpacing.xl),
                _SectionLabel(AppStrings.basicInformation),
                Row(
                  children: [
                    Expanded(child: _Field(label: AppStrings.firstName, controller: _firstNameController, hint: AppStrings.hintFirstName)),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(child: _Field(label: AppStrings.lastName, controller: _lastNameController, hint: AppStrings.hintLastName)),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                _Field(label: AppStrings.phone, controller: _phoneController, hint: AppStrings.hintPhone, keyboardType: TextInputType.phone, required: false),
                const SizedBox(height: AppSpacing.lg),
                _Field(label: AppStrings.bio, controller: _bioController, hint: AppStrings.hintBio, maxLines: 4, required: false),
                if (talent != null) ...[
                  const SizedBox(height: AppSpacing.xxl),
                  _SectionLabel(AppStrings.talentDetails),
                  Row(
                    children: [
                      Expanded(child: _Field(label: AppStrings.city, controller: _cityController, hint: AppStrings.hintCity, required: false)),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _Field(
                          label: AppStrings.heightCm,
                          controller: _heightController,
                          hint: AppStrings.hintHeight,
                          keyboardType: TextInputType.number,
                          required: false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _Field(
                    label: AppStrings.skillsCommaSeparated,
                    controller: _skillsController,
                    hint: AppStrings.hintSkills,
                    required: false,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(AppStrings.availability, style: AppTextStyles.caption.copyWith(letterSpacing: 0.4)),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    children: AvailabilityStatus.values
                        .map((status) => KrFilterChip(
                              label: status.label,
                              selected: _availability == status,
                              onTap: () => setState(() => _availability = status),
                            ))
                        .toList(),
                  ),
                ],
                if (recruiter != null) ...[
                  const SizedBox(height: AppSpacing.xxl),
                  _SectionLabel(AppStrings.companyDetails),
                  _Field(label: AppStrings.companyName, controller: _companyNameController, hint: AppStrings.hintCompanyName, required: false),
                  const SizedBox(height: AppSpacing.lg),
                  _Field(label: AppStrings.city, controller: _companyCityController, hint: AppStrings.hintCity, required: false),
                ],
                const SizedBox(height: AppSpacing.xxl),
                PremiumButton.primary(
                  label: AppStrings.saveChanges,
                  fullWidth: true,
                  isLoading: _submitting,
                  icon: Iconsax.tick_circle,
                  onPressed: () => _submit(user, talent, recruiter),
                ),
              ],
            ),
          ),
        ),
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
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Text(label.toUpperCase(), style: AppTextStyles.overline),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType,
    this.required = true,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption.copyWith(letterSpacing: 0.4)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: AppTextStyles.input,
          decoration: InputDecoration(hintText: hint),
          validator: required ? (v) => (v == null || v.trim().isEmpty) ? AppStrings.required : null : null,
        ),
      ],
    );
  }
}
