import 'package:flutter/material.dart';

import '../../../../core/theme/clever/clever_colors.dart';
import '../../../../core/theme/clever/clever_dimensions.dart';
import '../../../../core/theme/clever/clever_typography.dart';

/// Segmented ketik/dikte toggle from the staging form sheets: track filled
/// with surfaceField, active segment is an orange pill with on-dark icon
/// and label, inactive is transparent with an orange icon and dark label.
class CleverFormToggle extends StatelessWidget {
  const CleverFormToggle({
    super.key,
    required this.segments,
    required this.activeIndex,
    required this.onChanged,
  });

  final List<CleverToggleSegment> segments;
  final int activeIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 39,
      decoration: BoxDecoration(
        color: CleverColors.surfaceField,
        borderRadius: BorderRadius.circular(CleverRadius.button),
      ),
      child: Row(
        children: [
          for (var i = 0; i < segments.length; i++)
            Expanded(
              child: _Segment(
                segment: segments[i],
                active: i == activeIndex,
                onTap: () => onChanged(i),
              ),
            ),
        ],
      ),
    );
  }
}

class CleverToggleSegment {
  const CleverToggleSegment({required this.label, this.icon});

  final String label;
  final IconData? icon;
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.segment,
    required this.active,
    required this.onTap,
  });

  final CleverToggleSegment segment;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = active
        ? CleverColors.textOnDark
        : CleverColors.textPrimary;
    final iconColor = active ? CleverColors.textOnDark : CleverColors.bgAction;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(CleverRadius.button),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: active ? CleverColors.bgAction : Colors.transparent,
          borderRadius: BorderRadius.circular(CleverRadius.button),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (segment.icon != null) ...[
              Icon(segment.icon, size: 18, color: iconColor),
              const SizedBox(width: CleverSpacing.space8),
            ],
            Text(
              segment.label,
              style: CleverTypography.bodyStrong.copyWith(color: foreground),
            ),
          ],
        ),
      ),
    );
  }
}
