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
    // Keep it White Card regardless of theme for "High Contrast" look
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        // Force Light theme for the ExpansionTile chrome
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          brightness: Brightness.light, 
          // Ensure Text colors are correct for Light theme
          textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.black, displayColor: Colors.black),
        ),
        child: ExpansionTile(
          initiallyExpanded: isExpanded,
          onExpansionChanged: onExpansionChanged,
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isExpanded ? Colors.black : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isExpanded ? Colors.white : Colors.black,
              size: 20,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black, // Always black on white card
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          children: [
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }
}
