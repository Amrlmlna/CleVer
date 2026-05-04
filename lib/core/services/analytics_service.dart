import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();

  factory AnalyticsService() {
    return _instance;
  }

  AnalyticsService._internal();

  Future<void> trackEvent(
    String eventName, {
    Map<String, Object>? properties,
  }) async {
    debugPrint('📊 Analytics: Tracking $eventName with $properties');
    await Posthog().capture(eventName: eventName, properties: properties);
  }

  Future<void> identifyUser(
    String userId, {
    Map<String, Object>? userProperties,
  }) async {
    await Posthog().identify(userId: userId, userProperties: userProperties);
  }

  Future<void> reset() async {
    await Posthog().reset();
  }

  // MARK: - Granular Analytics

  Future<void> trackOnboardingStep(String phase, int stepIndex) async {
    await trackEvent(
      'onboarding_${phase}_step_viewed',
      properties: {'phase': phase, 'step_index': stepIndex},
    );
  }

  Future<void> trackAuthGuardViewed({String? feature}) async {
    await trackEvent(
      'auth_guard_viewed',
      properties: {if (feature != null) 'feature': feature},
    );
  }

  Future<void> trackAuthGuardInteraction(
    String action, {
    String? feature,
    String? method,
  }) async {
    await trackEvent(
      'auth_guard_interaction',
      properties: {
        'action': action,
        if (feature != null) 'feature': feature,
        if (method != null) 'method': method,
      },
    );
  }

  Future<void> trackPaywallViewed({String? templateId, String? source}) async {
    await trackEvent(
      'paywall_viewed_post_generation',
      properties: {
        if (templateId != null) 'template_id': templateId,
        if (source != null) 'source': source,
      },
    );
  }

  Future<void> trackPaywallInteraction(
    String action, {
    String? templateId,
    String? packageId,
  }) async {
    await trackEvent(
      'paywall_interaction',
      properties: {
        'action': action,
        if (templateId != null) 'template_id': templateId,
        if (packageId != null) 'package_id': packageId,
      },
    );
  }

  Future<void> trackReviewInteraction(String choice) async {
    await trackEvent(
      'review_prompt_interaction',
      properties: {'choice': choice},
    );
  }

  // MARK: - Momentum Flow

  Future<void> trackMomentumStep(
    String stepName, {
    Map<String, Object>? properties,
  }) async {
    await trackEvent(
      'momentum_step_viewed',
      properties: {'momentum_step': stepName, ...?properties},
    );
  }

  Future<void> trackCvExportStarted({required String templateId}) async {
    await trackEvent(
      'cv_export_started',
      properties: {'template_id': templateId},
    );
  }

  Future<void> trackHomepageViewed({bool isNewUserFlow = false}) async {
    await trackEvent(
      'homepage_viewed',
      properties: {'is_new_user_flow': isNewUserFlow},
    );
  }

  Future<void> trackTutorialViewed(String target) async {
    await trackEvent(
      'homepage_tutorial_viewed',
      properties: {'tip_target': target},
    );
  }

  /// Sends a dummy event to force PostHog to register property names for suggestions.
  Future<void> debugWarmup() async {
    await trackEvent(
      'analytics_debug_ping',
      properties: {
        'momentum_step': 'warmup',
        'feature': 'warmup',
        'action': 'warmup',
      },
    );
  }
}
