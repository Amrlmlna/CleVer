import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profile_provider.dart';

class DangerZone extends ConsumerWidget {
  final bool isSaving;
  final Future<void> Function() onConfirmDeletion;

  const DangerZone({
    super.key,
    required this.isSaving,
    required this.onConfirmDeletion,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const Text(
          'Deleting your account will remove all your data from our servers. This action cannot be undone.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: isSaving ? null : onConfirmDeletion,
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            label: const Text('Delete Account', style: TextStyle(color: Colors.red)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
