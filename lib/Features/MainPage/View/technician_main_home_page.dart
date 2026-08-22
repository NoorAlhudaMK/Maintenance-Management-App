import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:maintenance_management_app/Features/Notification/View/notification_view.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../../Data/Models/TechnicianModel.dart';
import '../../TechnicianProfile/View/technician_profile_view.dart';
import '../../TechnicianTasks/View/technician_tasks_view.dart';
import '../BLoC/home_bloc.dart';
import '../BLoC/home_event.dart';
import '../BLoC/home_state.dart';

class TechnicianMainHomePage extends StatefulWidget {
  const TechnicianMainHomePage({super.key});

  @override
  State<TechnicianMainHomePage> createState() => _TechnicianMainHomePageState();
}

class _TechnicianMainHomePageState extends State<TechnicianMainHomePage> {
  late final PageController _pageController;
  late final NotchBottomBarController _notchController;

  final List<Widget> _pages = [
    const TechnicianTasksView(),
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
     NotificationsView(role: "technician",),
  ];

  @override
  void initState() {
    super.initState();
    final initialIndex = context.read<HomeBloc>().state.currentIndex;
    _pageController = PageController(initialPage: initialIndex);
    _notchController = NotchBottomBarController(index: initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _notchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (_pageController.hasClients && _pageController.page?.round() != state.currentIndex) {
          _pageController.jumpToPage(state.currentIndex);
          _notchController.jumpTo(state.currentIndex);
        }
      },
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.scaffoldBackground,
              extendBody: true,
              body: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: _pages,
              ),
              bottomNavigationBar: AnimatedNotchBottomBar(
                notchBottomBarController: _notchController,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                color: Colors.white,
                showLabel: true,
                textOverflow: TextOverflow.visible,
                maxLine: 1,
                shadowElevation: 0,
                kBottomRadius: 28.0,
                notchColor: AppColors.primary,
                removeMargins: false,
                bottomBarWidth: 500,
                showShadow: true,
                durationInMilliSeconds: 300,
                itemLabelStyle: const TextStyle(fontSize: 12, fontFamily: 'Cairo'),
                elevation: 1,
                kIconSize: 24.0,
                bottomBarItems: const [
                  BottomBarItem(
                    inActiveItem: Icon(Icons.list_rounded, color: Colors.blueGrey),
                    activeItem: Icon(Icons.list_rounded, color: Colors.white),
                    itemLabel: 'المهام',
                  ),
                  BottomBarItem(
                    inActiveItem: Icon(Icons.bar_chart_sharp, color: Colors.blueGrey),
                    activeItem: Icon(Icons.bar_chart_sharp, color: Colors.white),
                    itemLabel: 'التقارير',
                  ),
                  BottomBarItem(
                    inActiveItem: Icon(Icons.notifications_outlined, color: Colors.blueGrey),
                    activeItem: Icon(Icons.notifications_active, color: Colors.white),
                    itemLabel: 'الإشعارات',
                  ),
                ],
                onTap: (index) {
                  _pageController.jumpToPage(index);
                  context.read<HomeBloc>().add(ChangeTabEvent(index));
                },
              ),
            ),
          ),
        );
      },
    );
  }
}