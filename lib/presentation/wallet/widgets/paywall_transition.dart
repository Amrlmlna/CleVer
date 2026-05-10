import 'package:flutter/material.dart';

class PaywallTransition {
  /// Shows [child] as a bottom-anchored sheet with a slide-up + fade
  /// transition and a scrim barrier. Returns the dialog result.
  static Future<bool?> show(BuildContext context, Widget child) {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'paywall',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return child;
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutQuart,
        );
        final scrim = Theme.of(context).colorScheme.scrim;
        return AnimatedBuilder(
          animation: curved,
          builder: (context, _) {
            return Stack(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    color: scrim.withValues(alpha: curved.value * 0.5),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Transform.translate(
                    offset: Offset(0, (1 - curved.value) * 200),
                    child: Opacity(opacity: curved.value, child: child),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
