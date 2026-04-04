import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../../Data/Models/TechnicianModel.dart';
import '../BLoC/tech_bloc.dart';
import '../BLoC/tech_state.dart';

class TechnicianProfileView extends StatelessWidget {
  const TechnicianProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TechBloc, TechState>(
      builder: (context, state) {
        final tech = state.selectedTechnician;

        if (tech == null)
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );

        return SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: AppColors.scaffoldBackground,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: [
                        _buildHeader(tech),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle("إحصائيات هذا الشهر"),
                              const SizedBox(height: 15),
                              _buildStatsGrid(tech),
                              const SizedBox(height: 25),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildSectionTitle("آخر 5 مهام مكتملة"),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "عرض الكل",
                                      style: TextStyle(
                                        color: AppColors.textMain,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              _buildRecentTasksList(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(TechnicianModel tech) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 30, bottom: 30),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.white,
            child: Text(
              tech.initials,
              style: TextStyle(color: AppColors.primary, fontSize: 30),
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
          const SizedBox(height: 5),
          _badge(
            "فني ${tech.specialty} | ${tech.id}",
            Colors.white.withOpacity(0.15),
            Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(TechnicianModel tech) {
    return StaggeredGrid.count(
      crossAxisCount: 2, // تقسيم الشاشة لعمودين
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
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

  Widget _buildRecentTasksList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 5)],
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.greenStatus, size: 24),
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
              Icon(
                Icons.arrow_back_ios_new,
                size: 14,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _statCard(
    String value,
    String label,
    IconData icon,
    Color color, {
    bool isLarge = false,
  }) {
    return Container(
      padding: EdgeInsets.all(isLarge ? 10 : 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 10)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: isLarge ? 30 : 20),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: isLarge ? 28 : 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textMain,
            ),
          ),
          Text(
            label,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
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
}
