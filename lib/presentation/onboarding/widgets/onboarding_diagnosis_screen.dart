import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_text_styles.dart';

class OnboardingDiagnosisScreen extends StatelessWidget {
  final String burnoutCause;
  final String timeSpent;
  final Duration delay;

  const OnboardingDiagnosisScreen({
    super.key,
    required this.burnoutCause,
    required this.timeSpent,
    this.delay = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // The Diagnosis Header
          Text(
            l10n.onboardingDiagnosisTitle,
            style: AppTextStyles.h1.copyWith(
              fontWeight: FontWeight.w900,
              color: colorScheme.onSurface,
              letterSpacing: -1.5,
              height: 1.0,
            ),
            textAlign: TextAlign.left,
          ).animate().fadeIn().slideY(begin: 0.1, end: 0),
          
          const SizedBox(height: 24),
          
          // Line Graphics Container (Cinematic Chart)
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: colorScheme.onSurface.withValues(alpha: 0.08),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.05),
                  blurRadius: 40,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Background Grid
                CustomPaint(
                  size: Size.infinite,
                  painter: _ChartGridPainter(
                    color: colorScheme.onSurface.withValues(alpha: 0.05),
                  ),
                ),
                
                // Organic Line & Gradient Fill
                CustomPaint(
                  size: Size.infinite,
                  painter: _DiagnosisLinePainter(
                    color: colorScheme.primary,
                    fillColor: colorScheme.primary.withValues(alpha: 0.1),
                  ),
                ),
                
                Positioned(
                  bottom: 24,
                  right: 24,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        timeSpent,
                        style: AppTextStyles.h1.copyWith(
                          fontWeight: FontWeight.w900,
                          color: colorScheme.primary,
                          shadows: [
                            Shadow(
                              color: colorScheme.primary.withValues(alpha: 0.3),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                      ).animate().scale(duration: 800.ms, curve: Curves.elasticOut),
                      Text(
                        'LOST ANNUALLY',
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                          letterSpacing: 2,
                          fontWeight: FontWeight.w800,
                        ),
                      ).animate().fadeIn(delay: 400.ms),
                    ],
                  ),
                ),
              ],
            ),
          ).animate(delay: 200.ms).fadeIn(duration: 800.ms).slideY(begin: 0.1, end: 0),
          
          const SizedBox(height: 48),
          
          // The Polished Diagnostic Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: colorScheme.onSurface.withValues(alpha: 0.08),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 4,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        colorScheme.primary,
                        colorScheme.primary.withValues(alpha: 0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            size: 16,
                            color: colorScheme.primary.withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'ANALYSIS COMPLETE',
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.primary.withValues(alpha: 0.7),
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildHighlightedText(
                        l10n.onboardingDiagnosisSub(timeSpent, burnoutCause),
                        [timeSpent, burnoutCause],
                        colorScheme,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.05, end: 0),
        ],
      ),
    );
  }

  Widget _buildHighlightedText(
    String fullText,
    List<String> toHighlight,
    ColorScheme colorScheme,
  ) {
    List<TextSpan> spans = [];
    String remaining = fullText;

    while (remaining.isNotEmpty) {
      int earliestIndex = -1;
      String? foundKeyword;

      for (final keyword in toHighlight) {
        final index = remaining.indexOf(keyword);
        if (index != -1 && (earliestIndex == -1 || index < earliestIndex)) {
          earliestIndex = index;
          foundKeyword = keyword;
        }
      }

      if (earliestIndex == -1) {
        spans.add(TextSpan(text: remaining));
        break;
      }

      if (earliestIndex > 0) {
        spans.add(TextSpan(text: remaining.substring(0, earliestIndex)));
      }

      spans.add(TextSpan(
        text: foundKeyword,
        style: TextStyle(
          fontWeight: FontWeight.w900,
          color: colorScheme.primary,
        ),
      ));

      remaining = remaining.substring(earliestIndex + foundKeyword!.length);
    }

    return RichText(
      textAlign: TextAlign.justify,
      text: TextSpan(
        style: AppTextStyles.bodyMedium.copyWith(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.9),
          height: 1.8,
          letterSpacing: 0, // Better for justified text
        ),
        children: spans,
      ),
    );
  }
}

class _ChartGridPainter extends CustomPainter {
  final Color color;

  _ChartGridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const int rows = 4;
    const int cols = 6;

    for (int i = 1; i <= rows; i++) {
      final y = size.height * (i / (rows + 1));
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    for (int i = 1; i <= cols; i++) {
      final x = size.width * (i / (cols + 1));
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DiagnosisLinePainter extends CustomPainter {
  final Color color;
  final Color fillColor;

  _DiagnosisLinePainter({
    required this.color,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [fillColor, Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Create an organic organic curve representing waste accumulation
    path.moveTo(0, size.height * 0.8);
    path.cubicTo(
      size.width * 0.25, size.height * 0.75,
      size.width * 0.4, size.height * 0.2,
      size.width * 0.7, size.height * 0.35,
    );
    path.cubicTo(
      size.width * 0.85, size.height * 0.45,
      size.width * 0.95, size.height * 0.1,
      size.width, size.height * 0.15,
    );

    // Create the fill path by closing it to the bottom
    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);
    
    // Add a glowing effect to the line
    canvas.drawPath(
      path, 
      Paint()
        ..color = color.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
