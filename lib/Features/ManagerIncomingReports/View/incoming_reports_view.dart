import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintenance_management_app/Data/Repositories/tickets_repository.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../../Data/Models/ReportModel.dart';
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
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                _buildSearchAndFilterSection(),
                Expanded(child: _buildReportsList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(children: []),
          ),
          Text(
            "البلاغات الواردة",
            style: TextStyle(
              color: AppColors.textMain,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.success,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Text(
                  "تلقائي",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                SizedBox(width: 5),
                Icon(Icons.auto_awesome, color: Colors.white, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterSection() {
    return BlocBuilder<ReportsBloc, ReportsState>(
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "ابحث عن بلاغ...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: AppColors.cardBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _filterChip(
                    context,
                    "الكل",
                    ReportCategory.all,
                    state.selectedCategory,
                  ),
                  _filterChip(
                    context,
                    "سباكة",
                    ReportCategory.plumbing,
                    state.selectedCategory,
                  ),
                  _filterChip(
                    context,
                    "كهرباء",
                    ReportCategory.electric,
                    state.selectedCategory,
                  ),
                  _filterChip(
                    context,
                    "تكييف",
                    ReportCategory.ac,
                    state.selectedCategory,
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

  Widget _filterChip(
    BuildContext context,
    String label,
    ReportCategory cat,
    ReportCategory selected,
  ) {
    bool isSelected = cat == selected;
    return GestureDetector(
      onTap: () => context.read<ReportsBloc>().add(FilterReportsEvent(cat)),
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
          return const Center(child: Text("لا توجد بلاغات"));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: state.reports.length,
          itemBuilder: (context, index) =>
              _reportCard(state.reports[index], context),
        );
      },
    );
  }

  Widget _reportCard(ReportModel report, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: report.isUrgent
            ? Border(right: BorderSide(color: AppColors.urgentRed, width: 5))
            : null,
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 10)],
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(report.icon, color: report.iconColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    report.id,
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
                  color: report.isUrgent
                      ? AppColors.urgentRedBg
                      : AppColors.newBlueBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  report.status,
                  style: TextStyle(
                    color: report.isUrgent
                        ? AppColors.urgentRed
                        : AppColors.newBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            report.location,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 5),
          Text(
            report.description,
            style: TextStyle(
              color: AppColors.textMain.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
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
                        reportId: report.id,
                        category: report.category.name == "electric"
                            ? "كهرباء"
                            : report.category.name == "plumbing"
                            ? "سباكة"
                            : "تكييف",
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
      ),
    );
  }
}
