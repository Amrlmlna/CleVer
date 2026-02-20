import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../providers/notification_provider.dart';
import '../../../../domain/entities/app_notification.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class NotificationPage extends ConsumerWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(notificationProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.notifications), // You might need to add this key or use raw string if key missing
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: 'Mark all as read',
            onPressed: notificationState.notifications.isEmpty 
                ? null 
                : () => ref.read(notificationProvider.notifier).markAllAsRead(),
          ),
        ],
      ),
      body: notificationState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : notificationState.notifications.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  itemCount: notificationState.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notificationState.notifications[index];
                    return _buildNotificationItem(context, ref, notification);
                  },
                ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context, WidgetRef ref, AppNotification notification) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        ref.read(notificationProvider.notifier).removeNotification(notification.id);
      },
      child: Container(
        color: notification.isRead ? null : Theme.of(context).primaryColor.withOpacity(0.05),
        child: ListTile(
          leading: _buildIcon(notification.type),
          title: Text(
            notification.title,
            style: TextStyle(
              fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(notification.body),
              const SizedBox(height: 6),
              Text(
                timeago.format(notification.timestamp),
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
          onTap: () {
            if (!notification.isRead) {
              ref.read(notificationProvider.notifier).markAsRead(notification.id);
            }
          },
        ),
      ),
    );
  }

  Widget _buildIcon(NotificationType type) {
    switch (type) {
      case NotificationType.success:
        return const Icon(Icons.check_circle, color: Colors.green);
      case NotificationType.warning:
        return const Icon(Icons.warning, color: Colors.orange);
      case NotificationType.alert:
        return const Icon(Icons.error, color: Colors.red);
      case NotificationType.info:
      default:
        return const Icon(Icons.info, color: Colors.blue);
    }
  }
}
