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

  Future<void> requestReviewWithBlur(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final hasPrompted = prefs.getBool(_reviewFlagKey) ?? false;

    if (hasPrompted) {
      debugPrint('[ReviewService] Native review already prompted before. Skipping.');
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

