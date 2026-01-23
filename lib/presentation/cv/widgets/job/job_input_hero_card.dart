import 'package:flutter/material.dart';

class JobInputHeroCard extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback onSubmit;

  const JobInputHeroCard({
    super.key,
    required this.controller,
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
            color: Colors.black.withOpacity(0.15), // Slightly stronger shadow
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
             padding: const EdgeInsets.all(12),
             decoration: BoxDecoration(
               color: Colors.black,
               borderRadius: BorderRadius.circular(12),
             ),
             child: const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 20),
          const Text(
            'Mau lamar kerja apa?',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'AI bakal bantuin bikin CV yang pas banget buat tujuan ini.',
            style: TextStyle(color: Colors.grey[600], height: 1.5, fontSize: 14),
          ),
          const SizedBox(height: 24),
          
          // Input Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E), // Black/Dark Pill
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.grey[800]!),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    style: const TextStyle(
                      color: Colors.white, // White Text
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: hintText.isEmpty && controller.text.isEmpty 
                          ? '' 
                          : hintText,
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Wajib diisi ya';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: onSubmit,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white, // White Btn
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.black, // Black Icon
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
