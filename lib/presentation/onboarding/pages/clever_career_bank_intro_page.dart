import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/clever/clever_colors.dart';
import '../../../core/theme/clever/clever_dimensions.dart';
import '../../../core/theme/clever/clever_typography.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../common/widgets/clever/clever_button.dart';
import '../../common/widgets/clever/clever_confirm_sheet.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/clever_panel/clever_header_step.dart';
import '../widgets/clever_panel/clever_ufo_illustration.dart';
import 'onboarding_page.dart';

/// InputStep1 — the career-bank pitch screen (8/8). "Mulai sekarang" slides
/// the input panel up as a bottom sheet over this page; the hero morphs
/// from its intro position to the centered top position.
class CleverCareerBankIntroPage extends ConsumerStatefulWidget {
  const CleverCareerBankIntroPage({super.key});

  @override
  ConsumerState<CleverCareerBankIntroPage> createState() =>
      _CleverCareerBankIntroPageState();
}

class _CleverCareerBankIntroPageState
    extends ConsumerState<CleverCareerBankIntroPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _sheet = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  );
  late final Animation<double> _sheetAnimation = CurvedAnimation(
    parent: _sheet,
    curve: Curves.fastOutSlowIn,
  );

  bool get _sheetOpen => _sheet.isCompleted;

  /// True once the user edits anything while the sheet is open. Prefilled
  /// and restored-draft data do not count — with the draft auto-persisting,
  /// only real edits are worth a confirmation.
  bool _touched = false;

  Future<void> _openSheet() async {
    setState(() => _touched = false);
    await _sheet.forward();
  }

  /// Close flow: clean exits reverse immediately; a panel the user actually
  /// edited this session asks via the confirmation sheet (save draft /
  /// discard).
  Future<void> _closeSheet() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_touched) {
      await _sheet.reverse();
      return;
    }

    final result = await CleverConfirmSheet.show(
      context,
      title: l10n.cleverConfirmTitle,
      message: l10n.cleverConfirmMessage,
      confirmLabel: l10n.cleverConfirmSave,
      discardLabel: l10n.cleverConfirmDiscard,
    );
    if (!mounted) return;

    if (result == null) return;
    if (result == false) {
      await ref.read(onboardingFormProvider.notifier).discardDraft();
    }
    setState(() => _touched = false);
    await _sheet.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentPage = ref.watch(
      onboardingFormProvider.select((s) => s.currentPage),
    );
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final screenH = MediaQuery.sizeOf(context).height;

    // Track real edits: only formData changes count as touching the panel.
    ref.listen<OnboardingState>(onboardingFormProvider, (prev, next) {
      if (prev != null && prev.formData != next.formData) {
        _touched = true;
      }
    });

    return PopScope(
      canPop: !_sheetOpen,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _closeSheet();
      },
      child: Scaffold(
        backgroundColor: CleverColors.bgCanvas,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // The progress bar steps aside as the sheet opens, freeing
                  // the space the hero rises into.
                  AnimatedBuilder(
                    animation: _sheetAnimation,
                    builder: (context, child) {
                      final t = _sheetAnimation.value;
                      return SizedBox(
                        height: 24 + 20 * (1 - t),
                        child: Opacity(opacity: 1 - t, child: child),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 21),
                      child: _IntroProgressBar(),
                    ),
                  ),
                  // Hero morphs: intro position (left) -> centered top, same
                  // timing as the sheet slide.
                  AnimatedBuilder(
                    animation: _sheetAnimation,
                    builder: (context, child) {
                      final t = _sheetAnimation.value;
                      return Padding(
                        padding: EdgeInsets.only(top: 20 * (1 - t)),
                        child: Align(
                          alignment: Alignment.lerp(
                            Alignment.topLeft,
                            Alignment.topCenter,
                            t,
                          )!,
                          child: child,
                        ),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 21),
                      child: _CareerBankHero(),
                    ),
                  ),
                  const SizedBox(height: CleverSpacing.space8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 21),
                    child: Text(
                      l10n.cleverIntroTagline,
                      style: CleverTypography.bodyStrong.copyWith(
                        color: CleverColors.textPrimary,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: SizedBox(
                          width: 402,
                          height: 419,
                          child: CleverUfoIllustration(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      l10n.cleverIntroSupport,
                      textAlign: TextAlign.center,
                      style: CleverTypography.bodySm.copyWith(
                        color: CleverColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: CleverSpacing.space24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 21),
                    child: CleverButton(
                      label: l10n.cleverIntroCta,
                      style: CleverButtonStyle.action,
                      height: 58,
                      labelStyle: CleverTypography.h3.copyWith(
                        color: CleverColors.textOnDark,
                      ),
                      onTap: _openSheet,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
              // The panel sheet.
              AnimatedBuilder(
                animation: _sheetAnimation,
                builder: (context, child) {
                  return Positioned(
                    left: 0,
                    right: 0,
                    top: screenH * (1 - 0.90 * _sheetAnimation.value),
                    bottom: bottomInset,
                    child: child!,
                  );
                },
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onVerticalDragUpdate: (details) {
                    _sheet.value =
                        (_sheet.value - details.primaryDelta! / (screenH * 0.9))
                            .clamp(0.0, 1.0);
                  },
                  onVerticalDragEnd: (details) {
                    final closing =
                        (details.primaryVelocity ?? 0) > 500 ||
                        _sheet.value < 0.5;
                    if (closing) {
                      _closeSheet();
                    } else {
                      _sheet.forward();
                    }
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: CleverColors.bgAction,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(CleverRadius.sheet),
                      ),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (constraints.maxHeight > 64)
                              GestureDetector(
                                onTap: _closeSheet,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    child: Container(
                                      width: 47,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: CleverColors.bgCanvas,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            Expanded(
                              child: currentPage == 0
                                  ? CleverHeaderStep(
                                      onNext: () => ref
                                          .read(onboardingFormProvider.notifier)
                                          .nextPage(),
                                    )
                                  : OnboardingPage(
                                      shouldTrackOnInit: false,
                                      initialPage: currentPage,
                                    ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CareerBankHero extends StatelessWidget {
  const _CareerBankHero();

  @override
  Widget build(BuildContext context) {
    return Text(
      'career bank ',
      style: CleverTypography.display.copyWith(color: CleverColors.textPrimary),
    );
  }
}

/// The intro's progress bar differs from the welcome steps: orange gradient
/// line with the counter at body-sm.
class _IntroProgressBar extends StatelessWidget {
  const _IntroProgressBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2.5),
            child: Container(
              height: 5,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF9812E), CleverColors.bgAction],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: CleverSpacing.space8),
        Text(
          '8/8',
          style: CleverTypography.bodySm.copyWith(
            color: CleverColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
