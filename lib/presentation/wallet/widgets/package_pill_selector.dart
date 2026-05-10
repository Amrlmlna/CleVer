import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class PackagePillSelector extends StatelessWidget {
  final List<Package> packages;
  final Package? selectedPackage;
  final ValueChanged<Package> onSelected;
  final AppLocalizations l10n;

  const PackagePillSelector({
    super.key,
    required this.packages,
    required this.selectedPackage,
    required this.onSelected,
    required this.l10n,
  });

  static String _getPackageName(Package package, AppLocalizations l10n) {
    final id = '${package.identifier} ${package.storeProduct.identifier}'
        .toLowerCase();
    if (id.contains('3d') || id.contains('3 hari')) return l10n.product3dTitle;
    if (id.contains('weekly') || id.contains('minggu')) {
      return l10n.productWeeklyTitle;
    }
    if (id.contains('monthly') || id.contains('bulan')) {
      return l10n.productMonthlyTitle;
    }
    if (id.contains('yearly') || id.contains('tahun')) {
      return l10n.productYearlyTitle;
    }
    return l10n.jobHunterPass;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: List.generate(packages.length, (index) {
        final package = packages[index];
        final isSelected = selectedPackage?.identifier == package.identifier;
        final isBestValue = index == packages.length - 1 && packages.length > 1;
        final name = _getPackageName(package, l10n);

        return Expanded(
          child: GestureDetector(
            onTap: () => onSelected(package),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              margin: EdgeInsets.only(
                left: index == 0 ? 0 : 5,
                right: index == packages.length - 1 ? 0 : 5,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
              decoration: BoxDecoration(
                color: isSelected ? colorScheme.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.outlineVariant,
                  width: 1.5,
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: isSelected
                              ? colorScheme.surface
                              : colorScheme.onSurface,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        package.storeProduct.priceString,
                        textAlign: TextAlign.center,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: isSelected
                              ? colorScheme.surface
                              : colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  if (isBestValue)
                    Positioned(
                      top: -8,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          l10n.bestValue.toUpperCase(),
                          style: TextStyle(
                            fontSize: 7,
                            fontWeight: FontWeight.w900,
                            color: colorScheme.surface,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
