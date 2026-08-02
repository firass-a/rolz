import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/providers.dart';

const _uuid = Uuid();

/// A real (if intentionally simple) casting-creation form for recruiters —
/// title, category/type, location, compensation, description and a
/// deadline — that publishes straight into [castingProvider].
class PostCastingScreen extends ConsumerStatefulWidget {
  const PostCastingScreen({super.key});

  @override
  ConsumerState<PostCastingScreen> createState() => _PostCastingScreenState();
}

class _PostCastingScreenState extends ConsumerState<PostCastingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _roleController = TextEditingController();
  final _cityController = TextEditingController();
  final _salaryController = TextEditingController();
  final _descriptionController = TextEditingController();
  TalentCategory _category = TalentCategory.actor;
  CastingType _type = CastingType.film;
  DateTime _deadline = DateTime.now().add(const Duration(days: 14));
  bool _submitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _roleController.dispose();
    _cityController.dispose();
    _salaryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: AppColors.gold,
                onPrimary: const Color(0xFF14110A),
                surface: AppColors.card,
              ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _deadline = picked);
  }

  Future<void> _submit() async {
    context.dismissKeyboard();
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(currentUserProvider);
    final recruiter = user == null ? null : ref.read(recruiterByUserIdProvider(user.id));
    if (recruiter == null) {
      context.showSnack(AppStrings.onlyRecruiterCanPost, isError: true);
      return;
    }

    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 500));

    final now = DateTime.now();
    final casting = CastingModel(
      id: 'casting-${_uuid.v4().substring(0, 8)}',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      role: _roleController.text.trim(),
      category: _category,
      type: _type,
      recruiterId: recruiter.id,
      city: _cityController.text.trim().isEmpty ? recruiter.city : _cityController.text.trim(),
      country: recruiter.country,
      salary: double.tryParse(_salaryController.text.trim()) ?? 0,
      status: CastingStatus.open,
      applicationDeadline: _deadline,
      shootStartDate: _deadline.add(const Duration(days: 14)),
      shootEndDate: _deadline.add(const Duration(days: 28)),
      createdAt: now,
      updatedAt: now,
    );

    ref.read(castingProvider.notifier).create(casting);
    ref.read(recruiterProvider.notifier).incrementCastingCount(recruiter.id);

    if (!mounted) return;
    setState(() => _submitting = false);
    context.showSnack(AppStrings.castingPublished);
    context.go(RouteNames.castings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: AppStrings.postACasting, showBackButton: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xxl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.postCastingSubtitle,
                  style: AppTextStyles.bodyMuted,
                ).animate().fadeIn(duration: 400.ms),
                const SizedBox(height: AppSpacing.xl),
                _Field(label: AppStrings.castingTitle, controller: _titleController, hint: AppStrings.castingTitleHint),
                const SizedBox(height: AppSpacing.lg),
                _Field(label: AppStrings.castingRole, controller: _roleController, hint: AppStrings.roleHint),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: _Dropdown<TalentCategory>(
                        label: AppStrings.category,
                        value: _category,
                        items: TalentCategory.values,
                        labelOf: (c) => c.label,
                        onChanged: (v) => setState(() => _category = v),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _Dropdown<CastingType>(
                        label: AppStrings.type,
                        value: _type,
                        items: CastingType.values,
                        labelOf: (c) => c.label,
                        onChanged: (v) => setState(() => _type = v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: _Field(label: AppStrings.city, controller: _cityController, hint: AppStrings.cityHint),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _Field(
                        label: AppStrings.salaryOptional,
                        controller: _salaryController,
                        hint: '80000',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(AppStrings.applicationDeadline, style: AppTextStyles.caption.copyWith(letterSpacing: 0.4)),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: _pickDeadline,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md + 2),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: AppRadius.radiusMd,
                      border: Border.all(color: AppColors.border, width: 1.4),
                    ),
                    child: Row(
                      children: [
                        const Icon(Iconsax.calendar, size: 18, color: AppColors.textMuted),
                        const SizedBox(width: AppSpacing.sm),
                        Text(Formatters.formatDate(_deadline), style: AppTextStyles.input),
                        const Spacer(),
                        const Icon(Iconsax.arrow_right_3, size: 14, color: AppColors.textMuted),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _Field(
                  label: AppStrings.description,
                  controller: _descriptionController,
                  hint: AppStrings.castingDescriptionHint,
                  maxLines: 5,
                ),
                const SizedBox(height: AppSpacing.xxl),
                PremiumButton.primary(
                  label: AppStrings.publishCasting,
                  fullWidth: true,
                  isLoading: _submitting,
                  icon: Iconsax.send_2,
                  onPressed: _submit,
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
    this.maxLines = 1,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;

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
          validator: (v) => (v == null || v.trim().isEmpty) ? AppStrings.required : null,
        ),
      ],
    );
  }
}

class _Dropdown<T> extends StatelessWidget {
  const _Dropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.labelOf,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<T> items;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption.copyWith(letterSpacing: 0.4)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.radiusMd,
            border: Border.all(color: AppColors.border, width: 1.4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              dropdownColor: AppColors.cardElevated,
              icon: const Icon(Iconsax.arrow_down_1, size: 16, color: AppColors.textMuted),
              style: AppTextStyles.input,
              onChanged: (v) {
                if (v != null) onChanged(v);
              },
              items: items
                  .map((item) => DropdownMenuItem<T>(value: item, child: Text(labelOf(item))))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
