import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../drafts/providers/completed_cv_provider.dart';
import '../../profile/providers/master_profile_provider.dart';
import '../models/mascot_state.dart';
import '../../../core/theme/app_colors.dart';

final mascotProvider = Provider<MascotState>((ref) {
  final completedCVs = ref.watch(completedCVProvider).value ?? [];
  final masterProfile = ref.watch(masterProfileProvider);

  if (completedCVs.length == 1) {
    return MascotState(
      expression: MascotExpression.exciting,
      title: "mascotExciting",
      subtitle: "mascotExcitingSub",
      backgroundColor: AppColors.accentLavender,
      mascotColor: AppColors.vibrantPurple,
      textColor: AppColors.accentLavenderDark,
      textAlign: TextAlign.left,
      alignment: CrossAxisAlignment.start,
    );
  }

  final isProfileIncomplete =
      masterProfile == null ||
      masterProfile.experience.isEmpty ||
      masterProfile.skills.isEmpty;

  if (isProfileIncomplete && completedCVs.isNotEmpty) {
    return MascotState(
      expression: MascotExpression.encouraging,
      title: "mascotEncourage",
      subtitle: "mascotEncourageSub",
      backgroundColor: AppColors.accentSage,
      mascotColor: AppColors.accentSageDark,
      textColor: AppColors.accentSageDark,
      textAlign: TextAlign.center,
      alignment: CrossAxisAlignment.center,
    );
  }

  if (completedCVs.isEmpty) {
    return MascotState(
      expression: MascotExpression.smiling,
      title: "mascotWelcome",
      subtitle: "mascotWelcomeSub",
      backgroundColor: AppColors.accentPeach,
      mascotColor: AppColors.vibrantBlack,
      textColor: AppColors.accentPeachDark,
      textAlign: TextAlign.center,
      alignment: CrossAxisAlignment.center,
    );
  }

  return MascotState(
    expression: MascotExpression.neutral,
    title: "mascotWelcome",
    subtitle: "mascotWelcomeSub",
    backgroundColor: AppColors.accentSand,
    mascotColor: AppColors.accentSandDark,
    textColor: AppColors.accentSandDark,
    textAlign: TextAlign.left,
    alignment: CrossAxisAlignment.start,
  );
});
