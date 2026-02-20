import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

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
        
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: canSave ? onSave : null,
            icon: const Icon(Icons.check),
            label: Text(AppLocalizations.of(context)!.saveProfile),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        Center(
          child: TextButton.icon(
            onPressed: () => context.push('/profile/help'),
            icon: Icon(Icons.help_outline, color: Theme.of(context).disabledColor),
            label: Text(
              AppLocalizations.of(context)!.helpSupport,
              style: TextStyle(color: Theme.of(context).disabledColor),
            ),
          ),
        ),
        
        const SizedBox(height: 100),
      ],
    );
  }
}
