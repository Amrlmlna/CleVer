import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

class SpinningTextLoader extends StatefulWidget {
  final List<String> texts;
  final TextStyle? style;
  final Duration interval;
  final List<Color>? shimmerColors;

  const SpinningTextLoader({
    super.key,
    required this.texts,
    this.style,
    this.interval = const Duration(milliseconds: 2000),
    this.shimmerColors,
  });

  @override
  State<SpinningTextLoader> createState() => _SpinningTextLoaderState();
}

class _SpinningTextLoaderState extends State<SpinningTextLoader>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  Timer? _timer;
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
  }

  void _startTimer() {
    _timer = Timer.periodic(widget.interval, (timer) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % widget.texts.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        final offsetAnimation =
            Tween<Offset>(
              begin: const Offset(0.0, 0.5),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
            );

        final opacityAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeIn));

        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            double blur = (1.0 - animation.value) * 2.0;
            return ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 0, sigmaY: blur),
              child: FadeTransition(
                opacity: opacityAnimation,
                child: SlideTransition(position: offsetAnimation, child: child),
              ),
            );
          },
          child: child,
        );
      },
      child: AnimatedBuilder(
        key: ValueKey<int>(_currentIndex),
        animation: _shimmerController,
        builder: (context, child) {
          // Resolve effective style from parent (e.g. ElevatedButton, Card) or ambient default
          final effectiveStyle = DefaultTextStyle.of(context).style.merge(widget.style);
          final textColor = effectiveStyle.color ?? Theme.of(context).colorScheme.onSurface;
          
          // Auto-generate shimmer colors if not explicitly provided
          final colors = widget.shimmerColors ?? [
            textColor.withValues(alpha: 0.3),
            textColor,
            textColor.withValues(alpha: 0.3),
          ];

          return ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: colors,
                stops: const [0.0, 0.5, 1.0],
                begin: Alignment(-1.2 + (_shimmerController.value * 2.4), 0.0),
                end: Alignment(0.2 + (_shimmerController.value * 2.4), 0.0),
                tileMode: TileMode.clamp,
              ).createShader(bounds);
            },
            child: Text(
              widget.texts[_currentIndex],
              style: effectiveStyle,
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }
}
