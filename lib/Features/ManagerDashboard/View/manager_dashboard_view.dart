import 'package:flutter/material.dart';
import '../../../Core/Colors/app_colors.dart';

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
              _buildLatestReportsHeader(),
              const SizedBox(height: 15),
              _buildLatestReportCard(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  // الجزء العلوي (التطبيقبار)
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 70,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 10)],
            ),
            child: Icon(
              AppColors.isDark ? Icons.dark_mode_outlined : Icons.notifications_none_outlined,
              color: AppColors.isDark ? AppColors.accent : Colors.grey,
            ),
          ),
        ),
      ),
      title: Text(
        "لوحة التحكم",
        style: TextStyle(color: AppColors.textMain, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: CircleAvatar(
            radius: 22,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: const NetworkImage("https://via.placeholder.com/150"), // ضع رابط الصورة هنا
          ),
        ),
      ],
    );
  }

  // الترحيب بالمدير
  Widget _buildHeader() {
    return Row(
      children: [
        const Text("👋", style: TextStyle(fontSize: 28)),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "مرحباً، المدير عمر",
              style: TextStyle(color: AppColors.textMain, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              "السبت، ٢٨ مارس ٢٠٢٦",
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  // شبكة الإحصائيات (الأربعة بطاقات)
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

  // بناء بطاقة إحصاء فردية
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
        border: hasTopBorder ? Border(top: BorderSide(color: color, width: 4)) : null,
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 15, offset: const Offset(0, 5))],
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
            style: TextStyle(color: color, fontSize: 26, fontWeight: FontWeight.bold),
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

  // عنوان "آخر البلاغات"
  Widget _buildLatestReportsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "آخر البلاغات",
          style: TextStyle(color: AppColors.textMain, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            "عرض الكل",
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
      ],
    );
  }

  // بطاقة "آخر بلاغ"
  Widget _buildLatestReportCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 15, offset: const Offset(0, 5))],
      ),
      padding: const EdgeInsets.all(15),
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "عطل سباكة (تسريب)",
                    style: TextStyle(color: AppColors.textMain, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "عمارة ٤ - شقة ١٢",
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.redBackground, shape: BoxShape.circle),
                child: Icon(Icons.build_outlined, color: AppColors.redStatus, size: 22),
              ),
            ],
          ),
          // الـ Badge "طارئ"
          Positioned(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.redBackground,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                "طارئ",
                style: TextStyle(color: AppColors.redStatus, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}