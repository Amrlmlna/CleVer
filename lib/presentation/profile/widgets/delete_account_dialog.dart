import 'package:flutter/material.dart';

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({super.key});

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final _confirmationController = TextEditingController();
  bool _canDelete = false;

  @override
  void dispose() {
    _confirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Account?', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('This is irreversible. You will lose:'),
          const SizedBox(height: 8),
          const Text('• All your generated CVs'),
          const Text('• Your profile information'),
          const Text('• All remaining credits'),
          const SizedBox(height: 16),
          const Text('Type "DELETE" to confirm:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          TextField(
            controller: _confirmationController,
            decoration: const InputDecoration(
              hintText: 'DELETE',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (val) {
              setState(() => _canDelete = val.toUpperCase() == 'DELETE');
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _canDelete ? () => Navigator.pop(context, true) : null,
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Delete My Data'),
        ),
      ],
    );
  }
}
