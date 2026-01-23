import 'dart:async';
import 'package:flutter/material.dart';

class CVLoadingScreen extends StatefulWidget {
  const CVLoadingScreen({super.key});

  @override
  State<CVLoadingScreen> createState() => _CVLoadingScreenState();
}

class _CVLoadingScreenState extends State<CVLoadingScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  int _currentStep = 0;
  final List<String> _steps = [
    "Menganalisa Profil...",
    "Menyusun Struktur...",
    "Menulis Summary Profesional...",
    "Memoles Tata Letak...", 
    "Finishing Touches... ✨"
  ];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    
    // Pulse Animation for the Icon
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Step Text Cycler
    _timer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (!mounted) return;
      setState(() {
        _currentStep = (_currentStep + 1) % _steps.length;
      });
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated Icon Ring
          ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.05) : Colors.blue.withOpacity(0.05),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? Colors.white24 : Colors.blue.withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.auto_awesome, 
                size: 48, 
                color: isDark ? Colors.white : Colors.blueAccent,
              ),
            ),
          ),
          
          const SizedBox(height: 48),

          // Animated Changing Text
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.2), 
                    end: Offset.zero
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Text(
              _steps[_currentStep],
              key: ValueKey<int>(_currentStep),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Outfit',
                color: isDark ? Colors.white : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 12),
          
          // Sub-message
          Text(
            "Tunggu sebentar ya, AI lagi kerja keras.",
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
