import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/clever/clever_colors.dart';
import '../../../../core/theme/clever/clever_dimensions.dart';
import '../../../../core/theme/clever/clever_typography.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// "daftar" label + the round add button shared by every list step. Per
/// staging the "+" is a bare cream icon — no filled box behind it.
class CleverListHeader extends StatelessWidget {
  const CleverListHeader({super.key, required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Text(
          l10n.cleverListLabel,
          style: CleverTypography.h3.copyWith(
            color: CleverColors.textOnInverse,
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: onAdd,
          borderRadius: BorderRadius.circular(CleverRadius.field),
          child: const SizedBox(
            width: 40,
            height: 40,
            child: Icon(
              Icons.add,
              size: 24,
              color: CleverColors.textOnInverse,
            ),
          ),
        ),
      ],
    );
  }
}

/// Staging empty state: illustration + title + tappable prompt.
class CleverListEmptyState extends StatelessWidget {
  const CleverListEmptyState({
    super.key,
    required this.illustration,
    required this.prompt,
    required this.onTap,
  });

  final String illustration;
  final String prompt;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(illustration, width: 229),
          const SizedBox(height: CleverSpacing.space24),
          Text(
            l10n.cleverEmptyTitle,
            style: CleverTypography.h2.copyWith(
              color: CleverColors.textOnInverse,
            ),
          ),
          const SizedBox(height: CleverSpacing.space8),
          GestureDetector(
            onTap: onTap,
            child: Text(
              prompt,
              style: CleverTypography.bodySm.copyWith(
                color: CleverColors.textOnInverse.withValues(alpha: 0.62),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Cream entry row per the staging list: ↗ + title, right-aligned meta
/// stack. Tap = edit, long-press = delete.
class CleverEntryRow extends StatelessWidget {
  const CleverEntryRow({
    super.key,
    required this.title,
    required this.metaTop,
    required this.metaBottom,
    required this.onTap,
    required this.onLongPress,
  });

  final String title;
  final String metaTop;
  final String metaBottom;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(CleverRadius.button),
        child: Container(
          height: 55,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: CleverColors.bgCanvas,
            borderRadius: BorderRadius.circular(CleverRadius.button),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.north_east,
                size: 21,
                color: CleverColors.surfaceInverse,
              ),
              const SizedBox(width: CleverSpacing.space12),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: CleverTypography.bodyStrong.copyWith(
                    color: CleverColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: CleverSpacing.space8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    metaTop,
                    style: CleverTypography.micro.copyWith(
                      color: CleverColors.textPrimary,
                    ),
                  ),
                  Text(
                    metaBottom,
                    style: CleverTypography.caption.copyWith(
                      color: CleverColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Scrollable entry list with a fade into the orange sheet at the bottom.
class CleverEntryList extends StatelessWidget {
  const CleverEntryList({
    super.key,
    required this.itemCount,
    required this.rowBuilder,
  });

  final int itemCount;
  final Widget Function(int index) rowBuilder;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (var i = 0; i < itemCount; i++) ...[
                  rowBuilder(i),
                  if (i != itemCount - 1)
                    const SizedBox(height: CleverSpacing.space12),
                ],
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 48,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    CleverColors.bgAction.withValues(alpha: 0),
                    CleverColors.bgAction,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
