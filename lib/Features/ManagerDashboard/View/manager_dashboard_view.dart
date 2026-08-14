import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/CacheManager/cache_manager.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../../Core/FormattedDateTime/get_arabic_date.dart';
import '../../AddReport/View/add_new_report_view.dart';
import '../../Auth/BLoC/auth_bloc.dart';
import '../../Auth/BLoC/auth_event.dart';
import '../../Notification/View/notification_view.dart';

class ManagerDashboardView extends StatelessWidget {
  const ManagerDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: _buildAppBar(context),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              _buildHeader(),
              const SizedBox(height: 25),
              _buildStatsGrid(),
              const SizedBox(height: 35),
              _buildLatestReportsHeader(context),
              const SizedBox(height: 15),
              _buildLatestReportCard(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 70,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationsView(),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(color: AppColors.cardShadow, blurRadius: 10),
              ],
            ),
            child: Icon(
              AppColors.isDark
                  ? Icons.dark_mode_outlined
                  : Icons.notifications_none_outlined,
              color: AppColors.isDark ? AppColors.accent : Colors.grey,
            ),
          ),
        ),
      ),
      title: Text(
        "لوحة التحكم",
        style: TextStyle(
          color: AppColors.textMain,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          // 2. تغليف الصورة بـ GestureDetector لتنفيذ الخروج
          child: GestureDetector(
            onTap: () => _showLogoutDialog(context),
            child: CircleAvatar(
              radius: 22,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: const NetworkImage(
                "https://static.vecteezy.com/system/resources/thumbnails/051/767/450/small_2x/3d-cartoon-man-with-glasses-and-beard-illustration-free-png.png",
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text("تنبيه"),
            content: const Text("هل تريد تسجيل الخروج من حساب المدير؟"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(
                  "إلغاء",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // إرسال حدث الخروج للبلوك
                  context.read<AuthBloc>().add(LogoutRequested());
                  Navigator.pop(dialogContext);
                },
                child: const Text(
                  "خروج",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return FutureBuilder<String>(
      future: _getUserName(),
      builder: (context, snapshot) {
        return Row(
          children: [
            const Text("👋", style: TextStyle(fontSize: 24)),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "مرحباً، ${snapshot.data ?? '...'}",
                  style: TextStyle(
                    color: AppColors.textMain,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  getArabicFormattedDate(),
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 0.9,
      children: [
        _buildStatCard(
          icon: Icons.people_alt_outlined,
          color: AppColors.greenStatus,
          count: "٨",
          title: "الفنيون المتاحون",
          bgColor: AppColors.greenBackground,
        ),
        _buildStatCard(
          icon: Icons.assignment_outlined,
          color: AppColors.blueStatus,
          count: "٢٤",
          title: "البلاغات المفتوحة",
          bgColor: AppColors.blueBackground,
        ),
        _buildStatCard(
          icon: Icons.error_outline_outlined,
          color: AppColors.redStatus,
          count: "٣",
          title: "بلاغات طارئة",
          bgColor: AppColors.redBackground,
          hasTopBorder: true,
        ),
        _buildStatCard(
          icon: Icons.check_circle_outline,
          color: AppColors.orangeStatus,
          count: "١٥",
          title: "مكتملة اليوم",
          bgColor: AppColors.orangeBackground,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color color,
    required String count,
    required String title,
    required Color bgColor,
    bool hasTopBorder = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: hasTopBorder
            ? Border(top: BorderSide(color: color, width: 4))
            : null,
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 15),
          Text(
            count,
            style: TextStyle(
              color: color,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildLatestReportsHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "آخر البلاغات",
          style: TextStyle(
            color: AppColors.textMain,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddNewReportView()),
            );
          },
          style: TextButton.styleFrom(
            backgroundColor: AppColors.primary.withOpacity(0.1),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            "+ إضافة بلاغ", //  "عرض الكل",
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLatestReportCard() {
    return Column(
      children: [
        _buildReportItem(
          id: "REQ-2051",
          status: "طارئ",
          statusColor: const Color(0xFFFFE5E5),
          statusTextColor: Colors.red,
          location: "عمارة 4 • الطابق 2 • شقة 12",
          description: "تسريب مياه من سقف الحمام الرئيسي، يرجى التدخل الفوري.",
          icon: Icons.opacity,
          iconColor: Colors.blue,
          hasRightBorder: true,
        ),
        const SizedBox(height: 20),
        _buildReportItem(
          id: "REQ-2050",
          status: "جديد",
          statusColor: const Color(0xFFE3F2FD),
          statusTextColor: Colors.blue,
          location: "عمارة 1 • الطابق 5 • شقة 40",
          description: "انقطاع متكرر للتيار الكهربائي في المطبخ.",
          icon: Icons.bolt,
          iconColor: Colors.orange,
          hasRightBorder: false,
        ),
      ],
    );
  }

  Widget _buildReportItem({
    required String id,
    required String status,
    required Color statusColor,
    required Color statusTextColor,
    required String location,
    required String description,
    required IconData icon,
    required Color iconColor,
    bool hasRightBorder = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: hasRightBorder
            ? const Border(right: BorderSide(color: Colors.red, width: 5))
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: iconColor, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    id,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A3B5D),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.apartment, size: 16, color: Colors.grey.shade400),
              const SizedBox(width: 5),
              Text(
                location,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 15,
              height: 1.4,
              color: Color(0xFF455A64),
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A3B5D),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
              elevation: 0,
            ),
            child: const Text(
              "تحويل",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> _getUserName() async {
    final user = await CacheManager.getUserModel();
    return user.name;
  }
}
