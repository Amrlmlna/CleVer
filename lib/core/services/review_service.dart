import 'package:in_app_review/in_app_review.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../presentation/common/widgets/review_success_dialog.dart';
import 'analytics_service.dart';

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

    if (!hasGenerated) {
      debugPrint(
        '[ReviewService] No successful generation detected yet. skipping.',
      );
      return;
    }

    if (context.mounted) {
      AnalyticsService().trackEvent('review_prompt_viewed');
      final result = await ReviewSuccessDialog.show(context);

      await prefs.setBool(_reviewFlagKey, true);

      if (result == true) {
        AnalyticsService().trackReviewInteraction('positive');
        await requestReview();
      } else if (result == false) {
        AnalyticsService().trackReviewInteraction('constructive');
        await requestReview();
      } else {
        AnalyticsService().trackReviewInteraction('dismissed');
      }
    }
  }

  Future<void> requestReview() async {
    try {
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

  Future<void> openStoreListing() async {
    try {
      await _inAppReview.openStoreListing(appStoreId: 'com.clevermaster.app');
    } catch (e) {
      debugPrint('ReviewService Store Error: $e');
    }
  }
}
