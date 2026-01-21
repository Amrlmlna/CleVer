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
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_awesome, color: Colors.white, size: 28),
          const SizedBox(height: 16),
          const Text(
            'Kamu mau bikin CV buat posisi apa?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'AI bakal bantuin bikin CV yang pas banget buat tujuan ini.',
            style: TextStyle(color: Colors.white70, height: 1.4),
          ),
          const SizedBox(height: 24),
          
          // White Input Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: hintText.isEmpty && controller.text.isEmpty 
                          ? '' 
                          : hintText,
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
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
                  child: const Icon(
                    Icons.arrow_circle_right,
                    color: Colors.black,
                    size: 32,
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
