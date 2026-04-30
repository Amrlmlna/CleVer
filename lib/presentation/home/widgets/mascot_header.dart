import 'dart:math';
import 'package:flutter/material.dart';
import '../models/mascot_state.dart';

class MascotHeader extends StatelessWidget {
  final MascotExpression expression;
  final Color mascotColor;

  const MascotHeader({
    super.key,
    required this.expression,
    required this.mascotColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: double.infinity,
      child: CustomPaint(
        painter: MascotPainter(expression: expression, color: mascotColor),
      ),
    );
  }
}

class MascotPainter extends CustomPainter {
  final MascotExpression expression;
  final Color color;

  MascotPainter({required this.expression, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final bodyPath = Path()
      ..moveTo(0, size.height)
      ..quadraticBezierTo(
        size.width / 2,
        size.height - (size.height * 1.2),
        size.width,
        size.height,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(bodyPath, paint);

    final centerX = size.width / 2;
    final centerY = size.height - 40;

    _drawEyes(canvas, centerX, centerY);
    _drawMouth(canvas, centerX, centerY);
  }

  void _drawEyes(Canvas canvas, double centerX, double centerY) {
    final eyePaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final eyeOffset = 25.0;
    final eyeTop = centerY - 15;

    switch (expression) {
      case MascotExpression.smiling:
      case MascotExpression.neutral:
        _drawUShape(canvas, centerX - eyeOffset, eyeTop, eyePaint);
        _drawUShape(canvas, centerX + eyeOffset, eyeTop, eyePaint);
        break;
      case MascotExpression.exciting:
        _drawUShape(
          canvas,
          centerX - eyeOffset,
          eyeTop,
          eyePaint,
          width: 12,
          height: 8,
        );
        _drawUShape(
          canvas,
          centerX + eyeOffset,
          eyeTop,
          eyePaint,
          width: 12,
          height: 8,
        );
        break;
      case MascotExpression.encouraging:
        _drawUShape(canvas, centerX - eyeOffset, eyeTop, eyePaint);
        canvas.drawLine(
          Offset(centerX + eyeOffset - 6, eyeTop),
          Offset(centerX + eyeOffset + 6, eyeTop),
          eyePaint,
        );
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
    final rect = Rect.fromCenter(
      center: Offset(x, y),
      width: width * 2,
      height: height * 2,
    );
    canvas.drawArc(rect, 0, pi, false, paint);
  }

  void _drawMouth(Canvas canvas, double centerX, double centerY) {
    final mouthPaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    final mouthTop = centerY + 5;

    switch (expression) {
      case MascotExpression.smiling:
      case MascotExpression.exciting:
        final path = Path()
          ..moveTo(centerX - 15, mouthTop)
          ..quadraticBezierTo(centerX, mouthTop + 15, centerX + 15, mouthTop)
          ..quadraticBezierTo(centerX, mouthTop + 5, centerX - 15, mouthTop)
          ..close();
        canvas.drawPath(path, mouthPaint);
        break;
      case MascotExpression.encouraging:
      case MascotExpression.neutral:
        final path = Path()
          ..moveTo(centerX - 10, mouthTop)
          ..quadraticBezierTo(centerX, mouthTop + 8, centerX + 10, mouthTop)
          ..close();
        canvas.drawPath(path, mouthPaint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
