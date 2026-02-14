import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/user_profile.dart';
import '../../profile/widgets/import_cv_button.dart';
import '../../profile/providers/profile_provider.dart';

/// Quick actions section for home page
/// Only shows Import CV for users without profile
class QuickActions extends ConsumerWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ImportCVButton(
      onImportSuccess: (UserProfile profile) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✅ CV berhasil diimport!\n'
              'Ditambahkan: ${profile.experience.length} pengalaman, '
              '${profile.education.length} pendidikan'
            ),
            duration: const Duration(seconds: 3),
          ),
        );
        // Navigate to profile to review/complete
        context.push('/profile');
      },
    );
  }
}
