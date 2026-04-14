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
      if (await _inAppReview.isAvailable()) {
        await _inAppReview.requestReview();
      }
    } catch (e) {
      debugPrint('ReviewService Error: $e');
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

