import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/clever/clever_colors.dart';
import '../../../core/theme/clever/clever_dimensions.dart';
import '../../../core/theme/clever/clever_typography.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../auth/providers/auth_state_provider.dart';
import '../../common/widgets/clever/clever_button.dart';
import '../../common/widgets/clever/clever_text_field.dart';

class ForgotPasswordBottomSheet extends ConsumerStatefulWidget {
  const ForgotPasswordBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: CleverColors.bgCanvas,
      isDismissible: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(CleverRadius.sheet),
        ),
      ),
      builder: (context) => const ForgotPasswordBottomSheet(),
    );
  }

  @override
  ConsumerState<ForgotPasswordBottomSheet> createState() =>
      _ForgotPasswordBottomSheetState();
}

class _ForgotPasswordBottomSheetState
    extends ConsumerState<ForgotPasswordBottomSheet> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await ref
          .read(authRepositoryProvider)
          .sendPasswordResetEmail(_emailController.text.trim());
      if (mounted) {
        Navigator.pop(context);
        CustomSnackBar.showSuccess(
          context,
          AppLocalizations.of(context)!.verificationEmailSent,
        );
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.showError(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: const BoxDecoration(
        color: CleverColors.bgCanvas,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(CleverRadius.sheet),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        31,
        16,
        33,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 47,
                height: 4,
                decoration: BoxDecoration(
                  color: CleverColors.surfaceInverse.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: CleverSpacing.space24),
            Text(
              l10n.forgotPassword,
              textAlign: TextAlign.center,
              style: CleverTypography.h1.copyWith(
                color: CleverColors.textPrimary,
              ),
            ),
            const SizedBox(height: CleverSpacing.space12),
            Text(
              l10n.forgotPasswordResetMessage,
              textAlign: TextAlign.center,
              style: CleverTypography.body.copyWith(
                color: CleverColors.textSecondary,
              ),
            ),
            const SizedBox(height: CleverSpacing.space24),
            CleverTextField(
              controller: _emailController,
              hintText: l10n.email,
              surface: CleverFieldSurface.filled,
              prefixIcon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.pleaseEnterEmail;
                }
                return null;
              },
            ),
            const SizedBox(height: CleverSpacing.space24),
            CleverButton(
              label: l10n.sendResetLink,
              onTap: _isLoading ? null : _sendResetLink,
            ),
          ],
        ),
      ),
    );
  }
}
