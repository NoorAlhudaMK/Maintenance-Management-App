import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../../Data/Repositories/manager_repository.dart';
import '../../ManagerDashboard/BLoC/manager_dashboard_bloc.dart';
import '../../ManagerDashboard/BLoC/manager_dashboard_event.dart';
import '../../ManagerDashboard/View/manager_dashboard_view.dart';
import '../../ManagerIncomingReports/View/incoming_reports_view.dart';
import '../../Reports/View/reports_view.dart';
import '../../Technician/View/technicians_view.dart';
import '../BLoC/home_bloc.dart';
import '../BLoC/home_event.dart';
import '../BLoC/home_state.dart';

class ManagerMainHomePage extends StatelessWidget {
   ManagerMainHomePage({super.key});

  final List<Widget> _pages = [
    BlocProvider(
      create: (context) => ManagerDashboardBloc(
        managerRepository: ManagerRepository(),
      )..add(FetchManagerDashboardData(teamId: 1)), ///TODO: ضع رقم الـ team_id الصحيح هنا
      child: const ManagerDashboardView(teamId: 1),
    ),
    IncomingReportsView(),
    TechniciansView(),
    ReportsView(),
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
                    icon: Icon(Icons.home_outlined),
                    label: "لوحة التحكم",
                  ),
                  BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "البلاغات"),
                  BottomNavigationBarItem(icon: Icon(Icons.people_outline_sharp), label: "الفنيون"),
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
