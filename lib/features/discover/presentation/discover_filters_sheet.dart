/// Bottom sheet with the full talent discover filter set — gender, age,
/// height, languages, city, experience, verified-only, availability and
/// sort order. Edits a local draft and only commits to
/// [discoverFiltersProvider] when the admin taps "Apply Filters".
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/providers.dart';

const _kLanguagePool = ['English', 'French', 'Arabic', 'Kabyle', 'Spanish', 'Italian', 'German'];

Future<void> showDiscoverFiltersSheet(BuildContext context) {
  return showKrBottomSheet(
    context,
    builder: (context) => const DiscoverFiltersSheet(),
  );
}

class DiscoverFiltersSheet extends ConsumerStatefulWidget {
  const DiscoverFiltersSheet({super.key});

  @override
  ConsumerState<DiscoverFiltersSheet> createState() => _DiscoverFiltersSheetState();
}

class _DiscoverFiltersSheetState extends ConsumerState<DiscoverFiltersSheet> {
  late TalentFilters _draft;

  @override
  void initState() {
    super.initState();
    _draft = ref.read(discoverFiltersProvider).talentFilters;
  }

  void _update(TalentFilters Function(TalentFilters) fn) {
    setState(() => _draft = fn(_draft));
  }

  void _apply() {
    ref.read(discoverFiltersProvider.notifier).setTalentFilters(_draft);
    Navigator.of(context).pop();
  }

  void _clearAll() {
    setState(() => _draft = const TalentFilters());
  }

  @override
  Widget build(BuildContext context) {
    final cities = ref.watch(talentProvider).map((t) => t.city).where((c) => c.isNotEmpty).toSet().toList()..sort();

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.86),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.sm, AppSpacing.lg, 0),
            child: Row(
              children: [
                Text(AppStrings.filters, style: AppTextStyles.sectionTitle.copyWith(fontSize: 21)),
                const Spacer(),
                TextButton(
                  onPressed: _clearAll,
                  child: Text(
                    AppStrings.clearAll,
                    style: AppTextStyles.buttonSmall.copyWith(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.md, AppSpacing.xl, AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FilterSection(
                    label: 'Gender',
                    child: _singleSelect<Gender>(
                      values: Gender.values,
                      selected: _draft.gender,
                      labelOf: (g) => g.label,
                      onChanged: (g) => _update((d) => d.copyWith(gender: g)),
                    ),
                  ),
                  _FilterSection(
                    label: 'Age Range',
                    trailing: '${_draft.ageMin ?? 16} – ${_draft.ageMax ?? 70} yrs',
                    child: RangeSlider(
                      min: 16,
                      max: 70,
                      divisions: 54,
                      labels: RangeLabels('${_draft.ageMin ?? 16}', '${_draft.ageMax ?? 70}'),
                      values: RangeValues(
                        (_draft.ageMin ?? 16).toDouble(),
                        (_draft.ageMax ?? 70).toDouble(),
                      ),
                      onChanged: (values) => _update(
                        (d) => d.copyWith(ageMin: values.start.round(), ageMax: values.end.round()),
                      ),
                    ),
                  ),
                  _FilterSection(
                    label: 'Height Range',
                    trailing: '${(_draft.heightMin ?? 140).round()} – ${(_draft.heightMax ?? 210).round()} cm',
                    child: RangeSlider(
                      min: 140,
                      max: 210,
                      divisions: 70,
                      labels: RangeLabels(
                        '${(_draft.heightMin ?? 140).round()}',
                        '${(_draft.heightMax ?? 210).round()}',
                      ),
                      values: RangeValues(
                        _draft.heightMin ?? 140,
                        _draft.heightMax ?? 210,
                      ),
                      onChanged: (values) => _update(
                        (d) => d.copyWith(heightMin: values.start, heightMax: values.end),
                      ),
                    ),
                  ),
                  _FilterSection(
                    label: 'Languages',
                    child: _multiSelect(
                      options: _kLanguagePool,
                      selected: _draft.languages,
                      onChanged: (langs) => _update((d) => d.copyWith(languages: langs)),
                    ),
                  ),
                  if (cities.isNotEmpty)
                    _FilterSection(
                      label: 'City',
                      child: _singleSelect<String>(
                        values: cities,
                        selected: _draft.city,
                        labelOf: (c) => c,
                        onChanged: (c) => _update((d) => d.copyWith(city: c)),
                      ),
                    ),
                  _FilterSection(
                    label: 'Experience Level',
                    child: _singleSelect<ExperienceLevel>(
                      values: ExperienceLevel.values,
                      selected: _draft.experienceLevel,
                      labelOf: (e) => e.label,
                      onChanged: (e) => _update((d) => d.copyWith(experienceLevel: e)),
                    ),
                  ),
                  _FilterSection(
                    label: 'Availability',
                    child: _singleSelect<AvailabilityStatus>(
                      values: AvailabilityStatus.values,
                      selected: _draft.availability,
                      labelOf: (a) => a.label,
                      onChanged: (a) => _update((d) => d.copyWith(availability: a)),
                    ),
                  ),
                  _FilterSection(
                    label: 'Sort By',
                    child: _singleSelectRequired<TalentSortBy>(
                      values: TalentSortBy.values,
                      selected: _draft.sortBy,
                      labelOf: _sortLabel,
                      onChanged: (s) => _update((d) => d.copyWith(sortBy: s)),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  _VerifiedToggle(
                    value: _draft.verifiedOnly,
                    onChanged: (v) => _update((d) => d.copyWith(verifiedOnly: v)),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xl),
            child: PremiumButton(
              label: AppStrings.applyFilters,
              fullWidth: true,
              icon: Iconsax.tick_circle,
              onPressed: _apply,
            ),
          ),
        ],
      ),
    );
  }
}

String _sortLabel(TalentSortBy sort) {
  switch (sort) {
    case TalentSortBy.rating:
      return 'Top Rated';
    case TalentSortBy.newest:
      return 'Newest';
    case TalentSortBy.views:
      return 'Most Viewed';
    case TalentSortBy.name:
      return 'Name (A-Z)';
  }
}

class _FilterSection extends StatelessWidget {
  const _FilterSection({required this.label, required this.child, this.trailing});

  final String label;
  final Widget child;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: AppTextStyles.cardTitle.copyWith(fontSize: 15)),
              const Spacer(),
              if (trailing != null)
                Text(trailing!, style: AppTextStyles.bodySmall.copyWith(color: AppColors.gold)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          child,
        ],
      ),
    );
  }
}

