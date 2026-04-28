import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class WalletCard extends StatelessWidget {
  final int totalCredits;
  final String cardHolder;
  final bool isLoading;
  final VoidCallback? onTopUp;

  const WalletCard({
    super.key,
    required this.totalCredits,
    required this.cardHolder,
    this.isLoading = false,
    this.onTopUp,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(48),
            color: colorScheme.onSurface,
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.15),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(48),
            child: Stack(
              children: [
                // Decorative Geometric Pattern
                Positioned(
                  top: -20,
                  right: -20,
                  child: Opacity(
                    opacity: 0.05,
                    child: Icon(
                      Icons.qr_code_2_rounded,
                      size: 200,
                      color: colorScheme.surface,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'CLEVER',
                            style: TextStyle(
                              color: colorScheme.surface,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              letterSpacing: 2.0,
                            ),
                          ),
                          if (onTopUp != null)
                            GestureDetector(
                              onTap: onTopUp,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: colorScheme.surface,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.add_rounded,
                                  color: colorScheme.onSurface,
                                  size: 24,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.creditBalance.toUpperCase(),
                            style: TextStyle(
                              color: colorScheme.surface.withValues(alpha: 0.4),
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (isLoading)
                            Text(
                              '...',
                              style: textTheme.displaySmall?.copyWith(
                                color: colorScheme.surface,
                                fontWeight: FontWeight.w900,
                              ),
                            )
                          else
                            Text(
                              '$totalCredits',
                              style: TextStyle(
                                fontSize: 64,
                                fontWeight: FontWeight.w900,
                                color: colorScheme.surface,
                                letterSpacing: -2.0,
                                height: 1.0,
                              ),
                            ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.contactless_rounded,
                            color: colorScheme.surface.withValues(alpha: 0.5),
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 600.ms)
        .scale(begin: const Offset(0.95, 0.95), curve: Curves.easeOutBack);
  }
}

class ChipPainter extends CustomPainter {
  final ColorScheme colorScheme;

  ChipPainter({required this.colorScheme});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = colorScheme.onTertiary.withValues(alpha: 0.2)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;

    canvas.drawLine(Offset(w * 0.33, 0), Offset(w * 0.33, h), paint);
    canvas.drawLine(Offset(w * 0.66, 0), Offset(w * 0.66, h), paint);
    canvas.drawLine(Offset(0, h * 0.5), Offset(w, h * 0.5), paint);

    final centerPaint = Paint()
      ..color = colorScheme.onTertiary.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(w / 2, h / 2),
          width: w / 3,
          height: h / 3,
        ),
        const Radius.circular(2),
      ),
      centerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant ChipPainter oldDelegate) =>
      oldDelegate.colorScheme != colorScheme;
}
