import 'package:flutter/material.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import 'package:clever/core/utils/subscription_formatter.dart';
import 'dart:math' as math;

class SubscriptionStatusCard extends StatefulWidget {
  final bool isSubscribed;
  final bool isLoading;
  final String cardHolder;
  final DateTime? expiryDate;
  final VoidCallback onAction;

  const SubscriptionStatusCard({
    super.key,
    required this.isSubscribed,
    this.isLoading = false,
    required this.cardHolder,
    this.expiryDate,
    required this.onAction,
  });

  @override
  State<SubscriptionStatusCard> createState() => _SubscriptionStatusCardState();
}

class _SubscriptionStatusCardState extends State<SubscriptionStatusCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  String _timeLeft = '';

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateTimeLeft();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _updateTimeLeft() {
    if (widget.expiryDate == null || !widget.isSubscribed) {
      _timeLeft = '';
      return;
    }

    final l10n = AppLocalizations.of(context);
    if (l10n == null) return;

    setState(() {
      _timeLeft = SubscriptionFormatter.formatRemainingTime(
        widget.expiryDate!,
        l10n,
      );
    });
  }

  @override
  void didUpdateWidget(SubscriptionStatusCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expiryDate != oldWidget.expiryDate) {
      _updateTimeLeft();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Use theme aware colors - STRICTLY NO HARDCODED COLORS
    // Gold for Premium (from tertiary), OnSurface/Surface for Monochrome
    final premiumGold = colorScheme.tertiary;
    final accentColor = widget.isSubscribed
        ? premiumGold
        : colorScheme.onSurface;
    final backgroundColor = colorScheme.surface;
    final onBackgroundColor = colorScheme.onSurface;

    return GestureDetector(
      onTap: widget.onAction,
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: onBackgroundColor.withValues(alpha: 0.1),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipPath(
          clipper: TicketStubClipperManual(),
          child: CustomPaint(
            painter: GuillochePainter(
              color: onBackgroundColor.withValues(alpha: 0.03),
            ),
            child: Container(
              color: backgroundColor,
              child: Row(
                children: [
                  // Main Section
                  Expanded(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _TicketBadge(
                            isSubscribed: widget.isSubscribed,
                            accentColor: accentColor,
                          ),
                          const Spacer(),
                          if (widget.isLoading)
                            SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: accentColor,
                              ),
                            )
                          else ...[
                            Text(
                              (widget.isSubscribed
                                      ? l10n.jobHunterPass
                                      : l10n.cleverUser)
                                  .toUpperCase(),
                              style: textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1.0,
                                color: onBackgroundColor,
                              ),
                            ),
                            if (widget.isSubscribed && _timeLeft.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  l10n.subscriptionExpiryCount(_timeLeft),
                                  style: textTheme.labelMedium?.copyWith(
                                    color: onBackgroundColor.withValues(
                                      alpha: 0.5,
                                    ),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                          const Spacer(),
                          Text(
                            widget.cardHolder.toUpperCase(),
                            style: textTheme.labelLarge?.copyWith(
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.w800,
                              color: onBackgroundColor.withValues(alpha: 0.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Perforation Line
                  _PerforationLine(
                    color: onBackgroundColor.withValues(alpha: 0.1),
                  ),

                  // Action Section (The Stub)
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: onBackgroundColor.withValues(alpha: 0.02),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          RotatedBox(
                            quarterTurns: 1,
                            child: Text(
                              (widget.isSubscribed
                                      ? l10n.active
                                      : l10n.activate)
                                  .toUpperCase(),
                              style: textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                letterSpacing: 3.0,
                                color: accentColor,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Icon(
                              widget.isSubscribed
                                  ? Icons.verified_user_outlined
                                  : Icons.arrow_forward_ios_rounded,
                              color: accentColor,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TicketBadge extends StatelessWidget {
  final bool isSubscribed;
  final Color accentColor;

  const _TicketBadge({required this.isSubscribed, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: accentColor, width: 1.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        (isSubscribed ? "PREMIUM" : "STANDARD").toUpperCase(),
        style: TextStyle(
          color: accentColor,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

class _PerforationLine extends StatelessWidget {
  final Color color;
  const _PerforationLine({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1,
      child: Column(
        children: List.generate(
          10,
          (index) => Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              width: 1,
              color: index % 2 == 0 ? color : Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}

// Fixed Clipper
class TicketStubClipperManual extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const radius = 24.0;
    const notchRadius = 12.0;
    final notchX = size.width * 0.7;

    path.moveTo(radius, 0);
    path.lineTo(notchX - notchRadius, 0);
    path.arcToPoint(
      Offset(notchX + notchRadius, 0),
      radius: const Radius.circular(notchRadius),
      clockwise: false,
    );
    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, radius);
    path.lineTo(size.width, size.height - radius);
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - radius,
      size.height,
    );
    path.lineTo(notchX + notchRadius, size.height);
    path.arcToPoint(
      Offset(notchX - notchRadius, size.height),
      radius: const Radius.circular(notchRadius),
      clockwise: false,
    );
    path.lineTo(radius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - radius);
    path.lineTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class GuillochePainter extends CustomPainter {
  final Color color;
  GuillochePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    for (var i = 0; i < 10; i++) {
      final path = Path();
      final yOffset = size.height * (i / 10);
      path.moveTo(0, yOffset);
      for (var x = 0.0; x <= size.width; x += 5) {
        path.lineTo(x, yOffset + math.sin(x * 0.05 + i) * 10);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
