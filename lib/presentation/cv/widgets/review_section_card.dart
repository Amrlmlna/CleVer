import 'package:flutter/material.dart';

class ReviewSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isExpanded;
  final Function(bool) onExpansionChanged;
  final Widget child;

  const ReviewSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.isExpanded,
    required this.onExpansionChanged,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Theme Aware Colors
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? (isDark ? const Color(0xFF1E1E1E) : Colors.white),
        borderRadius: BorderRadius.circular(24),
        border: isDark 
            ? Border.all(color: Colors.white.withOpacity(0.05))
            : null,
        boxShadow: isDark ? [] : [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ExpansionTile(
          initiallyExpanded: isExpanded,
          onExpansionChanged: onExpansionChanged,
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isDark ? Colors.white : Colors.black,
              size: 20,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isDark ? Colors.white : Colors.black,
              fontFamily: 'Outfit',
            ),
          ),
          shape: const Border(), // Remove expanded border
          collapsedShape: const Border(), // Remove collapsed border
          childrenPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          children: [
            Divider(height: 1, color: isDark ? Colors.white12 : Colors.grey[200]),
            const SizedBox(height: 20),
            child,
          ],
        ),
    );
  }
}
