import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/welcome_steps/step_wall_of_pain.dart';
import '../widgets/welcome_steps/step_selection_list.dart';
import '../widgets/welcome_steps/step_comparison.dart';
import '../widgets/welcome_steps/step_final_reveal.dart';
import 'onboarding_page.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/theme/app_theme.dart';

class OnboardingWelcomePage extends StatefulWidget {
  const OnboardingWelcomePage({super.key});

  @override
  State<OnboardingWelcomePage> createState() => _OnboardingWelcomePageState();
}

class _OnboardingWelcomePageState extends State<OnboardingWelcomePage> {
  int _currentStep = 0;
  bool _showForm = false;

  String? _selectedBurnout;
  String? _selectedTime;
  String? _selectedProcrastination;

  @override
  void initState() {
    super.initState();
    AnalyticsService().trackEvent('onboarding_started');
  }

  void _nextStep() {
    if (_currentStep < 5) {
      setState(() {
        _currentStep++;
      });
      AnalyticsService().trackEvent(
        'onboarding_step_reached',
        properties: {'step': _currentStep},
      );
    } else {
      setState(() => _showForm = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          _buildAmbientSpotlight(height, colorScheme),

          Positioned.fill(
            child: SafeArea(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                transitionBuilder: _buildStepTransition,
                child: _buildStepContent(context, _currentStep),
              ),
            ),
          ),

          if (!_showForm && _currentStep > 0 && _currentStep < 5)
            _buildProgressIndicator(context, colorScheme),

          _buildSlidingForm(height, colorScheme),

          if (_showForm) _buildFormCloseButton(context, colorScheme),
        ],
      ),
    );
  }

  Widget _buildAmbientSpotlight(double height, ColorScheme colorScheme) {
    return Positioned(
      top: -height * 0.2,
      left: -height * 0.1,
      right: -height * 0.1,
      child: Container(
        height: height * 0.7,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              colorScheme.onSurface.withValues(alpha: 0.08),
              colorScheme.onSurface.withValues(alpha: 0.03),
              Colors.transparent,
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
      ).animate().fadeIn(duration: 1500.ms),
    );
  }

  Widget _buildStepTransition(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.05, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }

  Widget _buildProgressIndicator(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      left: 32,
      right: 32,
      child: Row(
        children: List.generate(4, (index) {
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: (index + 1) <= _currentStep
                    ? colorScheme.onSurface
                    : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSlidingForm(double height, ColorScheme colorScheme) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 800),
      curve: Curves.fastOutSlowIn,
      top: _showForm ? height * 0.12 : height,
      height: height * 0.88,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(
            top: BorderSide(color: colorScheme.outlineVariant, width: 1.5),
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 40,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: Theme(data: AppTheme.sheetTheme, child: const OnboardingPage()),
      ),
    );
  }

  Widget _buildFormCloseButton(BuildContext context, ColorScheme colorScheme) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      child: IconButton(
        onPressed: () => setState(() => _showForm = false),
        icon: Icon(Icons.arrow_downward_rounded, color: colorScheme.onSurface),
        style: IconButton.styleFrom(
          backgroundColor: colorScheme.surfaceContainerHighest,
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
    );
  }

  Widget _buildStepContent(BuildContext context, int step) {
    final l10n = AppLocalizations.of(context)!;

    switch (step) {
      case 0:
        return StepWallOfPain(onNext: _nextStep);

      case 1:
        return StepSelectionList(
          title: l10n.onboardingBurnoutTitle,
          options: [
            SelectionOption(
              text: l10n.onboardingBurnout1,
              icon: Icons.edit_note_rounded,
            ),
            SelectionOption(
              text: l10n.onboardingBurnout2,
              icon: Icons.auto_fix_high_rounded,
            ),
            SelectionOption(
              text: l10n.onboardingBurnout3,
              icon: Icons.psychology_rounded,
            ),
          ],
          selectedOption: _selectedBurnout,
          onSelect: (val) => setState(() => _selectedBurnout = val),
          onNext: _nextStep,
        );

      case 2:
        return StepSelectionList(
          title: l10n.onboardingTimeSpentTitle,
          options: [
            SelectionOption(
              text: l10n.onboardingTime1,
              icon: Icons.timer_outlined,
            ),
            SelectionOption(
              text: l10n.onboardingTime2,
              icon: Icons.history_rounded,
            ),
            SelectionOption(
              text: l10n.onboardingTime3,
              icon: Icons.hourglass_empty_rounded,
            ),
            SelectionOption(
              text: l10n.onboardingTime4,
              icon: Icons.alarm_on_rounded,
            ),
          ],
          selectedOption: _selectedTime,
          onSelect: (val) => setState(() => _selectedTime = val),
          onNext: _nextStep,
        );

      case 3:
        return StepSelectionList(
          title: l10n.onboardingProcrastinationTitle,
          options: [
            SelectionOption(
              text: l10n.onboardingProcrastination1,
              icon: Icons.sentiment_dissatisfied_rounded,
            ),
            SelectionOption(
              text: l10n.onboardingProcrastination2,
              icon: Icons.sentiment_neutral_rounded,
            ),
            SelectionOption(
              text: l10n.onboardingProcrastination3,
              icon: Icons.sentiment_very_dissatisfied_rounded,
            ),
          ],
          selectedOption: _selectedProcrastination,
          onSelect: (val) => setState(() => _selectedProcrastination = val),
          onNext: _nextStep,
        );

      case 4:
        return StepComparison(onNext: _nextStep);

      case 5:
        return StepFinalReveal(onNext: _nextStep);

      default:
        return const SizedBox.shrink();
    }
  }
}
