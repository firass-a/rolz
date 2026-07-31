import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/providers/providers.dart';

/// 6-digit one-time-passcode screen. Fully fake verification — any
/// complete 6-digit code is accepted — but the box-by-box entry, auto
/// focus advance and success checkmark are all real.
class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  static const _length = 6;
  final _controllers = List.generate(_length, (_) => TextEditingController());
  final _focusNodes = List.generate(_length, (_) => FocusNode());
  bool _verifying = false;
  bool _verified = false;
  String? _error;

  String get _code => _controllers.map((c) => c.text).join();

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.isNotEmpty && index < _length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    setState(() => _error = null);
    if (_code.length == _length) _verify();
  }

  Future<void> _verify() async {
    context.dismissKeyboard();
    if (_code.length != _length) {
      setState(() => _error = 'Enter the full 6-digit code.');
      return;
    }
    setState(() => _verifying = true);
    final success = await ref.read(authProvider.notifier).verifyOtp(_code);
    if (!mounted) return;
    setState(() {
      _verifying = false;
      _verified = success;
      _error = success ? null : 'That code didn\'t work. Please try again.';
    });
  }

  void _reset() {
    for (final c in _controllers) {
      c.clear();
    }
    setState(() {
      _verified = false;
      _error = null;
    });
    _focusNodes.first.requestFocus();
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
          child: Center(child: _verified ? _buildSuccess() : _buildForm()),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
            child: const Icon(Iconsax.sms_tracking, size: 26, color: AppColors.gold),
          ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.85, 0.85), end: const Offset(1, 1)),
          const SizedBox(height: AppSpacing.xl),
          Text('Verify Your Code', style: AppTextStyles.heroTitleCompact)
              .animate()
              .fadeIn(delay: 80.ms, duration: 400.ms),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Enter the 6-digit code we sent you to confirm it\'s really you.',
            style: AppTextStyles.bodyMuted,
          ).animate().fadeIn(delay: 140.ms, duration: 400.ms),
          const SizedBox(height: AppSpacing.xxl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_length, (i) => _OtpBox(
                  controller: _controllers[i],
                  focusNode: _focusNodes[i],
                  hasError: _error != null,
                  onChanged: (v) => _onChanged(i, v),
                )),
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
          if (_error != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(_error!, style: AppTextStyles.caption.copyWith(color: AppColors.error)),
          ],
          const SizedBox(height: AppSpacing.xxl),
          PremiumButton.primary(
            label: 'Verify',
            fullWidth: true,
            isLoading: _verifying,
            onPressed: _verify,
          ).animate().fadeIn(delay: 260.ms, duration: 400.ms),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: TextButton(
              onPressed: _reset,
              child: Text(
                "Didn't get a code? Resend",
                style: AppTextStyles.buttonSmall.copyWith(color: AppColors.gold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccess() {
    return Column(
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
        Text('Verified!', style: AppTextStyles.sectionTitle).animate().fadeIn(delay: 120.ms, duration: 400.ms),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Your identity has been confirmed.',
          style: AppTextStyles.bodyMuted,
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 180.ms, duration: 400.ms),
        const SizedBox(height: AppSpacing.xxl),
        PremiumButton.secondary(
          label: 'Done',
          fullWidth: true,
          onPressed: () => context.pop(),
        ).animate().fadeIn(delay: 240.ms, duration: 400.ms),
      ],
    );
  }
}

class _OtpBox extends StatelessWidget {
  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    this.hasError = false,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46,
      height: 56,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: AppTextStyles.heroTitleCompact.copyWith(fontSize: 24, color: AppColors.textPrimary),
        cursorColor: AppColors.gold,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: AppRadius.radiusMd,
            borderSide: BorderSide(color: hasError ? AppColors.error : AppColors.border, width: 1.4),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.radiusMd,
            borderSide: BorderSide(color: hasError ? AppColors.error : AppColors.border, width: 1.4),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.radiusMd,
            borderSide: const BorderSide(color: AppColors.gold, width: 1.8),
          ),
        ),
      ),
    );
  }
}
