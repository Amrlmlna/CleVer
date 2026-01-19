import 'dart:async';
import 'package:flutter/material.dart';

class AutoSlideBanner<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final Duration interval;
  final double height;
  final Color activeIndicatorColor;
  final Color inactiveIndicatorColor;

  const AutoSlideBanner({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.interval = const Duration(seconds: 5),
    this.height = 160,
    this.activeIndicatorColor = Colors.black,
    this.inactiveIndicatorColor = const Color(0xFFE0E0E0), // Colors.grey[300]
  });

  @override
  State<AutoSlideBanner<T>> createState() => _AutoSlideBannerState<T>();
}

class _AutoSlideBannerState<T> extends State<AutoSlideBanner<T>> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(widget.interval, (Timer timer) {
      if (_currentPage < widget.items.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              return widget.itemBuilder(context, widget.items[index]);
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.items.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: _currentPage == index ? 24 : 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? widget.activeIndicatorColor
                    : widget.inactiveIndicatorColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
