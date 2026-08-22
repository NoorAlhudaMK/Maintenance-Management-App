import 'package:anydrawer/anydrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintenance_management_app/Features/Technician/View/technician_profile_view.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../../Data/Models/maintenance_team_member_model.dart';
import '../../Drawer/View/drawer_view.dart';
import '../../Notification/View/notification_view.dart';
import '../BLoC/tech_bloc.dart';
import '../BLoC/tech_event.dart';
import '../BLoC/tech_state.dart';

class TechniciansView extends StatelessWidget {
  const TechniciansView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: _buildAppBar(context),
        body: Column(
          children: [
            _buildStatsRow(),
            _buildSearchBox(context),
            const SizedBox(height: 15.0),
            // _buildFilterBar(),
            Expanded(child: _buildTechList()),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      automaticallyImplyActions: false,
      centerTitle: true,
      title: Text(
        "الــفــنــيــون",
        style: TextStyle(
          color: AppColors.textMain,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        onPressed: () async {
          showDrawer(
            context,
            builder: (context) {
              return AppDrawer(role: "supervisor");
            },
          );
        },
        icon: Icon(Icons.menu_outlined),
      ),
      actions: [
        Stack(
          alignment: Alignment.topLeft,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationsView(role: "supervisor"),
                  ),
                );
              },
              icon: Icon(Icons.notifications_none, color: AppColors.textMain),
            ),
            Positioned(
              top: 12,
              left: 12,
              child: CircleAvatar(
                radius: 4,
                backgroundColor: AppColors.redStatus,
              ),
            ),
          ],
        ),
        // Padding(
        //   padding: const EdgeInsets.only(left: 8.0),
        //   child: Container(
        //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        //     decoration: BoxDecoration(
        //       color: AppColors.success,
        //       borderRadius: BorderRadius.circular(20),
        //     ),
        //     child: const Row(
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         Text(
        //           "تلقائي",
        //           style: TextStyle(color: Colors.white, fontSize: 14),
        //         ),
        //         SizedBox(width: 5),
        //         Icon(Icons.auto_awesome, color: Colors.white, size: 16),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return BlocBuilder<TechBloc, TechState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              _statBox(state.totalCount.toString(), "إجمالي الفنيين", Colors.black, Colors.white),
              const SizedBox(width: 10),
              _statBox(state.availableCount.toString(), "متاح", AppColors.success, const Color(0xFFE8F5E9)),
              const SizedBox(width: 10),
              _statBox(state.busyCount.toString(), "مشغول", Colors.orange, const Color(0xFFFFF8E1)),
            ],
          ),
        );
      },
    );
  }

  Widget _statBox(String value, String label, Color color, Color bgColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.black.withOpacity(0.05))),
        child: Column(
          children: [
            Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
            Text(label, style: TextStyle(color: color.withOpacity(0.7), fontSize: 11, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        onChanged: (value) {
          context.read<TechBloc>().add(SearchTechEvent(value));
        },
        decoration: InputDecoration(
          hintText: "ابحث عن فني...",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  // Widget _buildFilterBar() {
  //   return BlocBuilder<TechBloc, TechState>(
  //     builder: (context, state) {
  //       return SingleChildScrollView(
  //         scrollDirection: Axis.horizontal,
  //         padding: const EdgeInsets.all(20),
  //         child: Row(
  //           children: [
  //             _filterChip(context, "الكل", TechStatus.all, state.selectedStatus),
  //             _filterChip(context, "متاح", TechStatus.available, state.selectedStatus),
  //             _filterChip(context, "مشغول", TechStatus.busy, state.selectedStatus),
  //             _filterChip(context, "غير متاح", TechStatus.notAvailable, state.selectedStatus),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
  //
  // Widget _filterChip(BuildContext context, String label, TechStatus status, TechStatus? selected) {
  //   bool isSelected = status == selected;
  //   return GestureDetector(
  //     onTap: () {},
  //     child: Container(
  //       margin: const EdgeInsets.only(left: 10),
  //       padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
  //       decoration: BoxDecoration(color: isSelected ? AppColors.primary : Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
  //       child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
  //     ),
  //   );
  // }

  Widget _buildTechList() {
    return BlocBuilder<TechBloc, TechState>(
      builder: (context, state) {
        if (state.isLoading) return const Center(child: CircularProgressIndicator());

        final members = state.technicians;

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: members.length,
          itemBuilder: (context, index) => _technicianCard(members[index], Icons.engineering, context),
        );
      },
    );
  }

  Widget _technicianCard(TeamMemberModel member, IconData specializationIcon, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 55, height: 55,
            decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15)
            ),
            alignment: Alignment.center,
            child: Text(
                member.name.isNotEmpty ? member.name[0] : '?',
                style:  TextStyle(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.bold)
            ),
          ),
          const SizedBox(width: 15),

          // بيانات الفني
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member.name, style: TextStyle(color: AppColors.textMain, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Wrap(spacing: 8, runSpacing: 5, children: [
                  _infoBadge(member.teamName, specializationIcon, Colors.blue),
                  _infoBadge(member.id.toString(), Icons.badge_outlined, Colors.grey),
                ]),
              ],
            ),
          ),

          // زر عرض الملف
          IconButton(
            onPressed: () {
              context.read<TechBloc>().add(LoadTechProfileEvent(member.id.toString()));
              print("The selected member is : ${member.id}");
              Navigator.push(context, MaterialPageRoute(builder: (context) => TechnicianProfileView(techID: member.id.toString())));
            },
            icon: Icon(Icons.arrow_forward_ios, size: 18, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _infoBadge(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _ratingBadge(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("$rating", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(width: 4),
        const Icon(Icons.star, color: Colors.orange, size: 16),
      ],
    );
  }

  IconData parseIcon(String icon) {
    switch (icon) {
      case 'bolt_outlined':
        return Icons.bolt_outlined;
      case 'build':
        return Icons.build;
      case 'engineering':
        return Icons.engineering;
      case 'electrical_services':
        return Icons.electrical_services;
      case 'plumbing':
        return Icons.plumbing;
      case 'construction':
        return Icons.construction;
      default:
        return Icons.build;
    }
  }
}