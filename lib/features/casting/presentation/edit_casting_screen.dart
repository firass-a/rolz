import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/providers.dart';

/// Pre-filled editor for an existing casting — mirrors [PostCastingScreen]'s
/// fields (plus a status control) and saves back through
/// [castingRepositoryProvider.update] instead of creating a new record.
class EditCastingScreen extends ConsumerStatefulWidget {
  const EditCastingScreen({super.key, required this.id});

  final String id;

  @override
  ConsumerState<EditCastingScreen> createState() => _EditCastingScreenState();
}

class _EditCastingScreenState extends ConsumerState<EditCastingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _roleController = TextEditingController();
  final _cityController = TextEditingController();
  final _salaryController = TextEditingController();
  final _descriptionController = TextEditingController();

  TalentCategory _category = TalentCategory.actor;
  CastingType _type = CastingType.film;
  CastingStatus _status = CastingStatus.open;
  DateTime _deadline = DateTime.now().add(const Duration(days: 14));
  bool _submitting = false;
  bool _hydrated = false;
  CastingModel? _original;

  @override
  void dispose() {
    _titleController.dispose();
    _roleController.dispose();
    _cityController.dispose();
    _salaryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _hydrate(CastingModel casting) {
    if (_hydrated) return;
    _hydrated = true;
    _original = casting;
    _titleController.text = casting.title;
    _roleController.text = casting.role;
    _cityController.text = casting.city;
    _salaryController.text = casting.salary > 0 ? casting.salary.toStringAsFixed(0) : '';
    _descriptionController.text = casting.description;
    _category = casting.category;
    _type = casting.type;
    _status = casting.status;
    _deadline = casting.applicationDeadline;
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
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
    if (!_formKey.currentState!.validate() || _original == null) return;

    setState(() => _submitting = true);

    final updated = _original!.copyWith(
      title: _titleController.text.trim(),
      role: _roleController.text.trim(),
      category: _category,
      type: _type,
      city: _cityController.text.trim().isEmpty ? _original!.city : _cityController.text.trim(),
      salary: double.tryParse(_salaryController.text.trim()) ?? 0,
      description: _descriptionController.text.trim(),
      status: _status,
      applicationDeadline: _deadline,
    );

    await ref.read(castingRepositoryProvider).update(updated);

    if (!mounted) return;
    setState(() => _submitting = false);
    context.showSnack('Casting updated successfully!');
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final casting = ref.watch(castingByIdProvider(widget.id));

    if (casting == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: const CustomAppBar(title: 'Edit Casting'),
        body: const Center(
          child: ErrorState(
            icon: Iconsax.briefcase,
            title: 'Casting Not Found',
            subtitle: 'This casting may have been removed.',
          ),
        ),
      );
    }

    final recruiter = ref.watch(currentRecruiterProvider);
    if (recruiter == null || recruiter.id != casting.recruiterId) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: const CustomAppBar(title: 'Edit Casting'),
        body: const Center(
          child: ErrorState(
            icon: Iconsax.lock,
            title: 'Not Authorized',
            subtitle: 'You can only edit castings you\'ve posted yourself.',
          ),
        ),
      );
    }

    _hydrate(casting);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Edit Casting'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Update the details below — changes go live immediately.',
                  style: AppTextStyles.bodyMuted,
                ).animate().fadeIn(duration: 300.ms),
                const SizedBox(height: AppSpacing.xl),
                _Field(label: 'Casting Title', controller: _titleController, hint: 'e.g. Lead Actress — Feature Film'),
                const SizedBox(height: AppSpacing.lg),
                _Field(label: 'Role', controller: _roleController, hint: 'e.g. Lead role, supporting role…'),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: _Dropdown<TalentCategory>(
                        label: 'Category',
                        value: _category,
                        items: TalentCategory.values,
                        labelOf: (c) => c.label,
                        onChanged: (v) => setState(() => _category = v),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _Dropdown<CastingType>(
                        label: 'Type',
                        value: _type,
                        items: CastingType.values,
                        labelOf: (c) => c.label,
                        onChanged: (v) => setState(() => _type = v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                _Dropdown<CastingStatus>(
                  label: 'Status',
                  value: _status,
                  items: CastingStatus.values.where((s) => s != CastingStatus.archived).toList(),
                  labelOf: (s) => s.label,
                  onChanged: (v) => setState(() => _status = v),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: _Field(label: 'City', controller: _cityController, hint: 'Algiers'),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _Field(
                        label: 'Salary (optional)',
                        controller: _salaryController,
                        hint: '80000',
                        keyboardType: TextInputType.number,
                        required: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('Application Deadline', style: AppTextStyles.caption.copyWith(letterSpacing: 0.4)),
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
                  label: 'Description',
                  controller: _descriptionController,
                  hint: 'Describe the role, requirements and shoot details…',
                  maxLines: 5,
                ),
                const SizedBox(height: AppSpacing.xxl),
                PremiumButton.primary(
                  label: 'Save Changes',
                  fullWidth: true,
                  isLoading: _submitting,
                  icon: Iconsax.tick_circle,
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
          validator: required ? (v) => (v == null || v.trim().isEmpty) ? 'Required' : null : null,
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
