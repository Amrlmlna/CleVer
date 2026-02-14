import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../common/widgets/custom_app_bar.dart';

class MainWrapperPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainWrapperPage({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          navigationShell,
        ],
      ),
      floatingActionButton: _buildCenterFAB(context),
      floatingActionButtonLocation: const _CenterDockedFabLocation(),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  /// Overlapped center FAB with reduced elevation
  Widget _buildCenterFAB(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Color(0xFFE0E0E0),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1), // Reduced from 0.15
            blurRadius: 6, // Reduced from 8
            offset: const Offset(0, 2), // Reduced from 4
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/create/job-input'),
          customBorder: const CircleBorder(),
          child: const Icon(
            Icons.add,
            color: Colors.black,
            size: 32,
          ),
        ),
      ),
    );
  }

  /// Bottom navigation with 2 items and glass effect
  Widget _buildBottomNav(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.transparent, // Make outer layer transparent as requested
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2), 
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Glass blur
          child: Container(
            color: (isDark ? const Color(0xFF1E1E1E) : Colors.black).withValues(alpha: 0.8), // Inner background color
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20), // Increased height (was 12)
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Home
                _buildNavItem(context, 0, Icons.home_rounded, 'Home'),
                
                // Spacer for center FAB
                const SizedBox(width: 60), 
                
                // Profile
                _buildNavItem(context, 1, Icons.person_rounded, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, String label) {
    final isSelected = navigationShell.currentIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Use pure white for selected, and transparent white for unselected
    final activeColor = Colors.white;
    final inactiveColor = Colors.white.withValues(alpha: 0.5);

    return Tooltip(
      message: label,
      child: InkWell(
        onTap: () => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.2))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: isSelected ? activeColor : inactiveColor,
            size: 26, // Slightly larger icons
          ),
        ),
      ),
    );
  }
}

/// Custom FAB location that stays fixed and doesn't move for SnackBar
class _CenterDockedFabLocation extends StandardFabLocation
    with FabCenterOffsetX, FabDockedOffsetY {
  const _CenterDockedFabLocation();

  @override
  double getOffsetY(ScaffoldPrelayoutGeometry scaffoldGeometry, double adjustment) {

    final double bottomSheetHeight = scaffoldGeometry.bottomSheetSize.height;
    final double fabHeight = scaffoldGeometry.floatingActionButtonSize.height;
    final double safeAreaBottom = scaffoldGeometry.minInsets.bottom;
    
    // Position FAB relative to bottom safe area + nav bar height
    // Scaffold Height - (Margin 24 + NavHeight 56 + Half FAB 32) + Adjustment
    double fabY = scaffoldGeometry.scaffoldSize.height - 120 - safeAreaBottom; 
    
    // Only adjust for bottom sheet, not snackbar
    if (bottomSheetHeight > 0.0) {
      fabY = scaffoldGeometry.scaffoldSize.height - bottomSheetHeight - fabHeight - 16;
    }

    final double maxFabY = scaffoldGeometry.scaffoldSize.height - fabHeight;
    return fabY.clamp(0.0, maxFabY);
  }
}
