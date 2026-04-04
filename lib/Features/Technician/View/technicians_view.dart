import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintenance_management_app/Features/Technician/View/technician_profile_view.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../../Data/Models/TechnicianModel.dart';
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
        appBar: _buildAppBar(),
        body: Column(
          children: [
            _buildStatsRow(),
            _buildSearchBox(),
            _buildFilterBar(),
            Expanded(child: _buildTechList()),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        "الفنيون",
        style: TextStyle(
          color: AppColors.textMain,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.add, color: AppColors.primary, size: 30),
        ),
      ],
      leading: IconButton(
        onPressed: () {},
        icon: Icon(Icons.notifications_none, color: AppColors.textMain),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          _statBox("12", "إجمالي الفنيين", Colors.black, Colors.white),
          const SizedBox(width: 10),
          _statBox("8", "متاح", AppColors.success, const Color(0xFFE8F5E9)),
          const SizedBox(width: 10),
          _statBox("4", "مشغول", Colors.orange, const Color(0xFFFFF8E1)),
        ],
      ),
    );
  }

  Widget _statBox(String value, String label, Color color, Color bgColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black.withOpacity(0.05)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: color.withOpacity(0.7),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        decoration: InputDecoration(
          hintText: "ابحث عن فني...",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    return BlocBuilder<TechBloc, TechState>(
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              _filterChip(
                context,
                "الكل",
                TechStatus.all,
                state.selectedStatus,
              ),
              _filterChip(
                context,
                "متاح",
                TechStatus.available,
                state.selectedStatus,
              ),
              _filterChip(
                context,
                "مشغول",
                TechStatus.busy,
                state.selectedStatus,
              ),
              _filterChip(
                context,
                "غير متاح",
                TechStatus.notAvailable,
                state.selectedStatus,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _filterChip(
    BuildContext context,
    String label,
    TechStatus status,
    TechStatus selected,
  ) {
    bool isSelected = status == selected;
    return GestureDetector(
      onTap: () => context.read<TechBloc>().add(FilterTechEvent(status)),
      child: Container(
        margin: const EdgeInsets.only(left: 10),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTechList() {
    return BlocBuilder<TechBloc, TechState>(
      builder: (context, state) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: state.technicians.length,
          itemBuilder: (context, index) =>
              _technicianCard(state.technicians[index], context),
        );
      },
    );
  }

  Widget _technicianCard(TechnicianModel tech, BuildContext context) {
    bool isAvailable = tech.status == TechStatus.available;

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
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: tech.avatarColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      tech.initials,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 7,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor: isAvailable
                          ? AppColors.success
                          : Colors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tech.name,
                  style: TextStyle(
                    color: AppColors.textMain,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                Wrap(
                  spacing: 8,
                  runSpacing: 5,
                  children: [
                    _infoBadge(
                      tech.specialty,
                      Icons.bolt_outlined,
                      Colors.blue,
                    ),
                    _infoBadge(tech.id, Icons.badge_outlined, Colors.grey),
                  ],
                ),
                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _ratingBadge(tech.rating),
                    OutlinedButton(
                      onPressed: () {
                        context.read<TechBloc>().add(LoadTechProfileEvent(tech.id));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider.value(
                              value: BlocProvider.of<TechBloc>(context),
                              child: const TechnicianProfileView(),
                            ),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: Text(
                        "عرض الملف",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isAvailable
                  ? AppColors.success.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              isAvailable ? "متاح" : "مشغول",
              style: TextStyle(
                color: isAvailable ? AppColors.success : Colors.orange,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBadge(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
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
        Text(
          "$rating",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(width: 4),
        const Icon(Icons.star, color: Colors.orange, size: 16),
      ],
    );
  }
}
