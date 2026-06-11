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
      return (
        l10n.productWeeklyTitle,
        l10n.productWeeklyDesc(_formatPerDay(package, 7)),
      );
    }
    if (id.contains('monthly')) {
      return (
        l10n.productMonthlyTitle,
        l10n.productMonthlyDesc(_formatPerDay(package, 30)),
      );
    }
    if (id.contains('yearly')) {
      return (
        l10n.productYearlyTitle,
        l10n.productYearlyDesc(_formatPerDay(package, 365)),
      );
    }
    if (id.contains('lifetime') || id.contains('selamanya')) {
      return (l10n.productLifetimeTitle, l10n.productLifetimeDesc);
    }
    return (l10n.jobHunterPass, '');
  }

  /// Computes per-day price and formats as "Rp 3.500" style.
  static String _formatPerDay(Package package, int days) {
    final raw = package.storeProduct.price;
    final perDay = (raw / days).round();

    // Extract currency prefix from the full price string.
    // e.g. "Rp 25.000" → "Rp", "$9.99" → "$"
    final fullPrice = package.storeProduct.priceString;
    final prefix = fullPrice.replaceFirst(RegExp(r'[\d.,\s]+'), '').trim();

    // Format number with dot thousands separator (Indonesian style).
    final formatted = _formatThousands(perDay);
    return '$prefix $formatted'.trim();
  }

  static String _formatThousands(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return buf.toString();
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
    if (lower.contains('lifetime') || lower.contains('selamanya')) {
      return l10n.productLifetimeTitle;
    }
    return l10n.jobHunterPass;
  }
}
