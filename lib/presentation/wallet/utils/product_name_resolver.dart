import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class ProductNameResolver {
  /// Returns (title, description) for a package based on its identifier.
  static (String, String) resolve(Package package, AppLocalizations l10n) {
    final id = '${package.identifier} ${package.storeProduct.identifier}'
        .toLowerCase();
    if (id.contains('24h')) return (l10n.product24hTitle, l10n.product24hDesc);
    if (id.contains('3d')) return (l10n.product3dTitle, l10n.product3dDesc);
    if (id.contains('weekly')) {
      return (l10n.productWeeklyTitle, l10n.productWeeklyDesc);
    }
    if (id.contains('monthly')) {
      return (l10n.productMonthlyTitle, l10n.productMonthlyDesc);
    }
    if (id.contains('yearly')) {
      return (l10n.productYearlyTitle, l10n.productYearlyDesc);
    }
    return (l10n.jobHunterPass, '');
  }

  /// Returns a short display name from a raw product identifier string.
  static String getDisplayName(String? rawName, AppLocalizations l10n) {
    if (rawName == null) return l10n.jobHunterPass;
    final lower = rawName.toLowerCase();
    if (lower.contains('24h') || lower.contains('24 jam')) {
      return l10n.product24hTitle;
    }
    if (lower.contains('3d') || lower.contains('3 hari')) {
      return l10n.product3dTitle;
    }
    if (lower.contains('weekly') || lower.contains('minggu')) {
      return l10n.productWeeklyTitle;
    }
    if (lower.contains('monthly') || lower.contains('bulan')) {
      return l10n.productMonthlyTitle;
    }
    if (lower.contains('yearly') || lower.contains('tahun')) {
      return l10n.productYearlyTitle;
    }
    return l10n.jobHunterPass;
  }
}
