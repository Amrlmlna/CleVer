import 'package:flutter/material.dart';

import '../../../../core/theme/clever/clever_colors.dart';
import '../../../../core/theme/clever/clever_dimensions.dart';

class CleverSheet extends StatelessWidget {
  const CleverSheet({
    super.key,
    required this.child,
    this.showHandle = false,
    this.handleColor = CleverColors.surfaceInverse,
  });

  final Widget child;
  final bool showHandle;
  final Color handleColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: CleverColors.bgCanvas,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(CleverRadius.sheet),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showHandle)
            Padding(
              padding: const EdgeInsets.only(
                top: CleverSpacing.space16,
                bottom: CleverSpacing.space12,
              ),
              child: Center(
                child: Container(
                  width: 47,
                  height: 4,
                  decoration: BoxDecoration(
                    color: handleColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          child,
        ],
      ),
    );
  }
}
