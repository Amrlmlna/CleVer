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
import '../providers/login_controller.dart';
import '../widgets/forgot_password_bottom_sheet.dart';

class CleverLoginPage extends ConsumerStatefulWidget {
  const CleverLoginPage({super.key});

  @override
  ConsumerState<CleverLoginPage> createState() => _CleverLoginPageState();
}

class _CleverLoginPageState extends ConsumerState<CleverLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);

    final success = await ref
        .read(loginControllerProvider.notifier)
        .signInWithEmail(_email.text, _password.text);

    if (!mounted) return;
    setState(() => _submitting = false);

    if (success) {
      context.push(AppRoutes.onboardingLoading);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _submitting = true);
    final success = await ref
        .read(loginControllerProvider.notifier)
        .signInWithGoogle();
    if (!mounted) return;
    setState(() => _submitting = false);

    if (success) {
      context.push(AppRoutes.onboardingLoading);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    ref.listen<AsyncValue<void>>(loginControllerProvider, (_, next) {
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
            left: -58,
            top: 111,
            child: CleverMascot(variant: CleverMascotVariant.signIn),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 55,
            child: Text(
              l10n.login,
              textAlign: TextAlign.center,
              style: CleverTypography.h1.copyWith(
                color: CleverColors.textPrimary,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 324,
            child: Text(
              l10n.cleverSignInGreeting,
              textAlign: TextAlign.center,
              style: CleverTypography.h4.copyWith(
                color: CleverColors.textOnDark,
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
                        label: l10n.cleverGoogleSignIn,
                        onTap: _submitting ? null : _signInWithGoogle,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: CleverSpacing.space16,
                        ),
                        child: CleverDivider(label: l10n.or),
                      ),
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
                        validator: (v) => (v == null || v.isEmpty)
                            ? l10n.requiredField
                            : null,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () =>
                              ForgotPasswordBottomSheet.show(context),
                          style: TextButton.styleFrom(
                            foregroundColor: CleverColors.textPrimary,
                            padding: const EdgeInsets.symmetric(
                              vertical: CleverSpacing.space8,
                            ),
                          ),
                          child: Text(
                            l10n.forgotPassword,
                            style: CleverTypography.bodyStrong.copyWith(
                              color: CleverColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: CleverSpacing.space8),
                      CleverButton(
                        label: l10n.login,
                        onTap: _submit,
                        busy: _submitting,
                      ),
                      const SizedBox(height: CleverSpacing.space16),
                      TextButton(
                        onPressed: () => context.push(AppRoutes.signup),
                        style: TextButton.styleFrom(
                          foregroundColor: CleverColors.textPrimary,
                          padding: EdgeInsets.zero,
                        ),
                        child: Text.rich(
                          TextSpan(
                            text: '${l10n.dontHaveAccount} ',
                            children: [
                              TextSpan(
                                text: l10n.signUp,
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
      textInputAction: obscureText
          ? TextInputAction.done
          : TextInputAction.next,
    );
  }
}
