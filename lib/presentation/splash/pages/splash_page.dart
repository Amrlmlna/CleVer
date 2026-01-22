import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // 1. Increase ImageCache for large sequence
    PaintingBinding.instance.imageCache.maximumSizeBytes = 300 * 1024 * 1024; // 300MB

    // 2. Precache Images
    await _precacheSequence();

    // 3. Navigate to next screen
    // We go to '/' and let the AppRouter's redirect logic decide 
    // whether to go to Home or Onboarding.
    if (mounted) {
      context.go('/'); 
    }
  }

  Future<void> _precacheSequence() async {
    try {
      final futures = <Future>[];
      // Frame range 1 to 192
      const startFrame = 1;
      const frameCount = 192;
      
      for (int i = 0; i < frameCount; i++) {
        final frameIndex = startFrame + i;
        final frameStr = frameIndex.toString().padLeft(3, '0');
        final path = 'assets/sequence/ezgif-frame-$frameStr.jpg';
        futures.add(precacheImage(AssetImage(path), context));
      }
      
      await Future.wait(futures);
    } catch (e) {
      debugPrint("Error precaching in Splash: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Matches user's dark theme
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.description, // Placeholder for CV Logo
                size: 64,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 32),
            // Minimal Loading Indicator
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
