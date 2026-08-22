import 'notification_model.dart';

class NotificationsResponse {
  final bool success;
  final String message;
  final List<NotificationModel> notifications;
  final int unreadCount;

  NotificationsResponse({
    required this.success,
    required this.message,
    required this.notifications,
    required this.unreadCount,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data']?['notifications'] ?? json['notifications'] ?? [];
    List<NotificationModel> parsedList = (list as List)
        .map((item) => NotificationModel.fromJson(item))
        .toList();

    int unread = json['data']?['unread_count'] ?? json['unread_count'] ?? 0;

    return NotificationsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      notifications: parsedList,
      unreadCount: unread,
    );
  }
}