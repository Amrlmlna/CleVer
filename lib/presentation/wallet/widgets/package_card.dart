import 'package:flutter/material.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../models/credit_package.dart';

class PackageCard extends StatelessWidget {
  final CreditPackage package;
  final AppLocalizations l10n;
  final bool isIdr;
  final bool isSelected;
  final VoidCallback onTap;

  const PackageCard({
    super.key,
    required this.package,
    required this.l10n,
    required this.isIdr,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final price = isIdr ? package.priceIdr : package.priceUsd;
    final perCredit = isIdr ? package.perCreditIdr : package.perCreditUsd;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.onSurface.withValues(alpha: 0.05)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? colorScheme.onSurface
                : colorScheme.onSurface.withValues(alpha: 0.1),
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        l10n.creditsCount(package.credits),
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colorScheme.onSurface,
                          letterSpacing: -0.5,
                        ),
                      ),
                      if (package.isPopular) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.onSurface,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            l10n.popularBadge.toUpperCase(),
                            style: textTheme.labelSmall?.copyWith(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: colorScheme.surface,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '$perCredit${l10n.perCredit}',
                        style: textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (package.savingsPercent != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          l10n.savePercent(package.savingsPercent!),
                          style: textTheme.labelSmall?.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                  ),
                ),
                if (isSelected) 
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Icon(
                      Icons.check_circle_rounded,
                      size: 18,
                      color: colorScheme.onSurface,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
