import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class LockedOverlay extends StatelessWidget {
  final bool isPremium;
  final int requiredCredits;

  const LockedOverlay({
    super.key,
    required this.isPremium,
    required this.requiredCredits,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          color: colorScheme.scrim.withValues(alpha: 0.3),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.surface.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.lock_rounded,
                    color: colorScheme.surface,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isPremium
                        ? AppLocalizations.of(context)!.premium.toUpperCase()
                        : AppLocalizations.of(context)!.locked.toUpperCase(),
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(
                    context,
                  )!.creditsCount(requiredCredits).toUpperCase(),
                  style: TextStyle(
                    color: colorScheme.surface.withValues(alpha: 0.9),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
