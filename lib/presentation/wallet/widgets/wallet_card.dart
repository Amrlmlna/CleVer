import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class WalletCard extends StatelessWidget {
  final int totalCredits;
  final String cardHolder;
  final bool isLoading;

  const WalletCard({
    super.key,
    required this.totalCredits,
    required this.cardHolder,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: double.infinity,
          height: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.inverseSurface,
                colorScheme.inverseSurface.withValues(alpha: 0.9),
                colorScheme.inverseSurface.withValues(alpha: 0.8),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.5),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
              BoxShadow(
                color: colorScheme.onInverseSurface.withValues(alpha: 0.05),
                blurRadius: 1,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Stack(
              children: [
                // Decorative Elements
                Positioned(
                  top: -50,
                  right: -50,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.onInverseSurface.withValues(
                        alpha: 0.03,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -30,
                  left: -30,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.onInverseSurface.withValues(
                        alpha: 0.02,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'CleVer',
                            style: textTheme.titleLarge?.copyWith(
                              color: colorScheme.onInverseSurface,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              letterSpacing: 1.2,
                            ),
                          ),
                          Container(
                            width: 45,
                            height: 35,
                            decoration: BoxDecoration(
                              color: colorScheme.tertiary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CustomPaint(
                              painter: ChipPainter(colorScheme: colorScheme),
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
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onInverseSurface.withValues(
                                alpha: 0.4,
                              ),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (isLoading)
                            Text(
                              '...',
                              style: textTheme.displaySmall?.copyWith(
                                color: colorScheme.onInverseSurface,
                              ),
                            )
                          else
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  '$totalCredits',
                                  style: textTheme.displayMedium?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: colorScheme.onInverseSurface,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.credits.toUpperCase(),
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.tertiary,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.member.toUpperCase(),
                                  style: textTheme.labelSmall?.copyWith(
                                    color: colorScheme.onInverseSurface
                                        .withValues(alpha: 0.4),
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  cardHolder,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.titleSmall?.copyWith(
                                    color: colorScheme.onInverseSurface,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.contactless_outlined,
                            color: colorScheme.onInverseSurface.withValues(
                              alpha: 0.4,
                            ),
                            size: 24,
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
