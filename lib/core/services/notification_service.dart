import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
          channelDescription:
              cvChannelDesc ?? 'Notifications for CV generation updates',
          defaultColor: const Color(0xFF000000),
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
          defaultColor: const Color(0xFF000000),
          importance: NotificationImportance.Default,
          channelShowBadge: true,
          playSound: true,
        ),
      ],
      debug: true,
    );

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
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
        defaultColor: const Color(0xFF000000),
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
        defaultColor: const Color(0xFF000000),
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

    // Save token to Firestore so Firebase Console campaigns reach this device
    String? token = await messaging.getToken();
    debugPrint('FCM Token: $token');
    await _saveFcmToken(token);

    // Listen for token refresh (tokens can rotate periodically)
    messaging.onTokenRefresh.listen(_saveFcmToken);

    // Check if the app was opened via a notification when it was terminated
    RemoteMessage? initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint(
        'App opened from terminated state via FCM: ${initialMessage.data}',
      );
      NotificationController.handleFcmTap(initialMessage.data);
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      String? title = message.notification?.title ?? message.data['title'];
      String? body = message.notification?.body ?? message.data['body'];

      if (title != null || body != null) {
        showSimpleNotification(
          title: title ?? '',
          body: body ?? '',
          payload: message.data,
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('A new onMessageOpenedApp event was published!');
      NotificationController.handleFcmTap(message.data);
    });
  }

  /// Saves the FCM token to Firestore under users/{uid}/fcmToken.
  /// This allows Firebase Console to send targeted or broadcast notifications.
  static Future<void> _saveFcmToken(String? token) async {
    if (token == null) return;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set(
        {
          'fcmToken': token,
          'fcmUpdatedAt': FieldValue.serverTimestamp(),
          'platform': 'android',
        },
        SetOptions(merge: true), // never overwrites other user fields
      );
      debugPrint('FCM token saved to Firestore for user $uid');
    } catch (e) {
      debugPrint('Failed to save FCM token: $e');
    }
  }

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    debugPrint("Handling a background message: ${message.messageId}");

    // Background/terminated: we must show the notification manually
    // AwesomeNotifications needs initialization first
    await AwesomeNotifications()
        .initialize('resource://drawable/notification_icon', [
          NotificationChannel(
            channelKey: 'general_alerts',
            channelName: 'General Alerts',
            channelDescription: 'General app notifications',
            defaultColor: const Color(0xFF000000),
            importance: NotificationImportance.High,
            channelShowBadge: true,
            playSound: true,
          ),
        ]);

    final String? title = message.notification?.title ?? message.data['title'];
    final String? body = message.notification?.body ?? message.data['body'];

    if (title != null || body != null) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
          channelKey: 'general_alerts',
          title: title,
          body: body,
          payload: message.data.map(
            (key, value) => MapEntry(key, value.toString()),
          ),
          notificationLayout: NotificationLayout.Default,
        ),
      );
    }
  }

  static Future<void> showSimpleNotification({
    String? title,
    required String body,
    Map<String, dynamic>? payload,
    String channelKey = 'general_alerts',
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: channelKey,
        title: title,
        body: body,
        payload: payload?.map((key, value) => MapEntry(key, value.toString())),
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
