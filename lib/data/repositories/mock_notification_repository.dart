import '../../domain/entities/app_notification.dart';

class MockNotificationRepository {
  Future<List<AppNotification>> getNotifications() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    final now = DateTime.now();

    return [
      AppNotification(
        id: '1',
        title: 'Welcome to CleVer!',
        body: 'Start creating your professional CV today with our AI-powered tools.',
        timestamp: now.subtract(const Duration(minutes: 5)),
        type: NotificationType.success,
      ),
      AppNotification(
        id: '2',
        title: 'Profile Incomplete',
        body: 'Don\'t forget to add your education details to get better suggestions.',
        timestamp: now.subtract(const Duration(hours: 2)),
        type: NotificationType.warning,
      ),
      AppNotification(
        id: '3',
        title: 'New Template Added',
        body: 'Check out the new "Modern Tech" template in the gallery.',
        timestamp: now.subtract(const Duration(days: 1)),
        type: NotificationType.info,
      ),
      AppNotification(
        id: '4',
        title: 'Premium Features Unlocked',
        body: 'Thank you for your purchase! You now have unlimited generations.',
        timestamp: now.subtract(const Duration(days: 2)),
        type: NotificationType.success,
        isRead: true,
      ),
      AppNotification(
        id: '5',
        title: 'Weekly Tip',
        body: 'Did you know? Tailoring your CV to the job description increases your chances by 50%.',
        timestamp: now.subtract(const Duration(days: 3)),
        type: NotificationType.info,
        isRead: true,
      ),
    ];
  }
}
