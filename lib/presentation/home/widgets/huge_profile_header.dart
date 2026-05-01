import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../providers/mascot_provider.dart';
import 'mascot_header.dart';

class HugeProfileHeader extends ConsumerWidget {
  const HugeProfileHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mascotContent = ref.watch(mascotProvider);
    final textTheme = Theme.of(context).textTheme;

    final title = _getLocalizedText(context, mascotContent.title);
    final subtitle = _getLocalizedText(context, mascotContent.subtitle);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: mascotContent.backgroundColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.only(top: 100),
      child: Column(
        crossAxisAlignment: mascotContent.alignment,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: mascotContent.alignment,
              children: [
                Text(
                  title,
                  textAlign: mascotContent.textAlign,
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: mascotContent.textColor,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  subtitle,
                  textAlign: mascotContent.textAlign,
                  style: textTheme.bodyMedium?.copyWith(
                    color: mascotContent.textColor.withValues(alpha: 0.7),
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          MascotHeader(
            expression: mascotContent.expression,
            mascotColor: mascotContent.mascotColor,
          ),
        ],
      ),
    );
  }

  String _getLocalizedText(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    switch (key) {
      case "mascotWelcome":
        return l10n.mascotWelcome;
      case "mascotWelcomeSub":
        return l10n.mascotWelcomeSub;
      case "mascotEncourage":
        return l10n.mascotEncourage;
      case "mascotEncourageSub":
        return l10n.mascotEncourageSub;
      case "mascotExciting":
        return l10n.mascotExciting;
      case "mascotExcitingSub":
        return l10n.mascotExcitingSub;
      default:
        return key;
    }
  }
}
