import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/onboarding_provider.dart';
import '../../../presentation/home/providers/user_level_provider.dart';
import 'onboarding_feedback_state.dart';

/// Step 7/7 of the onboarding flow.
///
/// Reads [onboardingFormProvider] to detect how much data the user provided,
/// then delegates rendering to [OnboardingFeedbackState] with the appropriate
/// completeness tier ('complete' | 'partial' | 'empty').
class OnboardingFinalStep extends ConsumerWidget {
  const OnboardingFinalStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingFormProvider);
    final tier = classifyProfileCompleteness(state.formData);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: OnboardingFeedbackState(
        profile: state.formData,
        completenessState: tier,
      ),
    );
  }
}
