import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../ManagerDashboard/View/manager_dashboard_view.dart';
import '../BLoC/home_bloc.dart';
import '../BLoC/home_event.dart';
import '../BLoC/home_state.dart';

class MainHomePage extends StatelessWidget {
   MainHomePage({super.key});

  final List<Widget> _pages = [
    ManagerDashboardView(),
    Container(color: Colors.blue,),
    Container(color: Colors.yellow,),
    Container(color: Colors.green,),
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
                    label: "الرئيسية",
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
