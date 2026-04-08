import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const SectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.onSurface,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 16,
          ),
        ),
        shape: const Border(),
        childrenPadding: const EdgeInsets.all(16),
        children: [child],
      ),
    );
  }
}
