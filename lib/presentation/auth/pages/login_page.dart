import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../../common/widgets/app_loading_screen.dart';
import '../../profile/providers/profile_sync_provider.dart';
import '../providers/auth_state_provider.dart';
import '../widgets/gradient_button.dart';
import '../widgets/social_login_button.dart';

import 'package:clever/l10n/generated/app_localizations.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    bool loadingScreenPopped = false;
    void popLoadingScreen() {
      if (!loadingScreenPopped && mounted) {
        Navigator.of(context).pop();
        loadingScreenPopped = true;
      }
    }

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: false,
        pageBuilder: (context, animation, secondaryAnimation) => AppLoadingScreen(
          messages: [
            AppLocalizations.of(context)!.validatingData,
            AppLocalizations.of(context)!.finalizing,
          ],
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );

    try {
      final authRepo = ref.read(authRepositoryProvider);
      final user = await authRepo.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text,
      );

      popLoadingScreen();

      if (user != null && mounted) {
        try {
          await ref.read(profileSyncProvider).initialCloudFetch(user.uid);
        } catch (e) {
          debugPrint("Sync failed on login: $e");
        }

        CustomSnackBar.showSuccess(context, AppLocalizations.of(context)!.welcomeBackSuccess);
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/');
        }
      }
    } catch (e) {
      popLoadingScreen();
      if (mounted) {
        CustomSnackBar.showError(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() => _isLoading = true);

    bool loadingScreenPopped = false;
    void popLoadingScreen() {
      if (!loadingScreenPopped && mounted) {
        Navigator.of(context).pop();
        loadingScreenPopped = true;
      }
    }

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: false,
        pageBuilder: (context, animation, secondaryAnimation) => AppLoadingScreen(
          messages: [
            AppLocalizations.of(context)!.googleSignInSuccess,
            AppLocalizations.of(context)!.finalizing,
          ],
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );

    try {
      final authRepo = ref.read(authRepositoryProvider);
      final user = await authRepo.signInWithGoogle();
      
      popLoadingScreen();

      if (user != null && mounted) {
        try {
          await ref.read(profileSyncProvider).initialCloudFetch(user.uid);
        } catch (e) {
          debugPrint("Sync failed on Google login: $e");
        }

        CustomSnackBar.showSuccess(context, AppLocalizations.of(context)!.googleSignInSuccess);
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/');
        }
      }
    } catch (e) {
      popLoadingScreen();
      if (mounted) {
        CustomSnackBar.showError(context, AppLocalizations.of(context)!.googleSignInError(e.toString()));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/icon/new_logo.png', height: 40),
                    const SizedBox(width: 12),
                    Text(
                      'clever',
                      style: GoogleFonts.outfit(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                Text(
                  AppLocalizations.of(context)!.welcomeBack,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.signInSubtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 48),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.email,
                    prefixIcon: const Icon(Icons.email_outlined),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.pleaseEnterEmail;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.password,
                    prefixIcon: const Icon(Icons.lock_outline),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade100,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.pleaseEnterPassword;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                GradientButton(
                  onPressed: _isLoading ? null : _login,
                  text: AppLocalizations.of(context)!.login,
                  icon: const Icon(Icons.email_outlined, color: Colors.white),
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(child: Divider(color: isDark ? Colors.white24 : Colors.black12)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(AppLocalizations.of(context)!.or, style: TextStyle(color: Colors.grey.shade600)),
                    ),
                    Expanded(child: Divider(color: isDark ? Colors.white24 : Colors.black12)),
                  ],
                ),
                const SizedBox(height: 24),

                SocialLoginButton(
                  onPressed: _isLoading ? null : _loginWithGoogle,
                  text: AppLocalizations.of(context)!.continueWithGoogle,
                  icon: Image.asset('assets/images/google_logo.png', height: 24),
                  isLoading: _isLoading && false, // Add specific loading state for google if needed
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context)!.dontHaveAccount),
                    TextButton(
                      onPressed: () => context.push('/signup'),
                      child: Text(
                        AppLocalizations.of(context)!.signUp,
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
