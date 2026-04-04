import '../../../Data/Models/NotificationModel.dart';

class NotificationsState {
  final List<NotificationModel> todayNotifications;
  final List<NotificationModel> yesterdayNotifications;

  NotificationsState({required this.todayNotifications, required this.yesterdayNotifications});
}