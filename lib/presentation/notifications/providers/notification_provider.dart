import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/app_notification.dart';
import '../../../../data/repositories/mock_notification_repository.dart';

class NotificationState {
  final bool isLoading;
  final List<AppNotification> notifications;

  const NotificationState({
    this.isLoading = false,
    this.notifications = const [],
  });

  NotificationState copyWith({
    bool? isLoading,
    List<AppNotification>? notifications,
  }) {
    return NotificationState(
      isLoading: isLoading ?? this.isLoading,
      notifications: notifications ?? this.notifications,
    );
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;
}

class NotificationNotifier extends Notifier<NotificationState> {
  final _repository = MockNotificationRepository();

  @override
  NotificationState build() {
    // Load notifications on init
    loadNotifications();
    return const NotificationState(isLoading: true);
  }

  Future<void> loadNotifications() async {
    state = state.copyWith(isLoading: true);
    final notifications = await _repository.getNotifications();
    state = state.copyWith(
      isLoading: false,
      notifications: notifications,
    );
  }

  void markAsRead(String id) {
    final updatedList = state.notifications.map((n) {
      if (n.id == id) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();
    
    state = state.copyWith(notifications: updatedList);
  }

  void markAllAsRead() {
    final updatedList = state.notifications.map((n) {
      return n.copyWith(isRead: true);
    }).toList();
    state = state.copyWith(notifications: updatedList);
  }

  void removeNotification(String id) {
    final updatedList = state.notifications.where((n) => n.id != id).toList();
    state = state.copyWith(notifications: updatedList);
  }
}

final notificationProvider = NotifierProvider<NotificationNotifier, NotificationState>(NotificationNotifier.new);
