import 'package:flutter/material.dart';

import '../../../../core/theme/clever/clever_colors.dart';
import '../../../../core/theme/clever/clever_typography.dart';

/// Three-stop slider with playful animal anchors per the staging design.
/// The thumb only rests on the first, middle, and last stop.
class CleverApplicationSlider extends StatelessWidget {
  const CleverApplicationSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 10,
    this.mid = 50,
    this.max = 100,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int mid;
  final int max;

  static const _stopIcons = [
    'assets/images/catterpillar-40513.png',
    'assets/images/antelope-40490.png',
    'assets/images/jaguar.png',
  ];

  List<int> get _stops => [min, mid, max];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTrack(
          stops: _stops,
          selectedIndex: _stops.indexOf(value).clamp(0, 2),
          icons: _stopIcons,
          onChanged: onChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _HintLabel('$min'),
            _HintLabel('$mid'),
            _HintLabel('$max+'),
          ],
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

class SliderTrack extends StatelessWidget {
  const SliderTrack({
    super.key,
    required this.stops,
    required this.selectedIndex,
    required this.icons,
    required this.onChanged,
  });

  final List<int> stops;
  final int selectedIndex;
  final List<String> icons;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapUp: (d) => _select(d.localPosition.dx, width),
          onHorizontalDragUpdate: (d) => _select(d.localPosition.dx, width),
          child: SizedBox(
            height: 84,
            child: CustomPaint(
              painter: _SliderTrackPainter(
                fraction: selectedIndex / (stops.length - 1),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  for (var i = 0; i < icons.length; i++)
                    Align(
                      alignment: Alignment(i * 2.0 - 1.0, -0.72),
                      child: Image.asset(
                        icons[i],
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _select(double dx, double width) {
    final fraction = (dx / width).clamp(0.0, 1.0);
    final index = (fraction * (stops.length - 1)).round();
    if (stops[index] != stops[selectedIndex]) {
      onChanged(stops[index]);
    }
  }
}

class _SliderTrackPainter extends CustomPainter {
  const _SliderTrackPainter({required this.fraction});

  final double fraction;

  @override
  void paint(Canvas canvas, Size size) {
    const trackHeight = 5.0;
    const thumbRadius = 8.5;
    final trackTop = size.height * 0.66;

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
      Paint()..color = CleverColors.bgOnboarding,
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
    for (
      double x = minorSpacing;
      x < size.width - minorSpacing;
      x += minorSpacing
    ) {
      canvas.drawLine(
        Offset(x, trackTop + thumbRadius + 8),
        Offset(x, trackTop + thumbRadius + 12),
        rulerPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_SliderTrackPainter oldDelegate) =>
      oldDelegate.fraction != fraction;
}
