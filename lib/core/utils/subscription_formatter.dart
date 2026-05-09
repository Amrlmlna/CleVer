import 'package:clever/l10n/generated/app_localizations.dart';

class SubscriptionFormatter {
  /// Formats the remaining time until [expiryDate] into a human-readable localized string.
  ///
  /// The priority is: Years > Months > Weeks > Days > Hours > Minutes.
  /// Minutes is the minimum unit shown.
  static String formatRemainingTime(
    DateTime expiryDate,
    AppLocalizations l10n,
  ) {
    final now = DateTime.now();
    final difference = expiryDate.difference(now);

    if (difference.isNegative) {
      return '';
    }

    if (difference.inDays >= 365) {
      final years = (difference.inDays / 365).floor();
      return l10n.years(years);
    } else if (difference.inDays >= 30) {
      final months = (difference.inDays / 30).floor();
      return l10n.months(months);
    } else if (difference.inDays >= 7) {
      final weeks = (difference.inDays / 7).floor();
      return l10n.weeks(weeks);
    } else if (difference.inDays > 0) {
      return l10n.days(difference.inDays);
    } else if (difference.inHours > 0) {
      return l10n.hours(difference.inHours);
    } else {
      final minutes = difference.inMinutes;
      // Show at least 1 minute if the difference is very small but not yet expired
      return l10n.minutes(minutes > 0 ? minutes : 1);
    }
  }

  /// Formats a product's duration for transaction history.
  /// This is used when we want to show the duration of the purchased product itself.
  static String formatProductDuration(String productId, AppLocalizations l10n) {
    // Standard product IDs mapping
    if (productId.contains('24h')) return l10n.days(1).toUpperCase();
    if (productId.contains('3d')) return l10n.days(3).toUpperCase();
    if (productId.contains('1w')) return l10n.weeks(1).toUpperCase();
    if (productId.contains('1m')) return l10n.months(1).toUpperCase();
    if (productId.contains('1y')) return l10n.years(1).toUpperCase();

    // Parse Indonesian duration strings from backend (e.g., "+24 Jam", "+3 Hari")
    final match = RegExp(r'\+?(\d+)\s*(Jam|Hari|Minggu|Bulan|Tahun)', caseSensitive: false).firstMatch(productId);
    if (match != null) {
      final value = int.parse(match.group(1)!);
      final unit = match.group(2)!.toLowerCase();
      if (unit == 'jam') return l10n.days(1).toUpperCase();
      if (unit == 'hari') return l10n.days(value).toUpperCase();
      if (unit == 'minggu') return l10n.weeks(value).toUpperCase();
      if (unit == 'bulan') return l10n.months(value).toUpperCase();
      if (unit == 'tahun') return l10n.years(value).toUpperCase();
    }

    return productId.toUpperCase();
  }
}
