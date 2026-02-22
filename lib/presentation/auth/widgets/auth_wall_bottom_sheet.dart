import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../../profile/providers/profile_sync_provider.dart';
import '../providers/auth_state_provider.dart';
import '../widgets/gradient_button.dart';
import '../widgets/social_login_button.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class AuthWallBottomSheet extends ConsumerStatefulWidget {
  final String? featureTitle;
  final String? featureDescription;
  final VoidCallback? onAuthenticated;

  const AuthWallBottomSheet({
    super.key,
    this.featureTitle,
    this.featureDescription,
    this.onAuthenticated,
  });

  static Future<void> show(
    BuildContext context, {
    String? featureTitle,
    String? featureDescription,
    VoidCallback? onAuthenticated,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (context) => AuthWallBottomSheet(
        featureTitle: featureTitle,
        featureDescription: featureDescription,
        onAuthenticated: onAuthenticated,
      ),
    );
  }

  @override
  ConsumerState<AuthWallBottomSheet> createState() => _AuthWallBottomSheetState();
}

class _AuthWallBottomSheetState extends ConsumerState<AuthWallBottomSheet> {
  bool _isLoading = false;

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      final authRepo = ref.read(authRepositoryProvider);
      final user = await authRepo.signInWithGoogle();

      if (user != null && mounted) {
        try {
          await ref.read(profileSyncProvider).initialCloudFetch(user.uid);
        } catch (e) {
          debugPrint("Sync failed after google signin: $e");
        }

        if (mounted) {
          Navigator.of(context).pop();
          widget.onAuthenticated?.call();
        }
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
        child: CustomPaint(
          painter: _LiquidGlassSheetPainter(),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
            decoration: BoxDecoration(
              color: (isDark ? Colors.black : Colors.grey.shade900).withValues(alpha: 0.35),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.08),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF5EEAD4).withValues(alpha: 0.15),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.lock_outline_rounded,
                    color: Colors.white.withValues(alpha: 0.9),
                    size: 28,
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  widget.featureTitle ??
                      AppLocalizations.of(context)!.loginToSave,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  widget.featureDescription ??
                      AppLocalizations.of(context)!.syncAnywhere,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.6),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 28),

                SocialLoginButton(
                  onPressed: _isLoading ? null : _signInWithGoogle,
                  text: AppLocalizations.of(context)!.continueWithGoogle,
                  icon: Image.asset('assets/images/google_logo.png', height: 24),
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 12),

                GradientButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          Navigator.of(context).pop();
                          context.push('/login');
                        },
                  text: AppLocalizations.of(context)!.login,
                  icon: const Icon(Icons.email_outlined, color: Colors.white),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.dontHaveAccount,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.push('/signup');
                      },
                      child: Text(
                        AppLocalizations.of(context)!.signUp,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF5EEAD4),
                          fontSize: 14,
                        ),
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

class _LiquidGlassSheetPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndCorners(
      rect,
      topLeft: const Radius.circular(28),
      topRight: const Radius.circular(28),
    );

    final specularPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.0, -1.2),
        radius: 1.5,
        colors: [
          Colors.white.withValues(alpha: 0.2),
          Colors.white.withValues(alpha: 0.04),
          Colors.transparent,
        ],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(rect);
    canvas.drawRRect(rrect, specularPaint);

    final topLinePaint = Paint()
      ..shader = LinearGradient(
        begin: const Alignment(-1, 0),
        end: const Alignment(1, 0),
        colors: [
          Colors.transparent,
          Colors.white.withValues(alpha: 0.25),
          Colors.white.withValues(alpha: 0.35),
          Colors.white.withValues(alpha: 0.25),
          Colors.transparent,
        ],
        stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, 2));

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(size.width * 0.1, 0, size.width * 0.8, 1.0),
        topLeft: const Radius.circular(1),
        topRight: const Radius.circular(1),
      ),
      topLinePaint,
    );

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: 0.3),
          Colors.white.withValues(alpha: 0.05),
        ],
      ).createShader(rect);
    canvas.drawRRect(rrect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
