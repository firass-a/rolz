/// Recruiter Find Talent filters — mirrors the web Find Talent search:
/// category, gender, availability, language, skills, age, height min,
/// experience min, location and nationality.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/l10n/display_localizer.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/providers.dart';

const _kLanguagePool = [
  'English',
  'Arabic',
  'French',
  'Korean',
  'Spanish',
  'German',
  'Italian',
  'Portuguese',
  'Turkish',
  'Kabyle',
  'Chinese',
  'Japanese',
  'Russian',
  'Hindi',
];

const _kSkillsPool = [
  'Acting',
  'Improvisation',
  'Stage Combat',
  'Horse Riding',
  'Dance',
  'Singing',
  'Martial Arts',
  'Comedy',
  'Drama',
  'Voice Modulation',
  'Modeling Poses',
  'Photography',
  'Video Editing',
  'Public Speaking',
  'Stunt Work',
];

const _kExperienceMins = [1, 2, 3, 5, 8, 10];

Future<void> showFindTalentFiltersSheet(BuildContext context) {
  return showKrBottomSheet(
    context,
    builder: (context) => const FindTalentFiltersSheet(),
  );
}

class FindTalentFiltersSheet extends ConsumerStatefulWidget {
  const FindTalentFiltersSheet({super.key});

  @override
  ConsumerState<FindTalentFiltersSheet> createState() => _FindTalentFiltersSheetState();
}

class _FindTalentFiltersSheetState extends ConsumerState<FindTalentFiltersSheet> {
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
    final talents = ref.watch(talentProvider);
    final cities = talents.map((t) => t.city).where((c) => c.isNotEmpty).toSet().toList()..sort();
    final nationalities =
        talents.map((t) => t.nationality).where((n) => n.isNotEmpty).toSet().toList()..sort();

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
                    label: AppStrings.category,
                    child: _singleSelect<TalentCategory>(
                      values: TalentCategory.values,
                      selected: _draft.category,
                      labelOf: (c) => c.label,
                      onChanged: (c) => _update((d) => d.copyWith(category: c)),
                    ),
                  ),
                  _FilterSection(
                    label: AppStrings.gender,
                    child: _singleSelect<Gender>(
                      values: Gender.values,
                      selected: _draft.gender,
                      labelOf: (g) => g.label,
                      onChanged: (g) => _update((d) => d.copyWith(gender: g)),
                    ),
                  ),
                  _FilterSection(
                    label: AppStrings.availability,
                    child: _singleSelect<AvailabilityStatus>(
                      values: AvailabilityStatus.values,
                      selected: _draft.availability,
                      labelOf: (a) => a.label,
                      onChanged: (a) => _update((d) => d.copyWith(availability: a)),
                    ),
                  ),
                  _FilterSection(
                    label: AppStrings.language,
                    child: _multiSelect(
                      options: _kLanguagePool,
                      selected: _draft.languages,
                      onChanged: (langs) => _update((d) => d.copyWith(languages: langs)),
                    ),
                  ),
                  _FilterSection(
                    label: AppStrings.skills,
                    child: _multiSelect(
                      options: _kSkillsPool,
                      selected: _draft.skills,
                      onChanged: (skills) => _update((d) => d.copyWith(skills: skills)),
                    ),
                  ),
                  _FilterSection(
                    label: AppStrings.ageRange,
                    trailing: AppStrings.ageRangeTrailing(_draft.ageMin ?? 16, _draft.ageMax ?? 70),
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
                    label: AppStrings.heightMinCm,
                    trailing: _draft.heightMin == null
                        ? AppStrings.any
                        : AppStrings.heightCmPlus(_draft.heightMin!.round()),
                    child: Column(
                      children: [
                        Slider(
                          min: 140,
                          max: 210,
                          divisions: 70,
                          label: _draft.heightMin == null
                              ? AppStrings.any
                              : '${(_draft.heightMin ?? 140).round()}',
                          value: _draft.heightMin ?? 140,
                          onChanged: (value) => _update((d) => d.copyWith(heightMin: value, heightMax: null)),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () => _update((d) => d.copyWith(heightMin: null, heightMax: null)),
                            child: Text(
                              AppStrings.clearHeight,
                              style: AppTextStyles.buttonSmall.copyWith(color: AppColors.textSecondary),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _FilterSection(
                    label: AppStrings.experienceMinY,
                    child: Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        KrFilterChip(
                          label: AppStrings.any,
                          selected: _draft.experienceMinYears == null,
                          onTap: () => _update((d) => d.copyWith(experienceMinYears: null)),
                        ),
                        ..._kExperienceMins.map(
                          (years) => KrFilterChip(
                            label: AppStrings.yearsPlus(years),
                            selected: _draft.experienceMinYears == years,
                            onTap: () => _update((d) => d.copyWith(experienceMinYears: years)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (cities.isNotEmpty)
                    _FilterSection(
                      label: AppStrings.location,
                      child: _singleSelect<String>(
                        values: cities,
                        selected: _draft.city,
                        labelOf: DisplayLocalizer.t,
                        onChanged: (c) => _update((d) => d.copyWith(city: c)),
                      ),
                    ),
                  if (nationalities.isNotEmpty)
                    _FilterSection(
                      label: AppStrings.nationality,
                      child: _singleSelect<String>(
                        values: nationalities,
                        selected: _draft.nationality,
                        labelOf: DisplayLocalizer.t,
                        onChanged: (n) => _update((d) => d.copyWith(nationality: n)),
                      ),
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
}) {
  return Wrap(
    spacing: AppSpacing.sm,
    runSpacing: AppSpacing.sm,
    children: [
      KrFilterChip(label: AppStrings.any, selected: selected == null, onTap: () => onChanged(null)),
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
        label: DisplayLocalizer.t(o),
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
