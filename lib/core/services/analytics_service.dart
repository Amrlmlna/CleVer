import 'package:posthog_flutter/posthog_flutter.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();

  factory AnalyticsService() {
    return _instance;
  }

  AnalyticsService._internal();


  Future<void> trackEvent(String eventName, {Map<String, Object>? properties}) async {
    await Posthog().capture(
      eventName: eventName,
      properties: properties,
    );
  }

  Future<void> identifyUser(String userId, {Map<String, Object>? userProperties}) async {
    await Posthog().identify(
      userId: userId,
      userProperties: userProperties,
    );
  }

  Future<void> reset() async {
    await Posthog().reset();
  }
}