Widget _singleSelect<T>({
  required List<T> values,
  required T? selected,
  required String Function(T) labelOf,
  required ValueChanged<T?> onChanged,
  String allLabel = 'Any',
}) {
  return Wrap(
    spacing: AppSpacing.sm,
    runSpacing: AppSpacing.sm,
    children: [
      KrFilterChip(label: allLabel, selected: selected == null, onTap: () => onChanged(null)),
      ...values.map(
        (v) => KrFilterChip(
          label: labelOf(v),
          selected: v == selected,
          onTap: () => onChanged(v),
        ),
      ),
    ],
  );
}

Widget _singleSelectRequired<T>({
  required List<T> values,
  required T selected,
  required String Function(T) labelOf,
  required ValueChanged<T> onChanged,
}) {
  return Wrap(
    spacing: AppSpacing.sm,
    runSpacing: AppSpacing.sm,
    children: values
        .map(
          (v) => KrFilterChip(
            label: labelOf(v),
            selected: v == selected,
            onTap: () => onChanged(v),
          ),
        )
        .toList(),
  );
}

Widget _multiSelect({
  required List<String> options,
  required List<String> selected,
  required ValueChanged<List<String>> onChanged,
}) {
  return Wrap(
    spacing: AppSpacing.sm,
    runSpacing: AppSpacing.sm,
    children: options.map((o) {
      final isSelected = selected.contains(o);
      return KrFilterChip(
        label: o,
        selected: isSelected,
        onTap: () {
          final next = List<String>.from(selected);
          if (isSelected) {
            next.remove(o);
          } else {
            next.add(o);
          }
          onChanged(next);
        },
      );
    }).toList(),
  );
}

class _VerifiedToggle extends StatelessWidget {
  const _VerifiedToggle({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.radiusMd,
          border: Border.all(color: value ? AppColors.gold.withValues(alpha: 0.4) : AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Iconsax.verify, size: 18, color: AppColors.gold),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text('Verified profiles only', style: AppTextStyles.body.copyWith(fontSize: 14)),
            ),
            Switch(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}
