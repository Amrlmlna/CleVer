import 'package:flutter/material.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class OnboardingShell extends StatelessWidget {
  final int currentPage;
  final int totalSteps;
  final Widget child;

  const OnboardingShell({
    super.key,
    required this.currentPage,
    required this.totalSteps,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentPage == totalSteps - 1 ? AppLocalizations.of(context)!.youreAllSet : AppLocalizations.of(context)!.dropYourDetails,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1.2,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 12),
              if (currentPage == 0) ...[
                Text(
                  AppLocalizations.of(context)!.onboardingSubtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),

        if (currentPage > 0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: LinearProgressIndicator(
              value: (currentPage + 1) / totalSteps,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
          ),

        Expanded(child: child),
      ],
    );
  }
}
