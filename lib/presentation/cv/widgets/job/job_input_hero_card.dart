import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white, // Explicit White Card
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1), // Softer shadow
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Removed Pointless Star Icon
          
          Text(
            'Mau lamar kerja apa?',
            style: GoogleFonts.outfit(
              color: Colors.black,
              fontSize: 28, // Sligthly larger
              fontWeight: FontWeight.w800,
              height: 1.2,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'AI bakal bantuin bikin CV yang pas banget buat tujuan ini.',
            style: GoogleFonts.outfit(
                color: Colors.grey[600], height: 1.5, fontSize: 15),
          ),
          const SizedBox(height: 32),
          
          // Job Title Input
          _buildMinimalInput(
            controller: controller, 
            hint: hintText.isEmpty && controller.text.isEmpty ? 'Posisi (Misal: UI Designer)' : hintText,
            icon: Icons.work_outline,
            autoFocus: true,
          ),
          const SizedBox(height: 16),

          // Company Input
          _buildMinimalInput(
            controller: companyController, 
            hint: 'Nama Perusahaan (Opsional)',
            icon: Icons.business,
            isLast: true,
            onSubmit: onSubmit,
          ),
        ],
      ),
    );
  }

  Widget _buildMinimalInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool autoFocus = false,
    bool isLast = false,
    VoidCallback? onSubmit,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100], // Standard light grey for better visibility
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: controller,
              autofocus: autoFocus,
              style: GoogleFonts.outfit(
                color: Colors.black87, // Dark text on light bg
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.outfit(
                  color: Colors.grey[500],
                  fontWeight: FontWeight.normal,
                ),
                border: InputBorder.none,
                isDense: true,
                filled: false, // Prevent global theme from filling it
                fillColor: Colors.transparent, // Ensure transparency
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
              validator: (value) {
                if (!isLast && (value == null || value.isEmpty)) { // Only validate title
                  return 'Wajib diisi ya';
                }
                return null;
              },
              textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
              onFieldSubmitted: isLast ? (_) => onSubmit?.call() : null,
            ),
          ),
          // Removed Pointless Arrow Icon
        ],
      ),
    );
  }
}
