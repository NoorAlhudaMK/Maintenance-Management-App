import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../../Data/Models/maintenance_team_member_model.dart';
import '../BLoC/tech_bloc.dart';
import '../BLoC/tech_state.dart';

class TechnicianProfileView extends StatelessWidget {
  final String techID;

  const TechnicianProfileView({super.key, required this.techID});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TechBloc, TechState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        TeamMemberModel? member;
        try {
          member = state.technicians.firstWhere((m) => m.id.toString() == techID);
        } catch (_) {
          member = null;
        }

        if (member == null) {
          return Scaffold(
            appBar: AppBar(backgroundColor: Colors.transparent),
            body: const Center(
              child: Text("لم يتم العثور على بيانات الفني", style: TextStyle(fontSize: 16)),
            ),
          );
        }

        return SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: AppColors.scaffoldBackground,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeader(member),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle("إحصائيات المهام (هذا الشهر)"),
                          const SizedBox(height: 15),
                          _buildStatsGrid(member),
                          const SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildSectionTitle("آخر المهام المكتملة"),
                              TextButton(
                                onPressed: () {},
                                child: Text("عرض الكل", style: TextStyle(color: AppColors.primary)),
                              ),
                            ],
                          ),
                          _buildRecentTasksList(member),
                        ],
                      ),
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

  Widget _buildHeader(TeamMemberModel member) {
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
              member.name.isNotEmpty ? member.name[0] : '?',
              style: TextStyle(color: AppColors.primary, fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            member.name,
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          _badge(
            "${member.teamName} | ID: ${member.id}",
            Colors.white.withOpacity(0.15),
            Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(TeamMemberModel member) {
    // استخدام بيانات الـ ticket_summary القادمة من الـ API بشكل حقيقي وآمن
    final summary = member.ticketSummary;
    final total = summary?.total ?? 0;
    final completed = summary?.completed ?? 0;
    final inProgress = summary?.inProgress ?? 0;

    return StaggeredGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: [
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: _statCard(
            total.toString(),
            "إجمالي المهام",
            Icons.assignment_outlined,
            Colors.blue,
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 2,
          child: _statCard(
            completed.toString(),
            "مهمة مكتملة",
            Icons.check_circle_outline,
            AppColors.success,
            isLarge: true,
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: _statCard(
            inProgress.toString(),
            "قيد التنفيذ",
            Icons.timer_outlined,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTasksList(TeamMemberModel member) {
    // يمكنك لاحقاً ربطها بقائمة مهام حقيقية تأتي من الموديل إن توفرت
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 2, // كمثال توضيحي
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color: AppColors.cardShadow.withOpacity(0.05), blurRadius: 5)],
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.success, size: 24),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("مهمة صيانة #${index + 1}", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMain)),
                    Text("تم الإنجاز بنجاح بواسطة ${member.name}", style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_back_ios_new, size: 14, color: Colors.grey),
            ],
          ),
        );
      },
    );
  }

  Widget _statCard(String value, String label, IconData icon, Color color, {bool isLarge = false}) {
    return Container(
      padding: EdgeInsets.all(isLarge ? 10 : 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.cardShadow.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: isLarge ? 30 : 20),
          ),
          const SizedBox(height: 10),
          Text(value, style: TextStyle(fontSize: isLarge ? 28 : 20, fontWeight: FontWeight.bold, color: AppColors.textMain)),
          Text(label, style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMain));
  }

  Widget _badge(String text, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Text(text, style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.w500)),
    );
  }
}