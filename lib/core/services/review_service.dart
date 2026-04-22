import 'package:in_app_review/in_app_review.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../presentation/common/widgets/review_success_dialog.dart';
import '../../l10n/generated/app_localizations.dart';

class ReviewService {
  static final ReviewService _instance = ReviewService._internal();
  factory ReviewService() => _instance;
  ReviewService._internal();

  final InAppReview _inAppReview = InAppReview.instance;
  static const String _reviewFlagKey = 'has_prompted_native_review_v1';
  static const String _successFlagKey = 'has_generated_at_least_one_cv';

  Future<bool> hasGeneratedAtLeastOneCv() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_successFlagKey) ?? false;
  }

  Future<void> requestReviewWithBlur(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final hasPrompted = prefs.getBool(_reviewFlagKey) ?? false;
    final hasGenerated = prefs.getBool(_successFlagKey) ?? false;

    if (hasPrompted) {
      debugPrint(
        '[ReviewService] Native review already prompted before. Skipping.',
      );
      return;
    }

    // Always ensure they have at least one generation success for quality control
    if (!hasGenerated) {
      debugPrint(
        '[ReviewService] No successful generation detected yet. skipping.',
      );
      return;
    }

    if (context.mounted) {
      final result = await ReviewSuccessDialog.show(context);

      if (result == true) {
        // Positive: Native Review (or store fallback)
        await prefs.setBool(_reviewFlagKey, true);
        await requestReview();
      } else if (result == false) {
        // Negative/Feedback: Open Email
        await sendFeedback(context);
      }
    }
  }

  Future<void> requestReview() async {
    try {
      // In Debug mode, the native prompt is silent.
      // We force a Store redirection so the dev can see it works.
      if (kDebugMode) {
        debugPrint(
          '[ReviewService] Debug mode: Forcing Store Listing fallback.',
        );
        await openStoreListing();
        return;
      }

      final isAvailable = await _inAppReview.isAvailable();
      if (isAvailable) {
        await _inAppReview.requestReview();
      } else {
        await openStoreListing();
      }
    } catch (e) {
      debugPrint('ReviewService Error: $e');
      await openStoreListing();
    }
  }

  Future<void> sendFeedback(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'cvfast.contact@gmail.com',
      query: encodeQueryParameters({
        'subject': l10n.feedbackEmailSubject,
        'body': l10n.feedbackEmailBody,
      }),
    );

    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open email app')),
          );
        }
      }
    } catch (e) {
      debugPrint('Feedback Error: $e');
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  Future<void> openStoreListing() async {
    try {
      // package_info_plus can be used here to get dynamic ID, but com.clevermaster.app is correct for now
      await _inAppReview.openStoreListing(appStoreId: 'com.clevermaster.app');
    } catch (e) {
      debugPrint('ReviewService Store Error: $e');
    }
  }
}
