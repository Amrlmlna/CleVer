import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_controller.dart';
import '../../../domain/entities/notification_entity.dart';
import 'package:uuid/uuid.dart';

const _storageKey = 'notification_history';

class NotificationNotifier extends StateNotifier<List<NotificationEntity>> {
  NotificationNotifier() : super([]) {
    _loadFromStorage();
    _listenToActions();
  }

  void _listenToActions() {
    NotificationController.displayStreamController.stream.listen((receivedNotification) {
      final notification = NotificationEntity(
        id: const Uuid().v4(),
        title: receivedNotification.title,
        body: receivedNotification.body ?? '',
        timestamp: DateTime.now(),
        payload: receivedNotification.payload != null ? jsonEncode(receivedNotification.payload) : null,
      );
      addNotification(notification);
    });
  }

  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString != null) {
      final List<dynamic> decoded = jsonDecode(jsonString);
      state = decoded.map((item) => NotificationEntity.fromJson(item)).toList();
    }
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(state.map((item) => item.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }

  void addNotification(NotificationEntity notification) {
    state = [notification, ...state];
    _saveToStorage();
  }

  void markAsRead(String id) {
    state = state.map((item) {
      if (item.id == id) {
        return item.copyWith(isRead: true);
      }
      return item;
    }).toList();
    _saveToStorage();
  }

  void markAllAsRead() {
    state = state.map((item) => item.copyWith(isRead: true)).toList();
    _saveToStorage();
  }

  void clearAll() {
    state = [];
    _saveToStorage();
  }
}

final notificationProvider = StateNotifierProvider<NotificationNotifier, List<NotificationEntity>>((ref) {
  return NotificationNotifier();
});

final unreadNotificationCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationProvider);
  return notifications.where((n) => !n.isRead).length;
});
