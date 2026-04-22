import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationController {
  static final StreamController<ReceivedAction> actionStreamController =
      StreamController<ReceivedAction>.broadcast();
  static final StreamController<ReceivedNotification> displayStreamController =
      StreamController<ReceivedNotification>.broadcast();

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    debugPrint('Notification created: ${receivedNotification.id}');
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    debugPrint('Notification displayed: ${receivedNotification.id}');
    displayStreamController.add(receivedNotification);
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    debugPrint('Notification dismissed: ${receivedAction.id}');
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    debugPrint('Notification action received: ${receivedAction.id}');
    actionStreamController.add(receivedAction);

    // Check for a URL in the payload and launch it
    final payload = receivedAction.payload;
    final url =
        payload?['url'] ??
        payload?['route'] ??
        payload?['link'] ??
        payload?['target_url'];

    if (url != null && url.isNotEmpty) {
      await _launchUrl(url);
    }
  }

  /// Opens a URL externally (browser or Play Store app)
  static Future<void> _launchUrl(String urlString) async {
    final uri = Uri.tryParse(urlString);
    if (uri == null) return;
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Could not launch URL: $urlString — $e');
    }
  }

  /// Call this from onMessageOpenedApp (FCM tap when app was killed/background)
  static Future<void> handleFcmTap(Map<String, dynamic> data) async {
    final url =
        data['url'] ?? data['route'] ?? data['link'] ?? data['target_url'];

    if (url != null && url.toString().isNotEmpty) {
      await _launchUrl(url.toString());
    }
  }
}
