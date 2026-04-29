import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;

import '../../auth/utils/auth_guard.dart';
import '../../profile/widgets/profile_stacked_sections.dart';
import '../utils/power_plus_navigation_handler.dart';
import '../../../core/router/app_routes.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class FloatingActionCircle extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;
  const FloatingActionCircle({super.key, required this.navigationShell});

  @override
  ConsumerState<FloatingActionCircle> createState() =>
      _FloatingActionCircleState();
}

class _FloatingActionCircleState extends ConsumerState<FloatingActionCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  bool _isOpen = false;
  bool _showSections = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: math.pi / 4,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isOpen = !_isOpen;
      if (!_isOpen) {
        _showSections = false;
        _controller.reverse();
      } else {
        _controller.forward();
      }
    });
  }

  void _handleSectionClick(SectionType type) {
    _toggleMenu();
    PowerPlusNavigationHandler.openSection(
      context,
      widget.navigationShell,
      type,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        // Backdrop (Ghost positioned to not overflow layout)
        if (_isOpen)
          Positioned(
            top: -2000,
            left: -1000,
            right: -1000,
            bottom: -1000,
            child: GestureDetector(
              onTap: _toggleMenu,
              behavior: HitTestBehavior.opaque,
              child: Container(color: Colors.transparent),
            ),
          ),

        // THE PILL (Single Container)
        AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutBack,
          width: 64,
          height: _isOpen ? (_showSections ? 420 : 240) : 64,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: _isOpen
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Icons Layer
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: _showSections
                            ? _buildSectionIcons()
                            : _buildMainIcons(l10n),
                      ),
                    ),
                    _buildMainToggle(),
                  ],
                )
              : _buildMainToggle(),
        ),
      ],
    );
  }

  Widget _buildMainToggle() {
    return GestureDetector(
      onTap: _toggleMenu,
      child: Container(
        width: 64,
        height: 64,
        alignment: Alignment.center,
        child: AnimatedBuilder(
          animation: _rotationAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotationAnimation.value,
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 32,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMainIcons(AppLocalizations l10n) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        key: const ValueKey('main_icons'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _PillIcon(
            icon: Icons.description_rounded,
            onTap: AuthGuard.protected(
              context,
              () {
                _toggleMenu();
                context.push(AppRoutes.createJobInput);
              },
              featureTitle: l10n.authWallCreateCV,
              featureDescription: l10n.authWallCreateCVDesc,
            ),
          ),
          const SizedBox(height: 16),
          _PillIcon(
            icon: Icons.person_add_alt_1_rounded,
            onTap: () => setState(() => _showSections = true),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSectionIcons() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        key: const ValueKey('section_icons'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _PillIcon(
            icon: Icons.business_center_rounded,
            onTap: () => _handleSectionClick(SectionType.experience),
          ),
          const SizedBox(height: 10),
          _PillIcon(
            icon: Icons.school_rounded,
            onTap: () => _handleSectionClick(SectionType.education),
          ),
          const SizedBox(height: 10),
          _PillIcon(
            icon: Icons.psychology_rounded,
            onTap: () => _handleSectionClick(SectionType.skills),
          ),
          const SizedBox(height: 10),
          _PillIcon(
            icon: Icons.workspace_premium_rounded,
            onTap: () => _handleSectionClick(SectionType.certifications),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => setState(() => _showSections = false),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white70,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PillIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _PillIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      ),
    );
  }
}
