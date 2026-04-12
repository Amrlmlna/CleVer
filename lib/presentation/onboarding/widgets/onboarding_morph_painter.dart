import 'dart:math' as math;
import 'package:flutter/material.dart';

class OnboardingMorphPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0
  final Color color;

  OnboardingMorphPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 3.2;

    // Draw background soft glow
    canvas.drawCircle(
      center, 
      radius * 1.5, 
      Paint()
        ..shader = RadialGradient(
          colors: [color.withValues(alpha: 0.2), Colors.transparent],
        ).createShader(Rect.fromCircle(center: center, radius: radius * 1.5))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
    );

    for (int layer = 0; layer < 3; layer++) {
      final layerOpacity = 0.4 - (layer * 0.1);
      final layerScale = 1.0 - (layer * 0.1);
      
      final paint = Paint()
        ..color = color.withValues(alpha: layerOpacity)
        ..style = PaintingStyle.fill;

      final path = Path();
      const int pointsCount = 12;
      
      for (int i = 0; i <= pointsCount; i++) {
        final angle = (i * 2 * math.pi) / pointsCount;
        
        // Organic noise: disturbed when progress is low, smooth when progress is high
        final double noiseFactor = (1.0 - progress);
        final double layerOffset = layer * 4.0;
        final double noise = noiseFactor * 35 * math.sin(angle * 3 + progress * 5 + layerOffset);
        
        final double currentRadius = (radius * layerScale) + noise;
        
        final x = center.dx + currentRadius * math.cos(angle);
        final y = center.dy + currentRadius * math.sin(angle);
        
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          // Use cubic Bezier for organic "blob" feel
          final prevAngle = ((i - 1) * 2 * math.pi) / pointsCount;
          final prevNoise = noiseFactor * 35 * math.sin(prevAngle * 3 + progress * 5 + layerOffset);
          final prevRadius = (radius * layerScale) + prevNoise;
          
          final cp1Angle = prevAngle + (angle - prevAngle) / 2;
          final cp1Radius = prevRadius + (currentRadius - prevRadius) / 2 + (noiseFactor * 15);
          
          final cpx = center.dx + cp1Radius * math.cos(cp1Angle);
          final cpy = center.dy + cp1Radius * math.sin(cp1Angle);
          
          path.quadraticBezierTo(cpx, cpy, x, y);
        }
      }
      path.close();
      
      canvas.drawPath(path, paint);
      
      // Add a subtle border to the topmost layer
      if (layer == 0) {
        canvas.drawPath(
          path, 
          Paint()
            ..color = color.withValues(alpha: 0.5)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant OnboardingMorphPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

class CinematicMorphWidget extends StatefulWidget {
  final double progress;
  final Color color;

  const CinematicMorphWidget({
    super.key,
    required this.progress,
    required this.color,
  });

  @override
  State<CinematicMorphWidget> createState() => _CinematicMorphWidgetState();
}

class _CinematicMorphWidgetState extends State<CinematicMorphWidget> with SingleTickerProviderStateMixin {
  late AnimationController _wobbleController;

  @override
  void initState() {
    super.initState();
    _wobbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _wobbleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _wobbleController,
      builder: (context, child) {
        // combine widget.progress (the step progress) with a small wobble animation
        final double effectiveProgress = widget.progress;
        
        return CustomPaint(
          painter: OnboardingMorphPainter(
            progress: effectiveProgress,
            color: widget.color,
          ),
          child: const SizedBox(width: 300, height: 300),
        );
      },
    );
  }
}
