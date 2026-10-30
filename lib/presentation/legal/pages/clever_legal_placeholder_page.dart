import 'package:flutter/material.dart';

import '../../../core/theme/clever/clever_colors.dart';
import '../../../core/theme/clever/clever_typography.dart';
import '../../../l10n/generated/app_localizations.dart';

enum CleverLegalDoc { privacy, terms }

class CleverLegalPlaceholderPage extends StatelessWidget {
  const CleverLegalPlaceholderPage({super.key, required this.doc});

  final CleverLegalDoc doc;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = doc == CleverLegalDoc.privacy
        ? l10n.privacyPolicy
        : l10n.termsOfService;

    return Scaffold(
      backgroundColor: CleverColors.bgCanvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(height: 8),
              Text(title, style: CleverTypography.h4),
              const SizedBox(height: 16),
              Text(
                l10n.cleverLegalPendingBody,
                style: CleverTypography.body.copyWith(
                  color: CleverColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
