import 'package:in_app_review/in_app_review.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../presentation/common/widgets/review_success_dialog.dart';

class ReviewService {
  static final ReviewService _instance = ReviewService._internal();
  factory ReviewService() => _instance;
  ReviewService._internal();

  final InAppReview _inAppReview = InAppReview.instance;
  static const String _reviewFlagKey = 'has_prompted_native_review_v1';
  static const String _successFlagKey = 'has_generated_at_least_one_cv';

  Future<void> requestReviewWithBlur(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final hasPrompted = prefs.getBool(_reviewFlagKey) ?? false;
    final hasGenerated = prefs.getBool(_successFlagKey) ?? false;

    if (hasPrompted) {
      debugPrint('[ReviewService] Native review already prompted before. Skipping.');
      return;
    }

    // Always ensure they have at least one generation success for quality control
    if (!hasGenerated) {
      debugPrint('[ReviewService] No successful generation detected yet. skipping.');
      return;
    }

    if (context.mounted) {
      final shouldReview = await ReviewSuccessDialog.show(context);
      
      if (shouldReview == true) {
        await prefs.setBool(_reviewFlagKey, true);
        await requestReview();
      }
    }
  }

  Future<void> requestReview() async {
    try {
      final isAvailable = await _inAppReview.isAvailable();
      if (isAvailable) {
        // This triggers the native Review Dialog (Play Store / App Store)
        await _inAppReview.requestReview();
      } else {
        // Fallback: If native is not available on this device/region, open the Store page directly
        await openStoreListing();
      }
    } catch (e) {
      debugPrint('ReviewService Error: $e');
      // Final fallback to store listing if unexpected error occurs
      await openStoreListing();
    }
  }

  Future<void> openStoreListing() async {
    try {
      // package_info_plus can be used here to get dynamic ID, but com.clevermaster.app is correct for now
      await _inAppReview.openStoreListing(
        appStoreId: 'com.clevermaster.app',
      );
    } catch (e) {
      debugPrint('ReviewService Store Error: $e');
    }
  }
}

