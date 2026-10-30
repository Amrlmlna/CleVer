import 'package:flutter/material.dart';

import '../../../../core/theme/clever/clever_colors.dart';
import '../../../../core/theme/clever/clever_typography.dart';

class CleverApplicationSlider extends StatelessWidget {
  const CleverApplicationSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTrack(value: value, min: min, max: max, onChanged: onChanged),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _HintLabel(min.toString()),
              _HintLabel('${min + (max - min) ~/ 2}'),
              _HintLabel('$max+'),
            ],
          ),
        ),
      ],
    );
  }
}

class _HintLabel extends StatelessWidget {
  const _HintLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: CleverTypography.label.copyWith(
        color: CleverColors.textPrimary.withValues(alpha: 0.25),
      ),
    );
  }
}

class SliderTrack extends StatefulWidget {
  const SliderTrack({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  State<SliderTrack> createState() => _SliderTrackState();
}

class _SliderTrackState extends State<SliderTrack> {
  double? _dragFraction;

  double get _fraction =>
      _dragFraction ?? (widget.value - widget.min) / (widget.max - widget.min);

  void _update(Offset localPosition, double width) {
    final fraction = (localPosition.dx / width).clamp(0.0, 1.0);
    setState(() => _dragFraction = fraction);
    widget.onChanged(
      widget.min + (fraction * (widget.max - widget.min)).round(),
    );
  }

  void _endDrag() => setState(() => _dragFraction = null);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragStart: (d) => _update(d.localPosition, width),
          onHorizontalDragUpdate: (d) => _update(d.localPosition, width),
          onHorizontalDragEnd: (_) => _endDrag(),
          onHorizontalDragCancel: _endDrag,
          onTapUp: (d) => _update(d.localPosition, width),
          child: SizedBox(
            height: 76,
            child: CustomPaint(
              painter: _SliderTrackPainter(fraction: _fraction),
              child: Align(
                alignment: Alignment(_fraction * 2 - 1, -0.55),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: CleverColors.surfaceInverse,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${widget.value}',
                    style: CleverTypography.label.copyWith(
                      color: CleverColors.textOnDark,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SliderTrackPainter extends CustomPainter {
  const _SliderTrackPainter({required this.fraction});

  final double fraction;

  @override
  void paint(Canvas canvas, Size size) {
    final trackTop = size.height * 0.62;
    const trackHeight = 5.0;
    const thumbRadius = 8.5;

    final fillPaint = Paint()..color = CleverColors.bgOnboarding;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, trackTop - trackHeight / 2, size.width, trackHeight),
        const Radius.circular(2.5),
      ),
      Paint()..color = CleverColors.surfaceRaised,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          0,
          trackTop - trackHeight / 2,
          size.width * fraction,
          trackHeight,
        ),
        const Radius.circular(2.5),
      ),
      fillPaint,
    );

    final thumbX = size.width * fraction;
    canvas.drawCircle(
      Offset(thumbX, trackTop),
      thumbRadius,
      Paint()..color = CleverColors.bgOnboarding,
    );

    final rulerPaint = Paint()
      ..color = CleverColors.textPrimary.withValues(alpha: 0.25)
      ..strokeWidth = 1;
    const minorSpacing = 17.0;
    for (double x = minorSpacing; x < size.width; x += minorSpacing) {
      canvas.drawLine(
        Offset(x, trackTop + thumbRadius + 6),
        Offset(x, trackTop + thumbRadius + 10),
        rulerPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_SliderTrackPainter oldDelegate) =>
      oldDelegate.fraction != fraction;
}
