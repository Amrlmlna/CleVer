import 'package:flutter/material.dart';

class FloatingNavItem extends StatelessWidget {
  final int index;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int currentIndex;
  final VoidCallback onTap;
  final Key? itemKey;

  const FloatingNavItem({
    super.key,
    required this.index,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.currentIndex,
    required this.onTap,
    this.itemKey,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentIndex == index;
    final color = isSelected ? Colors.black : Colors.grey.shade400;

    return Expanded(
      child: InkWell(
        key: itemKey,
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isSelected ? activeIcon : icon, color: color, size: 24),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: color,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
