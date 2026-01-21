import 'package:flutter/foundation.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  Future<void> init({required String apiKey, required String host}) async {
    // PostHog for Flutter is auto-initialized via AndroidManifest/Info.plist usually,
    // but we can also configure it programmatically if needed or just use it.
    // Ideally, for Flutter, we set values in AndroidManifest.xml and Info.plist.
    // However, we'll keep this method for any manual setup checks (e.g. opting out in debug).
    
    if (kDebugMode) {
      // In debug mode, we might want to disable capture or log that we are in debug.
      // PostHog().disable(); // Optional: Uncomment to disable in debug
      debugPrint('AnalyticsService: Initialized (Debug Mode)');
    }
  }

  Future<void> screenView(String screenName, {Map<String, Object>? properties}) async {
    try {
      await Posthog().screen(screenName: screenName, properties: properties);
    } catch (e) {
      debugPrint('Analytics Error (Screen): $e');
    }
  }

  Future<void> trackEvent(String eventName, {Map<String, Object>? properties}) async {
    try {
      await Posthog().capture(eventName: eventName, properties: properties);
    } catch (e) {
      debugPrint('Analytics Error (Track): $e');
    }
  }

  Future<void> identifyUser(String userId, {Map<String, Object>? userProperties}) async {
    try {
      await Posthog().identify(userId: userId, userProperties: userProperties);
    } catch (e) {
      debugPrint('Analytics Error (Identify): $e');
    }
  }
  
  Future<void> reset() async {
     try {
      await Posthog().reset();
    } catch (e) {
      debugPrint('Analytics Error (Reset): $e');
    }
  }
}
