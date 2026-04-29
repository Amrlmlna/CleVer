import 'package:flutter/material.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class JobSubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const JobSubmitButton({
    super.key,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: isLoading
            ? colorScheme.onSurface.withValues(alpha: 0.5)
            : colorScheme.onSurface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: isLoading
                ? Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: colorScheme.surface,
                        strokeWidth: 2.5,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.continueToReview.toUpperCase(),
                        style: textTheme.titleSmall?.copyWith(
                          color: colorScheme.surface,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        Icons.arrow_outward_rounded,
                        color: colorScheme.surface,
                        size: 20,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
