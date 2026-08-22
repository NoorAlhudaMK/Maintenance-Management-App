import 'package:anydrawer/anydrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/CacheManager/cache_manager.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../../Core/FormattedDateTime/get_arabic_date.dart';
import '../../../Data/Repositories/tickets_repository.dart';

import '../../AddReport/View/add_new_report_view.dart';
import '../../Auth/BLoC/auth_bloc.dart';
import '../../Auth/BLoC/auth_event.dart';
import '../../Drawer/View/drawer_view.dart';
import '../../MainPage/BLoC/home_bloc.dart';
import '../../MainPage/BLoC/home_event.dart';
import '../../ManagerIncomingReports/BLoC/incoming_reports_bloc.dart';
import '../../ManagerIncomingReports/BLoC/incoming_reports_event.dart';
import '../../ManagerIncomingReports/BLoC/incoming_reports_state.dart';
import '../../Notification/View/notification_view.dart';
import '../BLoC/manager_dashboard_bloc.dart';
import '../BLoC/manager_dashboard_event.dart';
import '../BLoC/manager_dashboard_state.dart';

class ManagerDashboardView extends StatelessWidget {
  final int teamId;
  const ManagerDashboardView({super.key, required this.teamId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ReportsBloc(repository: TicketsRepository())
            ..add(FetchTicketsEvent()),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          appBar: _buildAppBar(context),
          body: BlocBuilder<ManagerDashboardBloc, ManagerDashboardState>(
            builder: (context, state) {
              if (state is ManagerDashboardLoading ||
                  state is ManagerDashboardInitial) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ManagerDashboardLoaded) {
                final summary =
                    (state.summaryData['summary'] as Map?)?.map(
                      (k, v) => MapEntry(k.toString(), v),
                    ) ??
                    {};
                final topMembers =
                    state.summaryData['top_members'] as List? ?? [];

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<ManagerDashboardBloc>().add(
                      FetchManagerDashboardData(teamId: teamId),
                    );
                    context.read<ReportsBloc>().add(FetchTicketsEvent());
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        _buildHeader(),
                        const SizedBox(height: 25),
                        _buildStatsGrid(summary, topMembers.length),
                        const SizedBox(height: 35),
                        _buildLatestReportsHeader(context),
                        const SizedBox(height: 15),
                        // عرض البلاغات من ReportsBloc
                        _buildReportsList(),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLatestReportsHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "آخر البلاغات",
          style: TextStyle(
            color: AppColors.textMain,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            TextButton(
              onPressed: () => context.read<HomeBloc>().add(ChangeTabEvent(1)),
              child: const Text(
                "عرض الكل",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddNewReportView(),
                ),
              ),
              child: const Text("+ إضافة بلاغ"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReportsList() {
    return BlocBuilder<ReportsBloc, ReportsState>(
      builder: (context, state) {
        if (state is ReportsLoading)
          return const Center(child: CircularProgressIndicator());

        final filtered = state.reports
            .where(
              (r) =>
                  (r.status == "جديدة" || r.status == "قيد المراجعة") &&
                  (r.priorityName.contains("Emergency") ||
                      r.priorityName.contains("High")),
            )
            .take(5)
            .toList();

        if (filtered.isEmpty)
          return const Center(child: Text("لا توجد بلاغات جديدة"));

        return Column(
          children: filtered.map((report) {
            final colors = _getPriorityColors(report.priorityName);
            return _buildReportItem(
              id: report.id.toString(),
              status: report.status,
              location: report.unitName,
              description: report.description,
              icon: Icons.assignment_outlined,
              iconColor: colors['border']!,
              statusColor: colors['bg']!,
              statusTextColor: colors['text']!,
              borderColor: colors['border']!,
            );
          }).toList(),
        );
      },
    );
  }

  Map<String, Color> _getPriorityColors(String priority) {
    print("The priority : $priority");
    switch (priority.toLowerCase().trim()) {
      case 'emergency':
      case 'طارئ':
        return {
          'text': Colors.red,
          'bg': const Color(0xFFFFE5E5),
          'border': Colors.red,
        };
      case 'high':
      case 'عالي':
        return {
          'text': Colors.orange,
          'bg': Colors.orange.shade50,
          'border': Colors.orange,
        };
      case 'medium':
      case 'متوسط':
        return {
          'text': Colors.blue.shade700,
          'bg': Colors.blue.shade50,
          'border': Colors.blue,
        };
      case 'low':
      case 'منخفض':
        return {
          'text': Colors.grey.shade700,
          'bg': Colors.grey.shade100,
          'border': Colors.grey,
        };
      default:
        return {
          'text': Colors.blue,
          'bg': const Color(0xFFE3F2FD),
          'border': Colors.blue,
        };
    }
  }

  Widget _buildReportItem({
    required String id,
    required String status,
    required String location,
    required String description,
    required IconData icon,
    required Color iconColor,
    required Color statusColor,
    required Color statusTextColor,
    required Color borderColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border(right: BorderSide(color: borderColor, width: 5)),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: iconColor),
                  const SizedBox(width: 8),
                  Text(id, style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(location, style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 5),
          Text(description, textAlign: TextAlign.right),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'لــوحــة الــتــحــكــم',
        style: TextStyle(
          fontFamily: 'Cairo',
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 70,
      centerTitle: true,
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
      automaticallyImplyLeading: false,
      automaticallyImplyActions: false,
      actions: [
        // Padding(
        //   padding: const EdgeInsets.only(left: 20.0),
        //   child: GestureDetector(
        //     onTap: () => _showLogoutDialog(context),
        //     child: const CircleAvatar(
        //       radius: 22,
        //       backgroundColor: Colors.grey,
        //       backgroundImage: NetworkImage(
        //         "https://static.vecteezy.com/system/resources/thumbnails/051/767/450/small_2x/3d-cartoon-man-with-glasses-and-beard-illustration-free-png.png",
        //       ),
        //     ),
        //   ),
        // ),
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
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text("تنبيه"),
            content: const Text("هل تريد تسجيل الخروج من حساب المدير؟"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(
                  "إلغاء",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  context.read<AuthBloc>().add(LogoutRequested());
                  Navigator.pop(dialogContext);
                },
                child: const Text(
                  "خروج",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return FutureBuilder<String>(
      future: _getUserName(),
      builder: (context, snapshot) {
        return Row(
          children: [
            const Text("👋", style: TextStyle(fontSize: 24)),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "مرحباً، ${snapshot.data ?? '...'}",
                  style: TextStyle(
                    color: AppColors.textMain,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  getArabicFormattedDate(),
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatsGrid(Map<String, dynamic> summary, int techniciansCount) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 0.9,
      children: [
        _buildStatCard(
          icon: Icons.people_alt_outlined,
          color: AppColors.greenStatus,
          count: techniciansCount.toString(),
          title: "الفنيون المتاحون",
          bgColor: AppColors.greenBackground,
        ),
        _buildStatCard(
          icon: Icons.assignment_outlined,
          color: AppColors.blueStatus,
          count: (summary['open'] ?? 0).toString(),
          title: "البلاغات المفتوحة",
          bgColor: AppColors.blueBackground,
        ),
        _buildStatCard(
          icon: Icons.error_outline_outlined,
          color: AppColors.redStatus,
          count: (summary['sla_breached'] ?? 0).toString(),
          title: "بلاغات متجاوزة الوقت (SLA)",
          bgColor: AppColors.redBackground,
          hasTopBorder: true,
        ),
        _buildStatCard(
          icon: Icons.check_circle_outline,
          color: AppColors.orangeStatus,
          count: (summary['completed'] ?? 0).toString(),
          title: "مكتملة",
          bgColor: AppColors.orangeBackground,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color color,
    required String count,
    required String title,
    required Color bgColor,
    bool hasTopBorder = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: hasTopBorder
            ? Border(top: BorderSide(color: color, width: 4))
            : null,
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 15),
          Text(
            count,
            style: TextStyle(
              color: color,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Future<String> _getUserName() async {
    final user = await CacheManager.getUserModel();
    return user.name;
  }
}
