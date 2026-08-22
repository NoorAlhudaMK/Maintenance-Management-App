enum NotificationType { emergency, success, waiting, rating, normal }

class NotificationModel {
  final int id;
  final int notificationId;
  final String title;
  final String body;
  final String type;
  final String priority;
  final String state;
  final int? relatedTicketId;
  final bool isRead;
  final String createdAt;

  NotificationModel({
    required this.id,
    required this.notificationId,
    required this.title,
    required this.body,
    required this.type,
    required this.priority,
    required this.state,
    this.relatedTicketId,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? 0,
      notificationId: json['notification_id'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? json['message'] ?? '',
      type: json['type'] ?? 'normal',
      priority: json['priority'] ?? 'normal',
      state: json['state'] ?? '',
      relatedTicketId: json['related_ticket_id'],
      isRead: json['is_read'] ?? false,
      createdAt: json['created_at'] ?? '',
    );
  }

  NotificationType get mapToEnum {
    if (priority == 'high' || state == 'failed') return NotificationType.emergency;
    if (type == 'success') return NotificationType.success;
    return NotificationType.normal;
  }

  NotificationModel copyWith({
    int? id,
    int? notificationId,
    String? title,
    String? body,
    String? type,
    String? priority,
    String? state,
    int? relatedTicketId,
    bool? isRead,
    String? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      notificationId: notificationId ?? this.notificationId,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      state: state ?? this.state,
      relatedTicketId: relatedTicketId ?? this.relatedTicketId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}