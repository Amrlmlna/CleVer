import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Activity types
enum ActivityType {
  cvCreated,
  cvUpdated,
  profileUpdated,
  cvImported,
}

/// Activity model
class Activity {
  final ActivityType type;
  final String title;
  final DateTime timestamp;

  Activity({
    required this.type,
    required this.title,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'title': title,
        'timestamp': timestamp.toIso8601String(),
      };

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        type: ActivityType.values.firstWhere((e) => e.name == json['type']),
        title: json['title'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}

/// Activity service for tracking user activities
class ActivityService {
  static const String _key = 'user_activities';
  static const int _maxActivities = 10; // Keep last 10 activities

  /// Get all activities
  static Future<List<Activity>> getActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final String? activitiesJson = prefs.getString(_key);
    
    if (activitiesJson == null) return [];
    
    final List<dynamic> decoded = jsonDecode(activitiesJson);
    return decoded.map((json) => Activity.fromJson(json)).toList();
  }

  /// Add new activity
  static Future<void> addActivity(Activity activity) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Get existing activities
    final activities = await getActivities();
    
    // Add new activity at the beginning
    activities.insert(0, activity);
    
    // Keep only last N activities
    if (activities.length > _maxActivities) {
      activities.removeRange(_maxActivities, activities.length);
    }
    
    // Save back
    final encoded = jsonEncode(activities.map((a) => a.toJson()).toList());
    await prefs.setString(_key, encoded);
  }

  /// Clear all activities
  static Future<void> clearActivities() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  /// Log CV created
  static Future<void> logCVCreated(String cvTitle) async {
    await addActivity(Activity(
      type: ActivityType.cvCreated,
      title: 'Created "$cvTitle"',
      timestamp: DateTime.now(),
    ));
  }

  /// Log CV updated
  static Future<void> logCVUpdated(String cvTitle) async {
    await addActivity(Activity(
      type: ActivityType.cvUpdated,
      title: 'Updated "$cvTitle"',
      timestamp: DateTime.now(),
    ));
  }

  /// Log profile updated
  static Future<void> logProfileUpdated() async {
    await addActivity(Activity(
      type: ActivityType.profileUpdated,
      title: 'Updated master profile',
      timestamp: DateTime.now(),
    ));
  }

  /// Log CV imported
  static Future<void> logCVImported() async {
    await addActivity(Activity(
      type: ActivityType.cvImported,
      title: 'Imported CV data',
      timestamp: DateTime.now(),
    ));
  }
}
