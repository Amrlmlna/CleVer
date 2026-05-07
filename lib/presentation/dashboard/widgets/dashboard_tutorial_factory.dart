import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../../core/services/tutorial_service.dart';

class DashboardTutorialFactory {
  static TutorialCoachMark create({
    required BuildContext context,
    required GlobalKey draftsKey,
    required GlobalKey profileKey,
    required Function(int) onTabTap,
    required VoidCallback onComplete,
  }) {
    final List<TargetFocus> targets = [
      TargetFocus(
        identify: "nav_drafts",
        keyTarget: draftsKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return _buildTutorialContent(
                context: context,
                title: AppLocalizations.of(context)!.tutorialDraftsTitle,
                description: AppLocalizations.of(context)!.tutorialDraftsDesc,
                buttonLabel: AppLocalizations.of(context)!.tutorialNext,
                onNext: () => controller.next(),
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: "nav_profile",
        keyTarget: profileKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return _buildTutorialContent(
                context: context,
                title: AppLocalizations.of(context)!.tutorialProfileTitle,
                description: AppLocalizations.of(context)!.tutorialProfileDesc,
                buttonLabel: AppLocalizations.of(context)!.tutorialFinish,
                onNext: () => controller.next(),
              );
            },
          ),
        ],
      ),
    ];

    return TutorialCoachMark(
      targets: targets,
      onClickTarget: (target) {
        if (target.identify == "nav_drafts") {
          onTabTap(1);
        } else if (target.identify == "nav_profile") {
          onTabTap(3);
        }
      },
      alignSkip: Alignment.bottomCenter,
      colorShadow: Colors.black,
      textSkip: AppLocalizations.of(context)!.skipIntro,
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        TutorialService().markNavTutorialAsShown();
        onComplete();
      },
      onSkip: () {
        TutorialService().markNavTutorialAsShown();
        onComplete();
        return true;
      },
    );
  }

  static Widget _buildTutorialContent({
    required BuildContext context,
    required String title,
    required String description,
    required String buttonLabel,
    required VoidCallback onNext,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        const SizedBox(height: 10),
        Text(description, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(buttonLabel),
          ),
        ),
      ],
    );
  }
}
