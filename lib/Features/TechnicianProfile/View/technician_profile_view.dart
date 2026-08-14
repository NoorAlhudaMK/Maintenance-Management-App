import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../../Data/Models/TechnicianModel.dart';
import '../../Auth/BLoC/auth_bloc.dart';
import '../../Auth/BLoC/auth_event.dart';
import '../../Auth/BLoC/auth_state.dart';
import '../../Auth/View/login_view.dart';

class TechnicianProfileView extends StatelessWidget {
  final TechnicianModel tech;
  const TechnicianProfileView({super.key, required this.tech});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginView()),
            (route) => false,
          );
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      },
      child: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: AppColors.scaffoldBackground,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(context, tech),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle("إحصائيات هذا الشهر"),
                        const SizedBox(height: 15),
                        _buildStatsGrid(tech),
                        const SizedBox(height: 25),
                        _buildRecentTasksHeader(),
                        const SizedBox(height: 15),
                        _buildRecentTasksList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- الهيدر مع زر تسجيل الخروج ---
  Widget _buildHeader(BuildContext context, TechnicianModel tech) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 10, left: 10, right: 20, bottom: 30),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: const Icon(Icons.logout_rounded, color: Colors.white70),
              onPressed: () => _showLogoutDialog(context),
            ),
          ),
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Text(
              tech.initials,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            tech.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _badge(
            "فني ${tech.specialty} | ${tech.id}",
            Colors.white.withOpacity(0.15),
            Colors.white,
          ),
        ],
      ),
    );
  }

  // --- شبكة الإحصائيات (Staggered Grid) ---
  Widget _buildStatsGrid(TechnicianModel tech) {
    return StaggeredGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: _statCard(
            tech.rating.toString(),
            "تقييمك العام",
            Icons.star_rounded,
            Colors.orange,
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 2,
          child: _statCard(
            tech.completedTasks.toString(),
            "مهمة مكتملة",
            Icons.check_circle_outline,
            AppColors.greenStatus,
            isLarge: true,
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: _statCard(
            tech.onTimePercentage,
            "الإنجاز في الوقت",
            Icons.timer_outlined,
            AppColors.primary,
          ),
        ),
      ],
    );
  }

  // --- هيدر المهام الأخيرة ---
  Widget _buildRecentTasksHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSectionTitle("آخر المهام المكتملة"),
        TextButton(
          onPressed: () {},
          child: Text(
            "عرض الكل",
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // --- قائمة المهام الأخيرة ---
  Widget _buildRecentTasksList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 24),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "088-2024# | عطل كهربائي",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "شقة 1B - بناية A",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_back_ios_new,
                size: 14,
                color: Colors.grey,
              ),
            ],
          ),
        );
      },
    );
  }

  // --- كارت الإحصائيات الفردي ---
  Widget _statCard(
    String value,
    String label,
    IconData icon,
    Color color, {
    bool isLarge = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: isLarge ? 40 : 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: isLarge ? 32 : 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textMain,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textMain,
      ),
    );
  }

  Widget _badge(String text, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // --- نافذة تأكيد تسجيل الخروج ---
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
            content: const Text("هل تريد تسجيل الخروج من حسابك؟"),
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
                  "تسجيل خروج",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
