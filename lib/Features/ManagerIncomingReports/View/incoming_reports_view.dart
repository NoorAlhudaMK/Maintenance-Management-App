import 'package:anydrawer/anydrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintenance_management_app/Data/Models/category_model.dart';
import 'package:maintenance_management_app/Data/Models/ticket_model.dart';
import 'package:maintenance_management_app/Data/Repositories/tickets_repository.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../../Data/Models/maintenance_team_model.dart'; // <-- استيراد الموديل الجديد بدلاً من team_model.dart
import '../../Drawer/View/drawer_view.dart';
import '../../Notification/View/notification_view.dart';
import '../BLoC/incoming_reports_bloc.dart';
import '../BLoC/incoming_reports_event.dart';
import '../BLoC/incoming_reports_state.dart';
import 'assign_task_view.dart';

class IncomingReportsView extends StatelessWidget {
  const IncomingReportsView({super.key});

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
          appBar: _buildHeader(context),
          body: SafeArea(
            child: Column(
              children: [
                _buildSearchAndFilterSection(context),
                Expanded(child: _buildReportsList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildHeader(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      automaticallyImplyActions: false,
      centerTitle: true,
      title: Text(
        "الــبلاغــات الــواردة",
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

  Widget _buildSearchAndFilterSection(BuildContext context) {
    return BlocBuilder<ReportsBloc, ReportsState>(
      builder: (context, state) {
        bool hasActiveAdvancedFilters =
            state.selectedStatusId != null || state.selectedPriorityId != null;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        context.read<ReportsBloc>().add(
                          SearchTicketsEvent(value),
                        );
                      },
                      decoration: InputDecoration(
                        hintText: "ابحث عن بلاغ...",
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.date_range,
                            color:
                                (state.dateFrom != null || state.dateTo != null)
                                ? AppColors.primary
                                : Colors.grey,
                          ),
                          onPressed: () async {
                            final DateTimeRange? picked =
                                await showDateRangePicker(
                                  context: context,
                                  firstDate: DateTime(2023),
                                  lastDate: DateTime(2030),
                                  currentDate: DateTime.now(),
                                );

                            if (picked != null) {
                              final String dateFrom =
                                  "${picked.start.year}-${picked.start.month.toString().padLeft(2, '0')}-${picked.start.day.toString().padLeft(2, '0')}";
                              final String dateTo =
                                  "${picked.end.year}-${picked.end.month.toString().padLeft(2, '0')}-${picked.end.day.toString().padLeft(2, '0')}";

                              context.read<ReportsBloc>().add(
                                FilterByDateEvent(
                                  dateFrom: dateFrom,
                                  dateTo: dateTo,
                                ),
                              );
                            }
                          },
                          tooltip: "تصفية حسب التاريخ",
                        ),
                        filled: true,
                        fillColor: AppColors.cardBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: hasActiveAdvancedFilters
                          ? AppColors.primary
                          : AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.filter_list_alt,
                        color: hasActiveAdvancedFilters
                            ? Colors.white
                            : AppColors.textMain,
                      ),
                      onPressed: () {
                        if (state is ReportsLoaded) {
                          _showAdvancedFilterBottomSheet(context, state);
                        }
                      },
                      tooltip: "تصفية متقدمة (الحالة والأولوية)",
                    ),
                  ),
                ],
              ),
            ),
            if (state.dateFrom != null && state.dateTo != null) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      "الفترة: ${state.dateFrom} إلى ${state.dateTo}",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        context.read<ReportsBloc>().add(
                          FilterByDateEvent(dateFrom: null, dateTo: null),
                        );
                      },
                      child: const Text(
                        "إزالة الفلتر ✕",
                        style: TextStyle(fontSize: 12, color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 15),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _teamFilterChip(
                    context,
                    label: "الكل",
                    team: null,
                    selectedTeam: state.selectedTeam,
                  ),
                  ...state.teams.map(
                    (team) => _teamFilterChip(
                      context,
                      label: team.name,
                      team: team,
                      selectedTeam: state.selectedTeam,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 30),
          ],
        );
      },
    );
  }

  void _showAdvancedFilterBottomSheet(
    BuildContext mainContext,
    ReportsLoaded state,
  ) {
    showModalBottomSheet(
      context: mainContext,
      isScrollControlled: true,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: mainContext.read<ReportsBloc>(),
          child: const _AdvancedFilterContent(),
        );
      },
    );
  }

  Widget _filterChip(
    BuildContext context, {
    required String label,
    required CategoryModel? category,
    required CategoryModel? selectedCategory,
  }) {
    bool isSelected = category == null
        ? selectedCategory == null
        : selectedCategory?.id == category.id;

    return GestureDetector(
      onTap: () =>
          context.read<ReportsBloc>().add(FilterReportsEvent(category)),
      child: Container(
        margin: const EdgeInsets.only(left: 10),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildReportsList() {
    return BlocBuilder<ReportsBloc, ReportsState>(
      builder: (context, state) {
        if (state is ReportsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ReportsFailure) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("خطأ: ${state.error}", textAlign: TextAlign.center),
            ),
          );
        } else if (state.reports.isEmpty) {
          return const Center(child: Text("لا توجد بلاغات تطابق الفلتر"));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: state.reports.length,
          itemBuilder: (context, index) {
            final report = state.reports[index];
            final colors = _getPriorityColors(report.priorityName);

            return _buildReportItem(
              context: context,
              report: report,
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
          },
        );
      },
    );
  }

  Map<String, Color> _getPriorityColors(String priority) {
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
    required BuildContext context,
    required TicketModel report,
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
    final List<String> allowedStatuses = ["جديدة", "قيد المراجعة", "مرفوضة"];
    bool showAssignButton = allowedStatuses.contains(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border(right: BorderSide(color: borderColor, width: 5)),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: iconColor),
                  const SizedBox(width: 8),
                  Text(
                    "#$id",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textMain,
                    ),
                  ),
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
          Text(
            location,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 5),
          Text(
            description,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: AppColors.textMain.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          if (showAssignButton) ...[
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AssignTaskView(
                          reportId: report.id.toString(),
                          category: report.categoryName,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "تحويل",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // تم تحديث نوع البيانات هنا لـ MaintenanceTeamModel
  Widget _teamFilterChip(
    BuildContext context, {
    required String label,
    required MaintenanceTeamModel? team,
    required MaintenanceTeamModel? selectedTeam,
  }) {
    bool isSelected = team == null
        ? selectedTeam == null
        : selectedTeam?.id == team.id;

    return GestureDetector(
      onTap: () => context.read<ReportsBloc>().add(FilterByTeamEvent(team)),
      child: Container(
        margin: const EdgeInsets.only(left: 10),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _AdvancedFilterContent extends StatelessWidget {
  const _AdvancedFilterContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportsBloc, ReportsState>(
      builder: (context, state) {
        if (state is! ReportsLoaded) return const SizedBox.shrink();

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "تصفية متقدمة",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<ReportsBloc>().add(
                          ResetTempFiltersEvent(),
                        );
                      },
                      child: const Text(
                        "إعادة ضبط",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 10),
                const Text(
                  "حالة البلاغ:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: state.statuses.map((status) {
                    bool isSelected =
                        (state.tempSelectedStatusId ??
                            state.selectedStatusId) ==
                        status.id;
                    return ChoiceChip(
                      label: Text(status.name),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textMain,
                      ),
                      onSelected: (selected) {
                        context.read<ReportsBloc>().add(
                          UpdateTempStatusFilterEvent(
                            selected ? status.id : null,
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                const Text(
                  "الأولوية:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: state.priorities.map((priority) {
                    bool isSelected =
                        (state.tempSelectedPriorityId ??
                            state.selectedPriorityId) ==
                        priority.id;
                    return ChoiceChip(
                      label: Text(priority.name),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textMain,
                      ),
                      onSelected: (selected) {
                        context.read<ReportsBloc>().add(
                          UpdateTempPriorityFilterEvent(
                            selected ? priority.id : null,
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      context.read<ReportsBloc>().add(
                        ApplyAdvancedFiltersEvent(
                          statusId:
                              state.tempSelectedStatusId ??
                              state.selectedStatusId,
                          priorityId:
                              state.tempSelectedPriorityId ??
                              state.selectedPriorityId,
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "تطبيق الفلتر",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
