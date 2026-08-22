import '../../../Data/Models/notification_model.dart';

class NotificationsState {
  final List<NotificationModel> todayNotifications;
  final List<NotificationModel> yesterdayNotifications;
  final bool isLoading;
  final String? errorMessage;

  NotificationsState({
    this.todayNotifications = const [],
    this.yesterdayNotifications = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  NotificationsState copyWith({
    List<NotificationModel>? todayNotifications,
    List<NotificationModel>? yesterdayNotifications,
    bool? isLoading,
    String? errorMessage,
  }) {
    return NotificationsState(
      todayNotifications: todayNotifications ?? this.todayNotifications,
      yesterdayNotifications: yesterdayNotifications ?? this.yesterdayNotifications,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}