import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../../Data/Models/TechnicianModel.dart';
import '../../ManagerDashboard/View/manager_dashboard_view.dart';
import '../../ManagerIncomingReports/View/incoming_reports_view.dart';
import '../../Reports/View/reports_view.dart';
import '../../Technician/View/technicians_view.dart';
import '../../TechnicianProfile/View/technician_profile_view.dart';
import '../../TechnicianTasks/View/technician_tasks_view.dart';
import '../BLoC/home_bloc.dart';
import '../BLoC/home_event.dart';
import '../BLoC/home_state.dart';

class TechnicianMainHomePage extends StatelessWidget {
  TechnicianMainHomePage({super.key});

  final List<Widget> _pages = [
    TechnicianTasksView(),
    TechnicianProfileView(
      tech: TechnicianModel(
        id: "EMP-0042",
        name: "أشرف عبد الغفور",
        specialty: "كهرباء",
        initials: "أش",
        rating: 4.9,
        activeTasks: 0,
        status: TechStatus.available,
        avatarColor: const Color(0xFFE3F2FD),
        isAvailable: true,
        completedTasks: 28,
        onTimePercentage: "96%",
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.scaffoldBackground,

              body: _pages[state.currentIndex],

              bottomNavigationBar: BottomNavigationBar(
                currentIndex: state.currentIndex,
                onTap: (index) {
                  context.read<HomeBloc>().add(ChangeTabEvent(index));
                },
                backgroundColor: AppColors.scaffoldBackground,
                selectedItemColor: AppColors.primary,
                unselectedItemColor: AppColors.textSecondary,
                type: BottomNavigationBarType.fixed,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.list_rounded),
                    label: "المهام",
                  ),
                  BottomNavigationBarItem(icon: Icon(Icons.bar_chart_sharp), label: "التقارير"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
