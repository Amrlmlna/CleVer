import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// Generates a stable, privacy-respecting device fingerprint
/// used for cross-account abuse detection.
///
/// The fingerprint combines:
/// 1. A platform-native ID (android.id / identifierForVendor)
/// 2. A persistent UUID stored in SharedPreferences
///
/// The result is SHA-256 hashed so the raw identifiers never leave the device.
class DeviceIdService {
  static const _persistentIdKey = 'clever_device_persistent_id';
  static String? _cachedId;

  /// Returns a stable device fingerprint, cached after first call.
  static Future<String> getDeviceId() async {
    if (_cachedId != null) return _cachedId!;

    final platformId = await _getPlatformId();
    final persistentId = await _getOrCreatePersistentId();

    // Combine both signals and hash for a stable, non-reversible fingerprint
    final raw = '$platformId:$persistentId';
    _cachedId = sha256.convert(utf8.encode(raw)).toString();

    return _cachedId!;
  }

  /// Gets the platform-native device identifier.
  /// - Android: `android.id` (stable per factory reset)
  /// - iOS: `identifierForVendor` (stable per app reinstall)
  static Future<String> _getPlatformId() async {
    try {
      final deviceInfo = DeviceInfoPlugin();

      if (Platform.isAndroid) {
        final android = await deviceInfo.androidInfo;
        return android.id; // Unique per device + factory reset
      } else if (Platform.isIOS) {
        final ios = await deviceInfo.iosInfo;
        return ios.identifierForVendor ?? 'ios_unknown';
      }
    } catch (e) {
      // Graceful fallback — don't crash the app over fingerprinting
    }

    return 'platform_unknown';
  }

  /// Gets or creates a persistent UUID that survives app updates.
  /// On Android this survives reinstalls if SharedPreferences backup is enabled.
  static Future<String> _getOrCreatePersistentId() async {
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString(_persistentIdKey);

    if (id == null || id.isEmpty) {
      id = const Uuid().v4();
      await prefs.setString(_persistentIdKey, id);
    }

    return id;
  }
}
