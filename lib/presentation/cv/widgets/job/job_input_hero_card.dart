import 'package:flutter/material.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class JobInputHeroCard extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController companyController;
  final String hintText;
  final VoidCallback onSubmit;

  const JobInputHeroCard({
    super.key,
    required this.controller,
    required this.companyController,
    required this.hintText,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.whatJobApply,
          style: textTheme.displaySmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w800,
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),

        Text(
          AppLocalizations.of(context)!.aiHelpCreateCV,
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 32),

        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildMinimalInput(
                context: context,
                controller: controller,
                hint: hintText.isEmpty && controller.text.isEmpty
                    ? AppLocalizations.of(context)!.positionHint
                    : hintText,
                autoFocus: true,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),

              _buildMinimalInput(
                context: context,
                controller: companyController,
                hint: AppLocalizations.of(context)!.companyHint,
                isLast: true,
                onSubmit: onSubmit,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMinimalInput({
    required BuildContext context,
    required TextEditingController controller,
    required String hint,
    bool autoFocus = false,
    bool isLast = false,
    VoidCallback? onSubmit,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return TextFormField(
      controller: controller,
      autofocus: autoFocus,
      style: textTheme.titleSmall?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: textTheme.titleSmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w400,
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        filled: false,
      ),
      validator: (value) {
        if (!isLast && (value == null || value.isEmpty)) {
          return AppLocalizations.of(context)!.requiredFieldFriendly;
        }
        return null;
      },
      textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
      onFieldSubmitted: isLast ? (_) => onSubmit?.call() : null,
    );
  }
}
