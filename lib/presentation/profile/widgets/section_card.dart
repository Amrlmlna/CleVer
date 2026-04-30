import 'package:flutter/material.dart';

class ProfileSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final Color iconBgColor;
  final Color iconColor;
  final VoidCallback onTap;
  final double bottomOverlap;
  final Widget? bottomContent;

  const ProfileSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.iconBgColor,
    required this.iconColor,
    required this.onTap,
    this.bottomOverlap = 0.0,
    this.bottomContent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: 'section_card_$title',
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(40),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
            child: Column(
              mainAxisSize: bottomContent != null
                  ? MainAxisSize.max
                  : MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: iconBgColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: iconColor, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_outward_rounded,
                        color: Colors.black,
                        size: 18,
                      ),
                    ),
                  ],
                ),
                if (bottomContent != null)
                  Expanded(child: bottomContent!)
                else if (bottomOverlap > 0)
                  SizedBox(height: bottomOverlap, width: double.infinity),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
