import 'package:anydrawer/anydrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintenance_management_app/Core/FormattedDateTime/get_arabic_date.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../Auth/BLoC/auth_bloc.dart';
import '../../Auth/BLoC/auth_state.dart';
import '../../Drawer/View/drawer_view.dart';
import '../../TechnicianTaskDetails/View/task_details_view.dart';
import '../BLoC/technician_tasks_bloc.dart';
import '../BLoC/technician_tasks_event.dart';
import '../BLoC/technician_tasks_state.dart';

class TechnicianTasksView extends StatefulWidget {
  const TechnicianTasksView({super.key});

  @override
  State<TechnicianTasksView> createState() => _TechnicianTasksViewState();
}

class _TechnicianTasksViewState extends State<TechnicianTasksView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<TechnicianTasksBloc>().add(const LoadTechnicianTasks());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: AppBar(
          title: const Text(
            'قــائــمــة الــمــهــام',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            onPressed: () async {
              showDrawer(
                context,
                builder: (context) {
                  return AppDrawer(
                    role: "technician",
                  );
                },
              );
            },
            icon: Icon(
                Icons.menu_outlined
            ),
          ),
          automaticallyImplyLeading: false,
          automaticallyImplyActions: false,
        ),
        body: Column(
          children: [
            _buildHeader(context),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "بحث عن تذكرة...",
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            context.read<TechnicianTasksBloc>().add(
                              const LoadTechnicianTasks(search: ''),
                            );
                          },
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                      onChanged: (val) {
                        context.read<TechnicianTasksBloc>().add(
                          LoadTechnicianTasks(
                            search: val,
                            dateFrom: context.read<TechnicianTasksBloc>().state.dateFrom,
                            dateTo: context.read<TechnicianTasksBloc>().state.dateTo,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  BlocBuilder<TechnicianTasksBloc, TechnicianTasksState>(
                    builder: (context, state) {
                      final hasDateFilter = state.dateFrom != null;
                      return Container(
                        decoration: BoxDecoration(
                          color: hasDateFilter ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.calendar_today,
                            color: hasDateFilter ? Colors.white : AppColors.primary,
                          ),
                          onPressed: () async {
                            DateTimeRange? pickedRange = await showDateRangePicker(
                              context: context,
                              firstDate: DateTime(2025, 1, 1),
                              lastDate: DateTime(2030, 12, 31),
                              locale: const Locale('ar', 'IQ'),
                              builder: (context, child) {
                                return Dialog(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width * .6,
                                    height:  MediaQuery.of(context).size.height * .7,
                                    child: child,
                                  ),
                                );
                              },
                            );

                            if (pickedRange != null) {
                              String dateFrom = pickedRange.start.toIso8601String().split('T')[0];
                              String dateTo = pickedRange.end.toIso8601String().split('T')[0];

                              if (context.mounted) {
                                context.read<TechnicianTasksBloc>().add(
                                  LoadTechnicianTasks(
                                    search: _searchController.text,
                                    dateFrom: dateFrom,
                                    dateTo: dateTo,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            Expanded(
              child: BlocBuilder<TechnicianTasksBloc, TechnicianTasksState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.tasks.isEmpty) {
                    return Center(
                      child: Text(
                        "لا توجد تذاكر مطابقة للبحث",
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: state.tasks.length,
                    itemBuilder: (context, index) {
                      final task = state.tasks[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskDetailsView(taskId: task.id.toString()),
                            ),
                          );
                        },
                        child: _buildTaskCard(
                          title: task.title,
                          location: task.unitName,
                          time: task.createdDate,
                          status: task.status,
                          statusColor: task.priorityName == "High" ? Colors.red : Colors.orange,
                          hasEmergencyEdge: task.priorityName == "High",
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 30),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      String technicianName = "فني";
                      if (state is AuthSuccess) {
                        technicianName = state.userName;
                      }

                      return Text(
                        "مرحباً، $technicianName 👋",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  Text(
                    getArabicFormattedDate(),
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
              // GestureDetector(
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => const NotificationsView(),
              //       ),
              //     );
              //   },
              //   child: _notificationIcon(),
              // ),
            ],
          ),
          const SizedBox(height: 25),
          BlocBuilder<TechnicianTasksBloc, TechnicianTasksState>(
            builder: (context, state) {
              int totalTasks = state.tasks.length;
              int emergencyTasks = state.tasks.where((t) => t.priorityName == "High").length;
              return Row(
                children: [
                  _headerStatBox(
                    totalTasks.toString(),
                    "إجمالي المهام",
                    Colors.white.withOpacity(0.2),
                  ),
                  const SizedBox(width: 15),
                  _headerStatBox(
                    emergencyTasks.toString(),
                    "مهام طارئة",
                    Colors.red.withOpacity(0.3),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _headerStatBox(String value, String label, Color bgColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard({
    required String title,
    required String location,
    required String time,
    required String status,
    required Color statusColor,
    bool hasEmergencyEdge = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          if (hasEmergencyEdge)
            Positioned(
              left: 0,
              top: 20,
              bottom: 20,
              child: Container(
                width: 5,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _statusBadge(status, statusColor),
                    Row(
                      children: [
                        Text(
                          time,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.textMain,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  location,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _notificationIcon() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.notifications_none, color: Colors.white),
        ),
        Positioned(
          right: 5,
          top: 5,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}