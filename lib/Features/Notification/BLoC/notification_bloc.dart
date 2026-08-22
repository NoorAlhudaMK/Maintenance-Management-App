import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Data/Models/notification_model.dart';
import '../../../Data/Repositories/notifications_repository.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationsRepository repository;

  NotificationsBloc({required this.repository}) : super(NotificationsState(isLoading: true)) {

    on<LoadNotificationsEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      try {
        final response = await repository.getNotifications();

        final now = DateTime.now();
        List<NotificationModel> today = [];
        List<NotificationModel> yesterday = [];

        for (var n in response.notifications) {
          final date = DateTime.parse(n.createdAt);
          if (date.year == now.year && date.month == now.month && date.day == now.day) {
            today.add(n);
          } else {
            yesterday.add(n);
          }
        }

        emit(state.copyWith(
          todayNotifications: today,
          yesterdayNotifications: yesterday,
          isLoading: false,
        ));
      } catch (e) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        ));
      }
    });

    on<MarkAllAsReadEvent>((event, emit) async {
      try {
        List<int> unreadIds = [];

        for (var n in state.todayNotifications) {
          if (!n.isRead) unreadIds.add(n.id);
        }
        for (var n in state.yesterdayNotifications) {
          if (!n.isRead) unreadIds.add(n.id);
        }

        if (unreadIds.isEmpty) return;

        final success = await repository.markNotificationsAsRead(unreadIds);

        if (success) {
          final updatedToday = state.todayNotifications.map((n) {
            if (unreadIds.contains(n.id)) {
              return n.copyWith(isRead: true);
            }
            return n;
          }).toList();

          final updatedYesterday = state.yesterdayNotifications.map((n) {
            if (unreadIds.contains(n.id)) {
              return n.copyWith(isRead: true);
            }
            return n;
          }).toList();

          emit(state.copyWith(
            todayNotifications: updatedToday,
            yesterdayNotifications: updatedYesterday,
          ));
        }
      } catch (e) {
        print("Error marking notifications as read: $e");
      }
    });
  }
}