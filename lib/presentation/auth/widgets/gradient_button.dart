import 'package:flutter/material.dart';
import 'dart:ui';

class GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Widget? icon;
  final bool isLoading;

  const GradientButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            // Base gradient with transparency to let blur show
            gradient: isDisabled
                ? null
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xAA1E3A8A), // Deep Indigo/Blue @ 67%
                      Color(0xAA0F766E), // Teal @ 67%
                      Color(0x995EEAD4), // Light Mint @ 60%
                    ],
                  ),
            color: isDisabled ? Colors.grey.withValues(alpha: 0.15) : null,
          ),
          child: CustomPaint(
            painter: _LiquidGlassPainter(isDisabled: isDisabled),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isLoading ? null : onPressed,
                borderRadius: BorderRadius.circular(30),
                splashColor: Colors.white.withValues(alpha: 0.15),
                highlightColor: Colors.white.withValues(alpha: 0.05),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isLoading)
                        const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      else ...[
                        if (icon != null) ...[
                          IconTheme(
                            data: const IconThemeData(color: Colors.white),
                            child: icon!,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          text,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom painter for liquid glass specular highlights and edge glow
class _LiquidGlassPainter extends CustomPainter {
  final bool isDisabled;

  _LiquidGlassPainter({this.isDisabled = false});

  @override
  void paint(Canvas canvas, Size size) {
    if (isDisabled) return;

    final rect = Offset.zero & size;

    // Top-left specular highlight (simulates light hitting the glass surface)
    final specularPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.6, -1.2),
        radius: 1.2,
        colors: [
          Colors.white.withValues(alpha: 0.3),
          Colors.white.withValues(alpha: 0.08),
          Colors.transparent,
        ],
        stops: const [0.0, 0.3, 1.0],
      ).createShader(rect);

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(30)),
      specularPaint,
    );

    // Bottom edge glow (simulates light wrapping around the bottom of the glass)
    final edgeGlowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [Colors.white.withValues(alpha: 0.12), Colors.transparent],
        stops: const [0.0, 0.4],
      ).createShader(rect);

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(30)),
      edgeGlowPaint,
    );

    // Top edge thin highlight line (simulates the sharpest reflection at the lip)
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
        Rect.fromLTWH(size.width * 0.15, 0, size.width * 0.7, 1.5),
        topLeft: const Radius.circular(1),
        topRight: const Radius.circular(1),
      ),
      topLinePaint,
    );

    // Subtle border with gradient opacity
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.35),
          Colors.white.withValues(alpha: 0.1),
          Colors.white.withValues(alpha: 0.2),
        ],
      ).createShader(rect);

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(30)),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
