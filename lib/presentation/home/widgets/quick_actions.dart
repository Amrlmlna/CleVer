import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/user_profile.dart';
import '../../profile/widgets/import_cv_button.dart';
import '../../profile/providers/profile_provider.dart';
import '../../../core/utils/custom_snackbar.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class QuickActions extends ConsumerWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ImportCVButton(
      onImportSuccess: (UserProfile profile) {
        ref.read(masterProfileProvider.notifier).saveProfile(profile);

        CustomSnackBar.showSuccess(
          context,
          AppLocalizations.of(context)!.importSuccessMessage(
            profile.experience.length,
            profile.education.length,
            profile.skills.length,
          ),
        );
      },
    );
  }
}

