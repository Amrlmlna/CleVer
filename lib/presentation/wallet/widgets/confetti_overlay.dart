import 'dart:math';
import 'package:flutter/material.dart';
import 'package:clever/core/theme/app_colors.dart';

class ConfettiOverlay extends StatefulWidget {
  final bool show;

  const ConfettiOverlay({super.key, required this.show});

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_ConfettiPiece> _pieces;
  final _random = Random();

  static const _colors = [
    AppColors.accentSage,
    AppColors.accentLavender,
    AppColors.accentMist,
    AppColors.accentLemon,
    AppColors.accentPeach,
    AppColors.vibrantPurple,
    AppColors.vibrantBlue,
    AppColors.vibrantGreen,
    AppColors.premiumGold,
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _pieces = _generatePieces(50);
    if (widget.show) _controller.forward();
  }

  @override
  void didUpdateWidget(ConfettiOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show && !oldWidget.show) {
      _pieces = _generatePieces(50);
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<_ConfettiPiece> _generatePieces(int count) {
    return List.generate(count, (_) {
      return _ConfettiPiece(
        color: _colors[_random.nextInt(_colors.length)],
        x: _random.nextDouble(),
        startY: -0.15 - _random.nextDouble() * 0.3,
        size: 4 + _random.nextDouble() * 6,
        rotation: _random.nextDouble() * pi * 2,
        rotationSpeed: (_random.nextDouble() - 0.5) * 6,
        fallSpeed: 0.3 + _random.nextDouble() * 0.5,
        drift: (_random.nextDouble() - 0.5) * 0.15,
        isCircle: _random.nextBool(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.show) return const SizedBox.shrink();

    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            size: Size.infinite,
            painter: _ConfettiPainter(
              pieces: _pieces,
              progress: _controller.value,
            ),
          );
        },
      ),
    );
  }
}

class _ConfettiPiece {
  final Color color;
  final double x;
  final double startY;
  final double size;
  final double rotation;
  final double rotationSpeed;
  final double fallSpeed;
  final double drift;
  final bool isCircle;

  const _ConfettiPiece({
    required this.color,
    required this.x,
    required this.startY,
    required this.size,
    required this.rotation,
    required this.rotationSpeed,
    required this.fallSpeed,
    required this.drift,
    required this.isCircle,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiPiece> pieces;
  final double progress;

  _ConfettiPainter({required this.pieces, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final piece in pieces) {
      final t = (progress * piece.fallSpeed).clamp(0.0, 1.0);
      final y = (piece.startY + t * 1.3) * size.height;
      final x =
          piece.x * size.width +
          sin(progress * 4 + piece.x * 10) * piece.drift * size.width;
      final rot = piece.rotation + progress * piece.rotationSpeed;

      if (y < -piece.size || y > size.height + piece.size) continue;

      final paint = Paint()
        ..color = piece.color.withValues(alpha: (1.0 - t * 0.7).clamp(0.0, 1.0))
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rot);

      if (piece.isCircle) {
        canvas.drawCircle(Offset.zero, piece.size * 0.4, paint);
      } else {
        final rect = RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: piece.size * 1.4,
            height: piece.size * 0.6,
          ),
          const Radius.circular(1),
        );
        canvas.drawRRect(rect, paint);
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
