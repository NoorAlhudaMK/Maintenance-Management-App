import 'package:flutter/material.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../../Data/Models/NotificationModel.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: _buildAppBar(context),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            _buildSectionTitle("اليوم"),
            // UserInfo.userRole == "admin" ? _buildNotificationCard(
            //   type: NotificationType.emergency,
            //   title: "مهمة جديدة طارئة",
            //   subtitle: "تم إسناد بلاغ #090-2024 إليك",
            //   time: "الآن",
            //   showButton: true,
            // ) : Container(),
            _buildNotificationCard(
              type: NotificationType.success,
              title: "تم إنجاز المهمة",
              subtitle: "أغلق الفني أحمد البلاغ #085-2024",
              time: "منذ 20 دقيقة",
            ),
            _buildNotificationCard(
              type: NotificationType.waiting,
              title: "انتظار قطع غيار",
              subtitle: "البلاغ #083-2024 في انتظار قطع غيار",
              time: "منذ ساعة",
            ),
            const SizedBox(height: 10),
            _buildSectionTitle("الأمس"),
            _buildNotificationCard(
              type: NotificationType.normal,
              title: "بلاغ جديد",
              subtitle: "تم استلام بلاغ #081-2024",
              time: "أمس 3:45م",
            ),
            _buildNotificationCard(
              type: NotificationType.rating,
              title: "تقييم الساكن",
              subtitle: "الساكن خالد قيم الخدمة 5 نجوم",
              time: "أمس 1:20م",
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        "الإشعارات",
        style: TextStyle(
          color: AppColors.textMain,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.textMain),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        TextButton(
          onPressed: () {},
          child: Text(
            "تعليم الكل مقروء",
            style: TextStyle(
              color: AppColors.textMain,
              fontWeight: FontWeight.bold,
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

  Widget _buildNotificationCard({
    required NotificationType type,
    required String title,
    required String subtitle,
    required String time,
    bool showButton = false,
  }) {
    // تحديد الألوان والأيقونة بناءً على النوع
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
          // نقطة الإشعار غير المقروء
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: CircleAvatar(radius: 3, backgroundColor: AppColors.primary),
          ),
          const SizedBox(width: 12),
          // محتوى النص
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.textMain,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        color: type == NotificationType.emergency
                            ? AppColors.redStatus
                            : AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                if (showButton) ...[
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size(double.infinity, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "تحويل المهمة",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 15),
          // الأيقونة الملونة
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 24),
          ),
        ],
      ),
    );
  }
}
