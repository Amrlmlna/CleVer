import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/user_profile.dart';
import '../../profile/widgets/import_cv_button.dart';
import '../../../core/utils/custom_snackbar.dart';

/// Quick actions section for home page
/// Only shows Import CV for users without profile
class QuickActions extends ConsumerWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ImportCVButton(
      onImportSuccess: (UserProfile profile) {
        // Show success message
        CustomSnackBar.showSuccess(
          context,
          'CV berhasil diimport!\n'
          'Ditambahkan: ${profile.experience.length} pengalaman, '
          '${profile.education.length} pendidikan',
        );
        // Navigate to profile to review/complete
        context.push('/profile');
      },
    );
  }
}
