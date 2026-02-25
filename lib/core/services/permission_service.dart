import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class PermissionService {
  static Future<void> requestAllPermissions() async {
    [
      Permission.notification,
      Permission.camera,
      if (Platform.isAndroid) ...[
        Permission.storage,
        Permission.photos,
      ] else ...[
        Permission.photos,
      ],
    ].request().then((statuses) {
      statuses.forEach((permission, status) {
        debugPrint('Permission ${permission.toString()}: $status');
      });
    });
  }

  static Future<bool> openSettings() async {
    return openAppSettings();
  }
}
