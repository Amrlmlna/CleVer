import 'package:flutter/material.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import 'dart:async';

class SubscriptionStatusCard extends StatefulWidget {
  final bool isSubscribed;
  final DateTime? expiryDate;
  final String cardHolder;
  final VoidCallback onAction;
  final bool isLoading;

  const SubscriptionStatusCard({
    super.key,
    required this.isSubscribed,
    this.expiryDate,
    required this.cardHolder,
    required this.onAction,
    this.isLoading = false,
  });

  @override
  State<SubscriptionStatusCard> createState() => _SubscriptionStatusCardState();
}

class _SubscriptionStatusCardState extends State<SubscriptionStatusCard> {
  late Timer _timer;
  String _timeLeft = '';

  @override
  void initState() {
    super.initState();
    _updateTimeLeft();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) _updateTimeLeft();
    });
  }

  @override
  void didUpdateWidget(SubscriptionStatusCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.expiryDate != widget.expiryDate ||
        oldWidget.isSubscribed != widget.isSubscribed) {
      _updateTimeLeft();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTimeLeft() {
    if (!widget.isSubscribed || widget.expiryDate == null) {
      setState(() {
        _timeLeft = '';
      });
      return;
    }

    final now = DateTime.now();
    final difference = widget.expiryDate!.difference(now);

    if (difference.isNegative) {
      setState(() {
        _timeLeft = '';
      });
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    String timeStr;
    if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      timeStr = l10n.months(months);
    } else if (difference.inDays > 7) {
      final weeks = (difference.inDays / 7).floor();
      timeStr = l10n.weeks(weeks);
    } else if (difference.inDays >= 1) {
      timeStr = l10n.days(difference.inDays);
    } else if (difference.inHours >= 1) {
      timeStr = l10n.hours(difference.inHours);
    } else {
      timeStr = l10n.minutes(difference.inMinutes);
    }

    setState(() {
      _timeLeft = timeStr;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Use theme aware colors as requested
    final cardBgColor = colorScheme.onSurface;
    final cardTextColor = colorScheme.surface;

    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: cardBgColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative elements
          Positioned(
            right: -20,
            top: -20,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: cardTextColor.withValues(alpha: 0.05),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: widget.isSubscribed
                            ? colorScheme.primary.withValues(alpha: 0.2)
                            : cardTextColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: widget.isSubscribed
                              ? colorScheme.primary.withValues(alpha: 0.5)
                              : cardTextColor.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(
                        (widget.isSubscribed ? l10n.activePass : l10n.free)
                            .toUpperCase(),
                        style: TextStyle(
                          color: widget.isSubscribed
                              ? colorScheme.primary
                              : cardTextColor.withValues(alpha: 0.5),
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    if (!widget.isLoading)
                      IconButton(
                        onPressed: widget.onAction,
                        icon: Icon(
                          widget.isSubscribed
                              ? Icons.refresh_rounded
                              : Icons.add_rounded,
                          color: cardTextColor,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: cardTextColor.withValues(alpha: 0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                  ],
                ),
                const Spacer(),
                if (widget.isLoading)
                  const CircularProgressIndicator()
                else ...[
                  Text(
                    widget.isSubscribed
                        ? l10n.jobHunterPass.toUpperCase()
                        : l10n.cleverUser.toUpperCase(),
                    style: textTheme.titleLarge?.copyWith(
                      color: cardTextColor,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ),
                  if (widget.isSubscribed && _timeLeft.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        l10n.subscriptionExpiryCount(_timeLeft),
                        style: textTheme.bodySmall?.copyWith(
                          color: cardTextColor.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.cardHolder,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium?.copyWith(
                          color: cardTextColor.withValues(alpha: 0.4),
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.contactless_outlined,
                      color: cardTextColor.withValues(alpha: 0.2),
                      size: 24,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
