import 'package:flutter/material.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class JobInputHeroCard extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController companyController;
  final String hintText;

  const JobInputHeroCard({
    super.key,
    required this.controller,
    required this.companyController,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        children: [
          _buildDocumentField(
            context: context,
            controller: controller,
            label: l10n.targetPosition.toUpperCase(),
            hint: hintText.isEmpty && controller.text.isEmpty
                ? l10n.positionHint
                : hintText,
            autoFocus: true,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              height: 1,
              thickness: 1,
              color: colorScheme.onSurface.withValues(alpha: 0.06),
            ),
          ),
          _buildDocumentField(
            context: context,
            controller: companyController,
            label: l10n.companyHint.toUpperCase(),
            hint: l10n.companyHint,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required String hint,
    bool autoFocus = false,
    bool isLast = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.35),
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
              fontSize: 10,
            ),
          ),
          TextFormField(
            controller: controller,
            autofocus: autoFocus,
            style: textTheme.titleSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              filled: false,
              isDense: true,
            ),
            validator: (value) {
              if (!isLast && (value == null || value.isEmpty)) {
                return AppLocalizations.of(context)!.requiredFieldFriendly;
              }
              return null;
            },
            textInputAction: isLast
                ? TextInputAction.done
                : TextInputAction.next,
          ),
        ],
      ),
    );
  }
}
