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
      extendBody: true, // For Bottom Nav Floating
      extendBodyBehindAppBar: true, // For Top Nav Floating
      body: Stack(
        children: [
          navigationShell,
          
          // Top Fade Gradient
          Positioned(
             top: 0,
             left: 0,
             right: 0,
             height: 180, // Taller fade for smoother depth
             child: IgnorePointer(
               child: Container(
                 decoration: BoxDecoration(
                   gradient: LinearGradient(
                     begin: Alignment.topCenter,
                     end: Alignment.bottomCenter,
                     colors: [
                       Theme.of(context).scaffoldBackgroundColor,
                       Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.0),
                     ],
                     stops: const [0.2, 1.0], // Solid for top 20%, then fade
                   ),
                 ),
               ),
             ),
          ),

          // Bottom Fade Gradient
          Positioned(
             bottom: 0,
             left: 0,
             right: 0,
             height: 250, // Much taller to be visible above the Floating Pill
             child: IgnorePointer(
               child: Container(
                 decoration: BoxDecoration(
                   gradient: LinearGradient(
                     begin: Alignment.bottomCenter,
                     end: Alignment.topCenter,
                     colors: [
                       Theme.of(context).scaffoldBackgroundColor,
                       Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.0),
                     ],
                     stops: const [0.3, 1.0], // Keep bottom 30% solid (behind the nav bar)
                   ),
                 ),
               ),
             ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24), // Float margin
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark 
              ? const Color(0xFF1E1E1E) 
              : Colors.black, // Dark Mode: Grey Card, Light Mode: Black Pill
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(context, 0, Icons.home_rounded, 'Home'),
              _buildNavItem(context, 1, Icons.folder_open_rounded, 'Drafts'), // Folder icon for Drafts
              _buildNavItem(context, 2, Icons.person_rounded, 'Profile'),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),

              ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Help'),
              onTap: () {
                Navigator.pop(context); // Close Drawer
                context.go('/profile/help');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, String label) {
    final isSelected = navigationShell.currentIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Active/Inactive Colors
    final activeColor = Colors.white;
    final inactiveColor = Colors.white.withValues(alpha: 0.4);

    return Tooltip(
      message: label,
      child: GestureDetector(
        onTap: () {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected 
                ? (isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.2)) 
                : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(
            icon,
            color: isSelected ? activeColor : inactiveColor,
            size: 24,
          ),
        ),
      ),
    );
  }
}
