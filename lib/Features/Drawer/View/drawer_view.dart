import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintenance_management_app/Core/CacheManager/cache_manager.dart';
import 'package:maintenance_management_app/Data/Models/user_model.dart';
import 'package:maintenance_management_app/Features/AddReport/View/add_new_report_view.dart';
import 'package:maintenance_management_app/Features/Notification/View/notification_view.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../AboutApp/View/about_app_view.dart';
import '../../Auth/BLoC/auth_bloc.dart';
import '../../Auth/BLoC/auth_event.dart';
import '../../Auth/View/login_view.dart';
import '../../MainPage/BLoC/home_bloc.dart';
import '../../MainPage/BLoC/home_event.dart';

class AppDrawer extends StatelessWidget {
  final String role;
  const AppDrawer({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: role == "technician"
          ? maintenanceTechnicianDrawer(context)
          : maintenanceAdminDrawer(context),
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'تأكيد تسجيل الخروج',
            style: TextStyle(

              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: const Text(
            'هل أنت متأكد من رغبتك في تسجيل الخروج من التطبيق؟',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'إلغاء',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pop(context);

                context.read<HomeBloc>().add(ChangeTabEvent(0));

                context.read<AuthBloc>().add(LogoutRequested());

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()),
                      (route) => false,
                );
              },
              child: const Text(
                'تسجيل الخروج',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget maintenanceTechnicianDrawer(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: CacheManager.getUserModel(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Drawer(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        UserModel? user = snapshot.data;
        String userName = user?.name ?? 'مستخدم';
        String userEmail = user?.email ?? 'email';

        return Drawer(
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                  ),
                  accountName: Text(
                    userName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  accountEmail: Text(
                    userEmail,
                    style: const TextStyle(),
                  ),
                  currentAccountPicture: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.blueGrey),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.list_rounded),
                  title: const Text('المهام', style: TextStyle()),
                  onTap: () {
                    Navigator.pop(context);
                    context.read<HomeBloc>().add(ChangeTabEvent(0));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.bar_chart_sharp),
                  title: const Text('التقارير / الملف الشخصي',
                      style: TextStyle()),
                  onTap: () {
                    Navigator.pop(context);
                    context.read<HomeBloc>().add(ChangeTabEvent(1));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.notifications_outlined),
                  title: const Text('الإشعارات', style: TextStyle()),
                  onTap: () {
                    Navigator.pop(context);
                    context.read<HomeBloc>().add(ChangeTabEvent(2));
                  },
                ),
                const Divider(height: 30),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('حول التطبيق', style: TextStyle()),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutPage()),
                    );
                  },
                ),
                const Spacer(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    'تسجيل الخروج',
                    style: TextStyle(color: Colors.red, ),
                  ),
                  onTap: () => _handleLogout(context),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget maintenanceAdminDrawer(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: CacheManager.getUserModel(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Drawer(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        UserModel? user = snapshot.data;
        String userName = user?.name ?? 'مستخدم';
        String userEmail = user?.email ?? 'email';

        return Drawer(
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                  ),
                  accountName: Text(
                    userName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  accountEmail: Text(
                    userEmail,
                    style: const TextStyle(),
                  ),
                  currentAccountPicture: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.blueGrey),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home_outlined),
                  title: const Text('لوحة التحكم', style: TextStyle()),
                  onTap: () {
                    Navigator.pop(context);
                    context.read<HomeBloc>().add(ChangeTabEvent(0));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.list_alt),
                  title: const Text('البلاغات', style: TextStyle()),
                  onTap: () {
                    Navigator.pop(context);
                    context.read<HomeBloc>().add(ChangeTabEvent(1));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.people_outline_sharp),
                  title: const Text('الفنيون', style: TextStyle()),
                  onTap: () {
                    Navigator.pop(context);
                    context.read<HomeBloc>().add(ChangeTabEvent(2));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.bar_chart_sharp),
                  title: const Text('التقارير', style: TextStyle()),
                  onTap: () {
                    Navigator.pop(context);
                    context.read<HomeBloc>().add(ChangeTabEvent(3));
                  },
                ),
                const Divider(height: 30),
                ListTile(
                  leading: const Icon(Icons.add_box_outlined),
                  title: const Text('إضافة بلاغ', style: TextStyle()),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  AddNewReportView()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.notifications_outlined),
                  title: const Text('الإشعارات', style: TextStyle()),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  NotificationsView(role: "supervisor")),
                    );
                    },
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('حول التطبيق', style: TextStyle()),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutPage()),
                    );
                  },
                ),
                const Spacer(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    'تسجيل الخروج',
                    style: TextStyle(color: Colors.red, ),
                  ),
                  onTap: () => _handleLogout(context),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}

