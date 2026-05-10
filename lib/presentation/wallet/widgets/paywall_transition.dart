import 'package:flutter/material.dart';

class PaywallTransition {
  static Future<bool?> show(BuildContext context, Widget child) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Theme.of(context).colorScheme.scrim.withValues(alpha: 0.5),
      isDismissible: true,
      enableDrag: true,
      builder: (context) => child,
    );
  }
}
