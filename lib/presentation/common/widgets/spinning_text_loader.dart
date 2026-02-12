import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

class SpinningTextLoader extends StatefulWidget {
  final List<String> texts;
  final TextStyle? style;
  final Duration interval;

  const SpinningTextLoader({
    super.key,
    required this.texts,
    this.style,
    this.interval = const Duration(milliseconds: 2000),
  });

  @override
  State<SpinningTextLoader> createState() => _SpinningTextLoaderState();
}

class _SpinningTextLoaderState extends State<SpinningTextLoader> {
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(widget.interval, (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.texts.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0.0, 0.5), // Start slightly below
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutBack));

        final opacityAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeIn));
        
        // Blur effect during transition
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            double blur = (1.0 - animation.value) * 2.0; // Blur fades out as it settles
            return ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 0, sigmaY: blur),
              child: FadeTransition(
                opacity: opacityAnimation,
                child: SlideTransition(
                  position: offsetAnimation,
                  child: child,
                ),
              ),
            );
          },
          child: child,
        );
      },
      child: Text(
        widget.texts[_currentIndex],
        key: ValueKey<int>(_currentIndex),
        style: widget.style,
        textAlign: TextAlign.center,
      ),
    );
  }
}
