import 'package:in_app_review/in_app_review.dart';
import 'package:flutter/foundation.dart';

class ReviewService {
  static final ReviewService _instance = ReviewService._internal();
  factory ReviewService() => _instance;
  ReviewService._internal();

  final InAppReview _inAppReview = InAppReview.instance;

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
