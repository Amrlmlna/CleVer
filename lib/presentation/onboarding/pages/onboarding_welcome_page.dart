import 'package:flutter/material.dart';
import '../../auth/widgets/gradient_button.dart';
import '../widgets/onboarding_carousel_screen.dart';
import 'onboarding_page.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class OnboardingWelcomePage extends StatefulWidget {
  const OnboardingWelcomePage({super.key});

  @override
  State<OnboardingWelcomePage> createState() => _OnboardingWelcomePageState();
}

class _OnboardingWelcomePageState extends State<OnboardingWelcomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _showForm = false;

  @override
  void initState() {
    super.initState();
    AnalyticsService().trackEvent('onboarding_started');
  }

  List<Map<String, dynamic>> _getScreens(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      {
        'headline': l10n.onboardingHeadline1,
        'subtext': l10n.onboardingSubtext1,
        'imageAsset': 'assets/images/onboarding_screen_1.png',
      },
      {
        'headline': l10n.onboardingHeadline2,
        'subtext': l10n.onboardingSubtext2,
        'imageAsset': 'assets/images/onboarding_screen_2.png',
      },
      {
        'headline': l10n.onboardingHeadline3,
        'subtext': l10n.onboardingSubtext3,
        'imageAsset': 'assets/images/onboarding_screen_3.png',
      },
      {
        'headline': l10n.onboardingHeadline4,
        'subtext': l10n.onboardingSubtext4,
        'imageAsset': 'assets/images/onboarding_screen_4.png',
      },
      {
        'headline': l10n.onboardingHeadline6,
        'subtext': l10n.onboardingSubtext6,
        'imageAsset': 'assets/images/onboarding_screen_5.png',
      },
      {
        'headline': l10n.onboardingHeadline7,
        'subtext': l10n.onboardingSubtext7,
        'imageAsset': 'assets/images/onboarding_screen_6.png',
      },
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext(int totalScreens) {
    if (_currentPage < totalScreens - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    } else {
      setState(() {
        _showForm = true;
      });
    }
  }

  void _onSkip() {
    setState(() {
      _showForm = true;
    });
  }

  Widget _buildDotIndicator(int itemCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: _currentPage == index ? 24 : 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final screens = _getScreens(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Carousel
          Positioned.fill(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: screens.length,
                    itemBuilder: (context, index) {
                      final screen = screens[index];
                      return OnboardingCarouselScreen(
                        headline: screen['headline'] as String,
                        subtext: screen['subtext'] as String,
                        imageAsset: screen['imageAsset'] as String?,
                      );
                    },
                  ),
                ),

                // Bottom Area with Dots and Buttons
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildDotIndicator(screens.length),
                        const SizedBox(height: 48),

                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          child: _currentPage == screens.length - 1
                              ? Column(
                                  key: const ValueKey('cta'),
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: GradientButton(
                                        text: l10n.getStarted,
                                        onPressed: () =>
                                            _onNext(screens.length),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                      Text(
                                        l10n.takesLessThan3Min,
                                        style: textTheme.titleSmall?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                          fontWeight: FontWeight.w500,
                                        ),
                                    ),
                                  ],
                                )
                              : Row(
                                  key: const ValueKey('nav'),
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Skip — subtle, clearly secondary
                                    TextButton(
                                      onPressed: _onSkip,
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 12,
                                        ),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(
                                        l10n.skipIntro,
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: colorScheme.onSurface
                                              .withValues(alpha: 0.45),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),

                                    // Next — white pill with arrow, clearly primary
                                    ElevatedButton(
                                      onPressed: () =>
                                          _onNext(screens.length),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black,
                                        padding: const EdgeInsets.only(
                                          left: 28,
                                          right: 20,
                                          top: 16,
                                          bottom: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(32),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            l10n.next,
                                            style: textTheme.titleMedium
                                                ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Icon(
                                            Icons.arrow_forward_rounded,
                                            size: 18,
                                            color: Colors.black,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // The Form (Sliding up from bottom)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 700),
            curve: Curves.fastOutSlowIn,
            top: _showForm ? height * 0.12 : height,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.sheetSurface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x66000000),
                    blurRadius: 40,
                    offset: Offset(0, -10),
                  ),
                ],
              ),
              child: Theme(
                data: AppTheme.sheetTheme,
                child: const OnboardingPage(),
              ),
            ),
          ),

          // Back button to collapse form
          if (_showForm)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 16, // Adjusted slightly for safety
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _showForm = false;
                  });
                },
                icon: const Icon(Icons.arrow_downward, color: AppColors.white),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.black.withValues(alpha: 0.55),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
