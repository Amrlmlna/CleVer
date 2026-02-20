import 'package:flutter/material.dart';

import '../widgets/image_sequence_animator.dart';
import 'onboarding_page.dart'; // Contains the form content
import 'package:flutter/scheduler.dart';

class OnboardingWelcomePage extends StatefulWidget {
  const OnboardingWelcomePage({super.key});

  @override
  State<OnboardingWelcomePage> createState() => _OnboardingWelcomePageState();
}



class _OnboardingWelcomePageState extends State<OnboardingWelcomePage> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late Ticker _ticker;
  
  // State for Scroll-Driven Animation
  double _currentFrame = 1.0;     // The visual frame (float)
  double _targetFrame = 1.0;      // The target frame based on scroll
  
  final int _startFrame = 1;
  final int _frameCount = 192;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Ticker ensures we update the animation frame smoothly even if scroll stops
    _ticker = createTicker(_tick);
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _tick(Duration elapsed) {
    // Linear Interpolation (Lerp) for Inertia / Decay Stop
    // Moves currentFrame towards targetFrame by 10% each tick (approx 60fps)
    if ((_targetFrame - _currentFrame).abs() > 0.05) {
      setState(() {
        _currentFrame += (_targetFrame - _currentFrame) * 0.1;
      });
    } else if (_currentFrame != _targetFrame) {
      // Snap to exact target if very close
      setState(() {
        _currentFrame = _targetFrame;
      });
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final offset = _scrollController.offset;
    final screenHeight = MediaQuery.of(context).size.height;
    final maxAnimDist = screenHeight * 0.6; 

    double progress = (offset / maxAnimDist).clamp(0.0, 1.0);
    
    _targetFrame = (_startFrame + (progress * (_frameCount - 1))).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    
    final height = MediaQuery.of(context).size.height;
    
    final int displayFrame = _currentFrame.round();
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/sequence/ezgif-frame-001.jpg',
              fit: BoxFit.cover,
              gaplessPlayback: true,
            ),
          ),

          Positioned.fill(
             child: ImageSequenceAnimator(
              folderPath: 'assets/sequence', 
              fileNamePrefix: 'ezgif-frame-',     
              fileExtension: 'jpg',
              startFrame: _startFrame,
              frameCount: _frameCount,
              fps: 24,
              explicitFrame: displayFrame,
            ),
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
          ),

          SingleChildScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: height * 0.7),

                  Container(
                    height: height * 0.85,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                     boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 20,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: const OnboardingPage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
