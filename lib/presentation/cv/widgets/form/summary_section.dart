import 'package:flutter/material.dart';

class SummarySection extends StatelessWidget {
  final TextEditingController controller;
  final bool isGenerating;
  final VoidCallback onGenerate;
  final bool isDark;

  const SummarySection({
    super.key,
    required this.controller,
    required this.isGenerating,
    required this.onGenerate,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: controller,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Tulis ringkasan profesional Anda secara singkat...',
            filled: true,
            fillColor: isDark ? Colors.grey[800] : Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Summary tidak boleh kosong';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: isGenerating ? null : onGenerate,
          icon: isGenerating 
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) 
              : const Icon(Icons.auto_awesome, size: 18),
          label: Text(isGenerating ? 'Generating...' : 'Generate with AI'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple[50],
            foregroundColor: Colors.purple,
            elevation: 0,
          ),
        ),
      ],
    );
  }
}
