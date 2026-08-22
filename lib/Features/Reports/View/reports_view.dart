import 'package:anydrawer/anydrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../../Core/Services/PdfReportService.dart';
import '../../Drawer/View/drawer_view.dart';
import '../../Notification/View/notification_view.dart';
import '../BLoC/reports_bloc.dart';
import '../BLoC/reports_event.dart';
import '../BLoC/reports_state.dart';

class ReportsView extends StatelessWidget {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReportsStatsBloc()..add(ChangeTimeFilterEvent("هذا الأسبوع")),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          appBar: _buildAppBar(context),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _buildTimeFilterBar(),
                const SizedBox(height: 20),
                _buildStatsGrid(),
                const SizedBox(height: 25),
                _buildTeamPerformanceSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return  AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      automaticallyImplyActions: false,
      centerTitle: true,
      title: Text(
        "الــتــقــاريــر",
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
        BlocBuilder<ReportsStatsBloc, ReportsStatsState>(
          builder: (context, state) {
            return IconButton(
              onPressed: () {
                PdfReportService.generateAndSaveReport(state);
              },
              icon: const Icon(Icons.file_download_outlined, color: Colors.blueGrey),
            );
          },
        ),
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

  Widget _buildTimeFilterBar() {
    final filters = ["اليوم", "هذا الأسبوع", "هذا الشهر", "مخصص"];

    return BlocBuilder<ReportsStatsBloc, ReportsStatsState>(
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: filters.map((f) {
              bool isSelected = f == state.selectedFilter;
              return Container(
                margin: const EdgeInsets.only(left: 10),
                child: ChoiceChip(
                  label: Text(f,
                      style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                          fontWeight: FontWeight.bold)),
                  selected: isSelected,
                  selectedColor: AppColors.primary,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onSelected: (val) {
                    if (f == "مخصص") {
                      _showCustomDatePicker(context);
                    } else {
                      context.read<ReportsStatsBloc>().add(ChangeTimeFilterEvent(f));
                    }
                  },
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showCustomDatePicker(BuildContext context) async {
    final DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024), // بداية عمل النظام
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary, // لون العناوين والاختيار
              onPrimary: Colors.white,
              onSurface: AppColors.textMain,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          ),
        );
      },
    );

    if (result != null) {
      context.read<ReportsStatsBloc>().add(
          ChangeTimeFilterEvent("مخصص", customRange: result)
      );
    }
  }

  Widget _buildStatsGrid() {
    return BlocBuilder<ReportsStatsBloc, ReportsStatsState>(
      builder: (context, state) {
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          childAspectRatio: 1.1,
          children: [
            _statCard("${state.totalReports}", "إجمالي البلاغات", Icons.assignment_outlined, Colors.blue),
            _statCard(state.completionRate, "نسبة الإنجاز", Icons.check_circle_outline, AppColors.success),
            _statCard(state.avgClosingTime, "متوسط الإغلاق", Icons.access_time, Colors.orange),
            _statCard("${state.residentsRating}", "تقييم السكان", Icons.star_border_rounded, Colors.orangeAccent),
          ],
        );
      },
    );
  }

  Widget _statCard(String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Icon(icon, color: color.withOpacity(0.6), size: 24),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamPerformanceSection() {
    return BlocBuilder<ReportsStatsBloc, ReportsStatsState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
            ],
          ),
          child: Column(
            children: [
              Text("أداء الفريق ${state.selectedFilter}",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              ...state.teamPerformance.map((tech) =>
                  _performanceRow(
                      tech.name, "${tech.tasksCount} مهام", tech.progress,
                      tech.percentage)
              ).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _performanceRow(
    String name,
    String tasks,
    double progress,
    String percent,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                tasks,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.success),
            ),
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              percent,
              style: TextStyle(
                color: AppColors.success,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
