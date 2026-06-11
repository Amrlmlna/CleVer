import 'package:clever/l10n/generated/app_localizations.dart';
import 'package:clever/domain/entities/wallet_transaction.dart';

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

    if (difference.inDays > 365 * 10) {
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
      return l10n.minutes(minutes > 0 ? minutes : 1);
    }
  }

  /// Centralized display text for subscription transaction items.
  /// Shows countdown for active subs, product display name for expired ones.
  static String formatTransactionStatus(
    WalletTransaction txn,
    AppLocalizations l10n,
  ) {
    if (txn.expiryDate != null && txn.expiryDate!.isAfter(DateTime.now())) {
      return formatRemainingTime(txn.expiryDate!, l10n).toUpperCase();
    }
    return (txn.productDisplayName ?? l10n.active).toUpperCase();
  }
}
