import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/clever/clever_colors.dart';
import '../../../core/theme/clever/clever_dimensions.dart';
import '../../../core/theme/clever/clever_typography.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../common/widgets/clever/clever_button.dart';
import '../../common/widgets/clever/clever_divider.dart';
import '../../common/widgets/clever/clever_google_button.dart';
import '../../common/widgets/clever/clever_mascot.dart';
import '../../common/widgets/clever/clever_sheet.dart';
import '../../common/widgets/clever/clever_text_field.dart';
import '../providers/signup_controller.dart';
import '../widgets/email_verification_bottom_sheet.dart';

class CleverSignupPage extends ConsumerStatefulWidget {
  const CleverSignupPage({super.key});

  @override
  ConsumerState<CleverSignupPage> createState() => _CleverSignupPageState();
}

class _CleverSignupPageState extends ConsumerState<CleverSignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);

    final userId = await ref
        .read(signupControllerProvider.notifier)
        .signUp(_email.text, _password.text, _name.text);

    if (!mounted) return;
    setState(() => _submitting = false);

    if (userId != null) {
      await EmailVerificationBottomSheet.show(
        context,
        onVerified: () => context.push(AppRoutes.onboardingLoading),
      );
    }
  }

  Future<void> _signUpWithGoogle() async {
    setState(() => _submitting = true);
    final success = await ref
        .read(signupControllerProvider.notifier)
        .signUpWithGoogle();
    if (!mounted) return;
    setState(() => _submitting = false);

    if (success) {
      context.push(AppRoutes.onboardingLoading);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    ref.listen<AsyncValue<void>>(signupControllerProvider, (_, next) {
      next.whenOrNull(
        error: (error, _) {
          final message = error.toString();
          if (!message.toLowerCase().contains('canceled')) {
            CustomSnackBar.showError(context, message);
          }
        },
      );
    });

    return Scaffold(
      backgroundColor: CleverColors.bgCanvas,
      body: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          const Positioned(
            left: -56,
            top: 108,
            child: CleverMascot(variant: CleverMascotVariant.signUp),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 54,
            child: Text(
              l10n.createAccount,
              textAlign: TextAlign.center,
              style: CleverTypography.h1.copyWith(
                color: CleverColors.textPrimary,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CleverSheet(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(21, 16, 20, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CleverGoogleButton(
                        label: l10n.cleverGoogleSignUp,
                        onTap: _submitting ? null : _signUpWithGoogle,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: CleverSpacing.space16,
                        ),
                        child: CleverDivider(label: l10n.or),
                      ),
                      _Field(
                        controller: _name,
                        hint: l10n.fullName,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? l10n.requiredField
                            : null,
                      ),
                      const SizedBox(height: CleverSpacing.space16),
                      _Field(
                        controller: _email,
                        hint: l10n.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          final email = v?.trim() ?? '';
                          if (email.isEmpty) return l10n.requiredField;
                          if (!email.contains('@')) {
                            return l10n.cleverEmailInvalid;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: CleverSpacing.space16),
                      _Field(
                        controller: _password,
                        hint: l10n.password,
                        obscureText: true,
                        validator: (v) => (v == null || v.length < 6)
                            ? l10n.passwordMinLength
                            : null,
                      ),
                      const SizedBox(height: CleverSpacing.space24),
                      CleverButton(
                        label: l10n.createAccount,
                        onTap: _submit,
                        busy: _submitting,
                      ),
                      const SizedBox(height: CleverSpacing.space16),
                      _SwitchPrompt(
                        prefix: l10n.alreadyHaveAccount,
                        link: l10n.logIn,
                        target: AppRoutes.login,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
  });

  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return CleverTextField(
      controller: controller,
      hintText: hint,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      textInputAction: TextInputAction.next,
    );
  }
}

class _SwitchPrompt extends StatelessWidget {
  const _SwitchPrompt({
    required this.prefix,
    required this.link,
    required this.target,
  });

  final String prefix;
  final String link;
  final String target;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.push(target),
      style: TextButton.styleFrom(
        foregroundColor: CleverColors.textPrimary,
        padding: EdgeInsets.zero,
      ),
      child: Text.rich(
        TextSpan(
          text: '$prefix ',
          children: [
            TextSpan(
              text: link,
              style: CleverTypography.h4Weight(
                FontWeight.w600,
              ).copyWith(color: CleverColors.textPrimary),
            ),
          ],
          style: CleverTypography.h4Weight(
            FontWeight.w400,
          ).copyWith(color: CleverColors.textPrimary),
        ),
      ),
    );
  }
}
