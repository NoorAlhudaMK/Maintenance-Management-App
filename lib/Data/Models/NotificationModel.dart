class NotificationModel {
  final String title;
  final String subtitle;
  final String time;
  final NotificationType type;
  bool isRead;

  NotificationModel({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.type,
    this.isRead = false
  });
}

enum NotificationType { emergency, success, waiting, normal, rating }