import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Profile action buttons (Save + Help)
class ProfileActionButtons extends StatelessWidget {
  final VoidCallback onSave;
  final bool canSave;

  const ProfileActionButtons({
    super.key,
    required this.onSave,
    this.canSave = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 48),
        
        // Save Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: canSave ? onSave : null,
            icon: const Icon(Icons.check),
            label: const Text('Simpan Profil'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Help Button
        Center(
          child: TextButton.icon(
            onPressed: () => context.push('/profile/help'),
            icon: Icon(Icons.help_outline, color: Theme.of(context).disabledColor),
            label: Text(
              'Bantuan & Dukungan',
              style: TextStyle(color: Theme.of(context).disabledColor),
            ),
          ),
        ),
        
        const SizedBox(height: 100), // Extra bottom padding
      ],
    );
  }
}
