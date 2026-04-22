import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_text_styles.dart';

class ReviewSuccessDialog extends StatelessWidget {
  const ReviewSuccessDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierColor: AppColors.black.withValues(alpha: 0.6),
      barrierDismissible: true,
      builder: (context) => const ReviewSuccessDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Use the established sheet theme for the "Action Mode" white sheet look
    return Theme(
      data: AppTheme.sheetTheme,
      child: Builder(
        builder: (context) {
          final colorScheme = Theme.of(context).colorScheme;

          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              insetPadding: const EdgeInsets.symmetric(horizontal: 24),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Glass Container with Painter
                  CustomPaint(
                    painter: _LiquidGlassDialogPainter(),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                      decoration: BoxDecoration(
                        // Semi-transparent surface for glass effect
                        color: AppColors.sheetSurface.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Icon: Minimalist Solid Black
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.black.withValues(alpha: 0.1),
                                width: 1.5,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.star_rounded,
                                color: AppColors.black,
                                size: 42,
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Title
                          Text(
                            l10n.reviewPromptTitle,
                            style: AppTextStyles.h4.copyWith(
                              fontWeight: FontWeight.w800,
                              color: colorScheme.onSurface,
                              letterSpacing: -0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),

                          // Subtitle
                          Text(
                            l10n.reviewPromptContent,
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),

                          // Buttons: High-Contrast Monochromatic
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ElevatedButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.black,
                                  foregroundColor: AppColors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: Text(
                                  l10n.reviewPromptPositive,
                                  style: AppTextStyles.labelLarge.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    side: BorderSide(
                                      color: AppColors.black.withValues(
                                        alpha: 0.1,
                                      ),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  l10n.reviewPromptNegative,
                                  style: AppTextStyles.labelLarge.copyWith(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Close Button
                  Positioned(
                    top: 12,
                    right: 12,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close_rounded,
                        color: AppColors.black.withValues(alpha: 0.4),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Custom painter to apply the "Liquid Glass" effect to the dialog.
/// Includes specular highlights and a subtle gradient border.
class _LiquidGlassDialogPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(24));

    // Specular highlight from top-left
    final specularPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.5, -1.2),
        radius: 1.5,
        colors: [
          AppColors.white.withValues(alpha: 0.15),
          AppColors.white.withValues(alpha: 0.02),
          Colors.transparent,
        ],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(rect);
    canvas.drawRRect(rrect, specularPaint);

    // Subtle gradient border
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.white.withValues(alpha: 0.3),
          AppColors.white.withValues(alpha: 0.05),
          AppColors.white.withValues(alpha: 0.1),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(rect);
    canvas.drawRRect(rrect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
