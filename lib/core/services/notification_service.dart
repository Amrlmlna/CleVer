import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'notification_controller.dart';

class NotificationService {
  static Future<void> init({
    String? cvChannelName,
    String? cvChannelDesc,
    String? generalChannelName,
    String? generalChannelDesc,
  }) async {
    await AwesomeNotifications().initialize(
      'resource://drawable/notification_icon',
      [
        NotificationChannel(
          channelKey: 'cv_generation',
          channelName: cvChannelName ?? 'CV Generation',
          channelDescription: cvChannelDesc ?? 'Notifications for CV generation updates',
          defaultColor: const Color(0xFF1E1E1E),
          importance: NotificationImportance.High,
          channelShowBadge: true,
          onlyAlertOnce: true,
          playSound: true,
          criticalAlerts: true,
        ),
        NotificationChannel(
          channelKey: 'general_alerts',
          channelName: generalChannelName ?? 'General Alerts',
          channelDescription: generalChannelDesc ?? 'General app notifications',
          defaultColor: const Color(0xFF1E1E1E),
          importance: NotificationImportance.Default,
          channelShowBadge: true,
          playSound: true,
        ),
      ],
      debug: true,
    );

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod: NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: NotificationController.onDismissActionReceivedMethod,
    );

    await _initFirebaseMessaging();
  }

  static Future<void> updateChannelLocalization({
    required String cvChannelName,
    required String cvChannelDesc,
    required String generalChannelName,
    required String generalChannelDesc,
  }) async {
    await AwesomeNotifications().setChannel(
      NotificationChannel(
        channelKey: 'cv_generation',
        channelName: cvChannelName,
        channelDescription: cvChannelDesc,
        defaultColor: const Color(0xFF1E1E1E),
        importance: NotificationImportance.High,
        channelShowBadge: true,
        onlyAlertOnce: true,
        playSound: true,
        criticalAlerts: true,
      ),
    );
    await AwesomeNotifications().setChannel(
      NotificationChannel(
        channelKey: 'general_alerts',
        channelName: generalChannelName,
        channelDescription: generalChannelDesc,
        defaultColor: const Color(0xFF1E1E1E),
        importance: NotificationImportance.Default,
        channelShowBadge: true,
        playSound: true,
      ),
    );
  }

  static Future<void> _initFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('User granted FCM permission: ${settings.authorizationStatus}');

    String? token = await messaging.getToken();
    debugPrint('FCM Token: $token');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      String? title = message.notification?.title ?? message.data['title'];
      String? body = message.notification?.body ?? message.data['body'];

      if (title != null || body != null) {
        showSimpleNotification(
          title: title ?? '',
          body: body ?? '',
          payload: message.data['route'],
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('A new onMessageOpenedApp event was published!');
    });
  }

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    debugPrint("Handling a background message: ${message.messageId}");
    
  }

  static Future<void> showSimpleNotification({
    String? title,
    required String body,
    String? payload,
    String channelKey = 'general_alerts',
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: channelKey,
        title: title,
        body: body,
        payload: payload != null ? {'route': payload} : null,
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }

  static Future<void> showProgressNotification({
    required int id,
    required String title,
    required String body,
    required int progress,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'cv_generation',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.ProgressBar,
        progress: progress.toDouble(),
        locked: true,
      ),
    );
  }

  static Future<void> requestPermissions() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }
}
