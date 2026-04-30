import 'dart:math';
import 'package:flutter/material.dart';
import '../models/mascot_state.dart';

class MascotHeader extends StatefulWidget {
  final MascotExpression expression;
  final Color mascotColor;

  const MascotHeader({
    super.key,
    required this.expression,
    required this.mascotColor,
  });

  @override
  State<MascotHeader> createState() => _MascotHeaderState();
}

class _MascotHeaderState extends State<MascotHeader>
    with TickerProviderStateMixin {
  late AnimationController _introController;
  late AnimationController _idleController;
  late Animation<double> _slideAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _breatheAnimation;

  @override
  void initState() {
    super.initState();

    // Intro Animation (Slide up + Fade in)
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _slideAnimation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(parent: _introController, curve: Curves.easeOutBack),
    );

    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _introController, curve: Curves.easeIn));

    // Idle Animation (Gentle breathing/floating)
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _breatheAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _idleController, curve: Curves.easeInOut),
    );

    _introController.forward();
  }

  @override
  void dispose() {
    _introController.dispose();
    _idleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_introController, _idleController]),
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: SizedBox(
              height: 180,
              width: double.infinity,
              child: CustomPaint(
                painter: MascotPainter(
                  expression: widget.expression,
                  color: widget.mascotColor,
                  progress: _breatheAnimation.value,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class MascotPainter extends CustomPainter {
  final MascotExpression expression;
  final Color color;
  final double progress;

  MascotPainter({
    required this.expression,
    required this.color,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw the body (semicircle at the bottom)
    final bodyPath = Path()
      ..moveTo(0, size.height)
      ..quadraticBezierTo(
        size.width / 2,
        size.height - (size.height * 1.2), // Adjust curve height
        size.width,
        size.height,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(bodyPath, paint);

    // Draw Face Features (with animation offset)
    final centerX = size.width / 2;

    // Base floating for all
    final floatOffset = progress * 5;
    final centerY = size.height - 40 - floatOffset;

    _drawEyes(canvas, centerX, centerY);
    _drawMouth(canvas, centerX, centerY);
  }

  void _drawEyes(Canvas canvas, double centerX, double centerY) {
    final eyePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final eyeOffset = 25.0;
    final eyeTop = centerY - 15;

    switch (expression) {
      case MascotExpression.smiling:
        // Smiling: Eyes squeeze more during "breath"
        final squeeze = progress * 2;
        _drawUShape(
          canvas,
          centerX - eyeOffset,
          eyeTop + squeeze,
          eyePaint,
          height: 6 - squeeze,
        );
        _drawUShape(
          canvas,
          centerX + eyeOffset,
          eyeTop + squeeze,
          eyePaint,
          height: 6 - squeeze,
        );
        break;
      case MascotExpression.exciting:
        // Exciting: Eyes widen and narrow
        final widen = progress * 4;
        _drawUShape(
          canvas,
          centerX - eyeOffset,
          eyeTop,
          eyePaint,
          width: 12 + widen,
          height: 8 + widen / 2,
        );
        _drawUShape(
          canvas,
          centerX + eyeOffset,
          eyeTop,
          eyePaint,
          width: 12 + widen,
          height: 8 + widen / 2,
        );
        break;
      case MascotExpression.encouraging:
        // Encouraging: Winking eye animates
        _drawUShape(canvas, centerX - eyeOffset, eyeTop, eyePaint);
        // The "wink" line gets shorter and longer
        final winkWidth = 6.0 + (progress * 4);
        canvas.drawLine(
          Offset(centerX + eyeOffset - winkWidth / 2, eyeTop),
          Offset(centerX + eyeOffset + winkWidth / 2, eyeTop),
          eyePaint,
        );
        break;
      case MascotExpression.neutral:
        // Neutral: Subtle blink simulation
        final blink = progress > 0.8 ? (1.0 - progress) * 5 : 1.0;
        if (blink > 0.1) {
          _drawUShape(
            canvas,
            centerX - eyeOffset,
            eyeTop,
            eyePaint,
            height: 6 * blink,
          );
          _drawUShape(
            canvas,
            centerX + eyeOffset,
            eyeTop,
            eyePaint,
            height: 6 * blink,
          );
        } else {
          canvas.drawLine(
            Offset(centerX - eyeOffset - 5, eyeTop),
            Offset(centerX - eyeOffset + 5, eyeTop),
            eyePaint,
          );
          canvas.drawLine(
            Offset(centerX + eyeOffset - 5, eyeTop),
            Offset(centerX + eyeOffset + 5, eyeTop),
            eyePaint,
          );
        }
        break;
    }
  }

  void _drawUShape(
    Canvas canvas,
    double x,
    double y,
    Paint paint, {
    double width = 10,
    double height = 6,
  }) {
    if (height <= 0) return;
    final rect = Rect.fromCenter(
      center: Offset(x, y),
      width: width * 2,
      height: height * 2,
    );
    canvas.drawArc(rect, 0, pi, false, paint);
  }

  void _drawMouth(Canvas canvas, double centerX, double centerY) {
    final mouthPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;

    final mouthTop = centerY + 5;

    switch (expression) {
      case MascotExpression.smiling:
      case MascotExpression.exciting:
        // Mouth opens and closes slightly
        final openAmount = progress * 8;
        final path = Path()
          ..moveTo(centerX - 15, mouthTop)
          ..quadraticBezierTo(
            centerX,
            mouthTop + 15 + openAmount,
            centerX + 15,
            mouthTop,
          )
          ..quadraticBezierTo(centerX, mouthTop + 5, centerX - 15, mouthTop)
          ..close();
        canvas.drawPath(path, mouthPaint);
        break;
      case MascotExpression.encouraging:
      case MascotExpression.neutral:
        // Small smile shifts slightly
        final shift = progress * 3;
        final path = Path()
          ..moveTo(centerX - 10, mouthTop + shift)
          ..quadraticBezierTo(
            centerX,
            mouthTop + 8 + shift,
            centerX + 10,
            mouthTop + shift,
          )
          ..close();
        canvas.drawPath(path, mouthPaint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
