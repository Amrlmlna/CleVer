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
class OnboardingFinalStep extends ConsumerStatefulWidget {
  const OnboardingFinalStep({super.key});

  @override
  ConsumerState<OnboardingFinalStep> createState() =>
      _OnboardingFinalStepState();
}

class _OnboardingFinalStepState extends ConsumerState<OnboardingFinalStep>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryController;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeIn = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOut,
    );
    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) _entryController.forward();
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingFormProvider);
    final tier = classifyProfileCompleteness(state.formData);

    return FadeTransition(
      opacity: _fadeIn,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: OnboardingFeedbackState(
          profile: state.formData,
          completenessState: tier,
        ),
      ),
    );
  }
}
