import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class PermissionService {
  
  /// Requests all core permissions needed by the app at startup.
  /// 
  /// Permissions requested:
  /// - Notification (All platforms)
  /// - Camera (All platforms)
  /// - Storage / Photos (Platform specific)
  static Future<void> requestAllPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.notification,
      Permission.camera,
      // Storage permissions vary by Android version
      if (Platform.isAndroid) ...[
         Permission.storage, // Android < 13
         Permission.photos,  // Android 13+
      ] else ...[
         Permission.photos, // iOS
      ]
    ].request();

    // Optional: Log results or handle denials if strict enforcement is needed
    statuses.forEach((permission, status) {
      debugPrint('Permission ${permission.toString()}: $status');
    });
  }

  static Future<bool> openSettings() async {
    return openAppSettings();
  }
}
