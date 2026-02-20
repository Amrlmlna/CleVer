import 'package:flutter/material.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class TailoredDataHeader extends StatelessWidget {
  final bool isDark;

  const TailoredDataHeader({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1), 
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.tailoredDataMessage,
              style: TextStyle(
                color: isDark ? Colors.blue[100] : Colors.blue[900], 
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
