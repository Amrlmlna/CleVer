import 'package:flutter/material.dart';
import 'floating_nav_item.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class FloatingNavbarCapsule extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTap;
  final GlobalKey draftsKey;
  final GlobalKey profileKey;

  const FloatingNavbarCapsule({
    super.key,
    required this.currentIndex,
    required this.onTabTap,
    required this.draftsKey,
    required this.profileKey,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingNavItem(
              index: 0,
              icon: Icons.home_outlined,
              activeIcon: Icons.home_rounded,
              label: AppLocalizations.of(context)!.home,
              currentIndex: currentIndex,
              onTap: () => onTabTap(0),
            ),
            FloatingNavItem(
              index: 1,
              icon: Icons.description_outlined,
              activeIcon: Icons.description_rounded,
              label: AppLocalizations.of(context)!.myDrafts,
              currentIndex: currentIndex,
              onTap: () => onTabTap(1),
              itemKey: draftsKey,
            ),
            FloatingNavItem(
              index: 3,
              icon: Icons.person_outline,
              activeIcon: Icons.person_rounded,
              label: AppLocalizations.of(context)!.profile,
              currentIndex: currentIndex,
              onTap: () => onTabTap(3),
              itemKey: profileKey,
            ),
          ],
        ),
      ),
    );
  }
}
