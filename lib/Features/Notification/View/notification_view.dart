import 'package:anydrawer/anydrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import '../../../Core/Colors/app_colors.dart';
import '../../../Data/Models/notification_model.dart';
import '../../../Data/Repositories/notifications_repository.dart';
import '../../Drawer/View/drawer_view.dart';
import '../BLoC/notification_bloc.dart';
import '../BLoC/notification_event.dart';
import '../BLoC/notification_state.dart';

class NotificationsView extends StatelessWidget {
  final String role;
  NotificationsView( {super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          NotificationsBloc(repository: NotificationsRepository())
            ..add(LoadNotificationsEvent()),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          appBar: _buildAppBar(context),
          body: BlocBuilder<NotificationsBloc, NotificationsState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.errorMessage != null) {
                return Center(
                  child: Text(
                    "حدث خطأ في التحميل",
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                );
              }

              if (state.todayNotifications.isEmpty &&
                  state.yesterdayNotifications.isEmpty) {
                return Center(
                  child: Text(
                    "لا توجد إشعارات حالياً",
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                );
              }

              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  if (state.todayNotifications.isNotEmpty) ...[
                    _buildSectionTitle("اليوم"),
                    ...state.todayNotifications.map(
                      (n) => _buildNotificationCard(n),
                    ),
                  ],
                  if (state.yesterdayNotifications.isNotEmpty) ...[
                    _buildSectionTitle("الأمس"),
                    ...state.yesterdayNotifications.map(
                      (n) => _buildNotificationCard(n),
                    ),
                  ],
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        "الإشــعــارات",
        style: TextStyle(
          color: AppColors.textMain,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      automaticallyImplyActions: false,
      automaticallyImplyLeading: false,
      leading: this.role == "supervisor" ? IconButton(
        onPressed: ()  {
         Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back_ios_sharp),
      ) :  IconButton(
        onPressed: () async {
          showDrawer(
            context,
            builder: (context) {
              return AppDrawer(role: "technician");
            },
          );
        },
        icon: Icon(Icons.menu_outlined),
      ),
      actions: [
        Builder(
          builder: (dialogContext) => TextButton(
            onPressed: () {
              dialogContext.read<NotificationsBloc>().add(MarkAllAsReadEvent());
            },
            child: Text(
              "تعليم الكل مقروء",
              style: TextStyle(
                color: AppColors.textMain,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel n) {
    NotificationType type = n.mapToEnum;

    IconData icon;
    Color iconColor;
    Color bgColor;

    switch (type) {
      case NotificationType.emergency:
        icon = Icons.error_outline;
        iconColor = AppColors.redStatus;
        bgColor = AppColors.redBackground;
        break;
      case NotificationType.success:
        icon = Icons.check_circle_outline;
        iconColor = AppColors.greenStatus;
        bgColor = AppColors.greenBackground;
        break;
      case NotificationType.waiting:
        icon = Icons.access_time;
        iconColor = Colors.orange;
        bgColor = const Color(0xFFFFF4E5);
        break;
      case NotificationType.rating:
        icon = Icons.star_rounded;
        iconColor = AppColors.success;
        bgColor = AppColors.greenBackground;
        break;
      default:
        icon = Icons.assignment_outlined;
        iconColor = Colors.blueGrey;
        bgColor = AppColors.iconBackground;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // إخفاء النقطة الزرقاء تلقائياً بمجرد أن تصبح isRead تساوي true
          if (!n.isRead)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: CircleAvatar(
                radius: 3,
                backgroundColor: AppColors.primary,
              ),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      n.title,
                      style: TextStyle(
                        color: AppColors.textMain,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      intl.DateFormat(
                        'hh:mm a',
                      ).format(DateTime.parse(n.createdAt)),
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  n.body,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 20),
          ),
        ],
      ),
    );
  }
}
