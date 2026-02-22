import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../../core/providers/notification_provider.dart';
import '../../common/widgets/custom_app_bar.dart';

class NotificationPage extends ConsumerWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationProvider);

    return Scaffold(
      appBar: CustomAppBar(title: AppLocalizations.of(context)!.notifications),
      body: notifications.isEmpty
          ? _buildEmptyState(context)
          : _buildNotificationList(context, ref, notifications),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.notifications_none_outlined, size: 64, color: Colors.grey[700]),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noNotifications,
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList(BuildContext context, WidgetRef ref, List notifications) {
    return ListView.builder(
      itemCount: notifications.length,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: notification.isRead 
                  ? Colors.white.withValues(alpha: 0.04)
                  : Colors.blue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_active_outlined,
              color: notification.isRead ? Colors.grey : Colors.blue,
              size: 20,
            ),
          ),
          title: Text(
            (notification.title == null || notification.title!.isEmpty)
                ? AppLocalizations.of(context)!.notificationNew
                : notification.title!,
            style: TextStyle(
              fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
              color: Colors.white,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.body,
                style: TextStyle(color: Colors.grey[400], fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                timeago.format(notification.timestamp),
                style: TextStyle(color: Colors.grey[600], fontSize: 11),
              ),
            ],
          ),
          onTap: () {
            ref.read(notificationProvider.notifier).markAsRead(notification.id);
          },
        );
      },
    );
  }
}
