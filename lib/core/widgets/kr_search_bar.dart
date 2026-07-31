import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// KAST-ROLZ's luxury search field — gold accent on focus, a clear button
/// once text is entered, and an optional filter trigger icon.
class KrSearchBar extends StatefulWidget {
  const KrSearchBar({
    super.key,
    this.controller,
    this.hintText = 'Search…',
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.readOnly = false,
    this.autofocus = false,
    this.showFilterIcon = false,
    this.onFilterTap,
    this.hasActiveFilters = false,
    this.focusNode,
  });

  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool autofocus;
  final bool showFilterIcon;
  final VoidCallback? onFilterTap;
  final bool hasActiveFilters;
  final FocusNode? focusNode;

  @override
  State<KrSearchBar> createState() => _KrSearchBarState();
}

class _KrSearchBarState extends State<KrSearchBar> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _ownsController = false;
  bool _ownsFocusNode = false;
  bool _hasText = false;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _ownsController = widget.controller == null;
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_handleTextChanged);

    _focusNode = widget.focusNode ?? FocusNode();
    _ownsFocusNode = widget.focusNode == null;
    _focusNode.addListener(_handleFocusChanged);
  }

  void _handleTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) setState(() => _hasText = hasText);
  }

  void _handleFocusChanged() {
    setState(() => _focused = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChanged);
    _focusNode.removeListener(_handleFocusChanged);
    if (_ownsController) _controller.dispose();
    if (_ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.radiusMd,
              border: Border.all(
                color: _focused ? AppColors.gold : AppColors.border,
                width: _focused ? 1.6 : 1,
              ),
              boxShadow: _focused ? AppShadows.goldSoft : null,
            ),
            child: Row(
              children: [
                const SizedBox(width: AppSpacing.md),
                Icon(
                  Iconsax.search_normal,
                  size: 20,
                  color: _focused ? AppColors.gold : AppColors.textMuted,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    onChanged: widget.onChanged,
                    onSubmitted: widget.onSubmitted,
                    onTap: widget.onTap,
                    readOnly: widget.readOnly,
                    autofocus: widget.autofocus,
                    style: AppTextStyles.input,
                    cursorColor: AppColors.gold,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: AppTextStyles.hint,
                      filled: false,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                if (_hasText)
                  GestureDetector(
                    onTap: () {
                      _controller.clear();
                      widget.onChanged?.call('');
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                      child: Icon(
                        Iconsax.close_circle,
                        size: 18,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                const SizedBox(width: AppSpacing.sm),
              ],
            ),
          ),
        ),
        if (widget.showFilterIcon) ...[
          const SizedBox(width: AppSpacing.sm),
          _FilterIconButton(
            active: widget.hasActiveFilters,
            onTap: widget.onFilterTap,
          ),
        ],
      ],
    );
  }
}

class _FilterIconButton extends StatelessWidget {
  const _FilterIconButton({required this.active, this.onTap});

  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.gold : AppColors.surface,
          borderRadius: AppRadius.radiusMd,
          border: Border.all(
            color: active ? AppColors.gold : AppColors.border,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              Iconsax.filter,
              size: 20,
              color: active ? const Color(0xFF14110A) : AppColors.textSecondary,
            ),
            if (active)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
