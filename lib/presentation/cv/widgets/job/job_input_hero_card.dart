import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.whatJobApply,
          style: GoogleFonts.outfit(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 32,
            fontWeight: FontWeight.w800,
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        
        Text(
          AppLocalizations.of(context)!.aiHelpCreateCV,
          style: GoogleFonts.outfit(
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            height: 1.5,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        
        const SizedBox(height: 32),
        
        Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[900] : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildMinimalInput(
                context: context,
                controller: controller,
                hint: hintText.isEmpty && controller.text.isEmpty ? AppLocalizations.of(context)!.positionHint : hintText,
                autoFocus: true,
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: isDark ? Colors.grey[800] : Colors.grey[300],
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return TextFormField(
      controller: controller,
      autofocus: autoFocus,
      style: GoogleFonts.outfit(
        color: isDark ? Colors.white : Colors.black,
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.outfit(
          color: isDark ? Colors.grey[600] : Colors.grey[400],
          fontSize: 17,
          fontWeight: FontWeight.w400,
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
