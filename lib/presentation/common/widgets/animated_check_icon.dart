import 'package:flutter/material.dart';

/// A premium animated check icon that "draws" itself.
class AnimatedCheckIcon extends StatefulWidget {
  final double size;
  final Color color;
  final Duration duration;
  final double strokeWidth;

  const AnimatedCheckIcon({
    super.key,
    this.size = 42.0,
    this.color = Colors.white,
    this.duration = const Duration(milliseconds: 1000),
    this.strokeWidth = 4.0,
  });

  @override
  State<AnimatedCheckIcon> createState() => _AnimatedCheckIconState();
}

class _AnimatedCheckIconState extends State<AnimatedCheckIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: _CheckPainter(
              progress: _animation.value,
              color: widget.color,
              strokeWidth: widget.strokeWidth,
            ),
          );
        },
      ),
    );
  }
}

class _CheckPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _CheckPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    
    // Starting point of the checkmark
    final start = Offset(size.width * 0.2, size.height * 0.5);
    // Middle junction
    final mid = Offset(size.width * 0.45, size.height * 0.75);
    // End point
    final end = Offset(size.width * 0.8, size.height * 0.3);

    path.moveTo(start.dx, start.dy);

    if (progress < 0.4) {
      // Drawing the first segment
      final segmentProgress = progress / 0.4;
      path.lineTo(
        start.dx + (mid.dx - start.dx) * segmentProgress,
        start.dy + (mid.dy - start.dy) * segmentProgress,
      );
    } else {
      // First segment is done
      path.lineTo(mid.dx, mid.dy);
      
      // Drawing the second segment
      final segmentProgress = (progress - 0.4) / 0.6;
      path.lineTo(
        mid.dx + (end.dx - mid.dx) * segmentProgress,
        mid.dy + (end.dy - mid.dy) * segmentProgress,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CheckPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
