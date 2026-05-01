import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../profile/providers/profile_sync_provider.dart';
import '../../common/widgets/app_loading_screen.dart';
import '../providers/signup_controller.dart';
import '../widgets/email_verification_bottom_sheet.dart';

class SignupForm extends ConsumerStatefulWidget {
  const SignupForm({super.key});

  @override
  ConsumerState<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends ConsumerState<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: false,
        pageBuilder: (context, animation, secondaryAnimation) =>
            AppLoadingScreen(
              messages: [l10n.validatingData, l10n.finalizing, l10n.ready],
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );

    final userId = await ref
        .read(signupControllerProvider.notifier)
        .signUp(
          _emailController.text,
          _passwordController.text,
          _nameController.text,
        );

    if (mounted) {
      if (userId != null) {
        Navigator.of(context).pop();

        await Future.delayed(const Duration(milliseconds: 300));

        if (mounted) {
          EmailVerificationBottomSheet.show(
            context,
            onVerified: () async {
              try {
                await ref.read(profileSyncProvider).initialCloudFetch(userId);
              } catch (e) {
                debugPrint("Sync failed after verification: $e");
              }
              if (mounted) {
                context.go('/');
              }
            },
          );
        }
      }
    }
  }

  InputDecoration _buildIndustrialDecoration(
    BuildContext context,
    String label,
    IconData icon, {
    Widget? suffixIcon,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w600,
      ),
      prefixIcon: Icon(icon, color: colorScheme.onSurface, size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colorScheme.onSurface, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isLoading = ref.watch(signupControllerProvider).isLoading;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _nameController,
            style: const TextStyle(fontWeight: FontWeight.w600),
            decoration: _buildIndustrialDecoration(
              context,
              l10n.fullName,
              Icons.person_outline_rounded,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.pleaseEnterName;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(fontWeight: FontWeight.w600),
            decoration: _buildIndustrialDecoration(
              context,
              l10n.email,
              Icons.email_outlined,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.pleaseEnterEmail;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            style: const TextStyle(fontWeight: FontWeight.w600),
            decoration: _buildIndustrialDecoration(
              context,
              l10n.password,
              Icons.lock_outline_rounded,
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                onPressed: () =>
                    setState(() => _isPasswordVisible = !_isPasswordVisible),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.pleaseEnterPassword;
              }
              if (value.length < 6) {
                return l10n.passwordMinLength;
              }
              return null;
            },
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.onSurface,
                foregroundColor: colorScheme.surface,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: colorScheme.surface,
                      ),
                    )
                  : Text(
                      l10n.createAccount.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        letterSpacing: 1.0,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
