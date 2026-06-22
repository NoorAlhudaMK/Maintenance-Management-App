import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../RepairDocumentation/View/repair_documentation_view.dart';
import '../BLoC/task_details_bloc.dart';
import '../BLoC/task_details_event.dart';
import '../BLoC/task_details_state.dart';

class TaskDetailsView extends StatelessWidget {
  final String taskId;
  const TaskDetailsView({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskDetailsBloc()..add(LoadTaskDetails(taskId)),
      child: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: AppColors.scaffoldBackground,
            appBar: _buildAppBar(context),
            body: BlocBuilder<TaskDetailsBloc, TaskDetailsState>(
              builder: (context, state) {
                if (state.isLoading)
                  return const Center(child: CircularProgressIndicator());
                final data = state.taskData;
                if (data == null)
                  return const Center(child: Text("لا توجد بيانات"));

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(data),
                      const SizedBox(height: 20),
                      _buildInfoCard(data),
                      const SizedBox(height: 25),
                      _buildSectionTitle(
                        Icons.description_outlined,
                        "وصف المشكلة",
                      ),
                      _buildDescriptionBox(data['description']),
                      const SizedBox(height: 25),
                      _buildSectionTitle(Icons.image_outlined, "الصور المرفقة"),
                      _buildImageGrid(data),
                      const SizedBox(height: 25),
                      _buildActionButton(context, state),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        "مهامي",
        style: TextStyle(
          color: AppColors.textMain,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: AppColors.textMain, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text(
              "قيد التنفيذ",
              style: TextStyle(
                color: Colors.orange,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(Map data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _priorityBadge(data['priority']),
            const Spacer(),
            Text(
              "رقم البلاغ ${data['reportId']}",
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          data['title'],
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _priorityBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const CircleAvatar(backgroundColor: Colors.red, radius: 4),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(Map data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          _infoRow(Icons.location_on_outlined, "الموقع", data['location']),
          const Divider(height: 30),
          _infoRow(
            Icons.person_outline,
            "اسم الساكن",
            data['residentName'],
            trailing: _contactButton(),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 40, top: 5),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "0555-XXX-XXX",
                style: TextStyle(color: Colors.blueGrey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(
    IconData icon,
    String title,
    String value, {
    Widget? trailing,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
              Text(
                value,
                style: TextStyle(
                  color: AppColors.textMain,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _contactButton() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.phone_outlined, color: Colors.green, size: 20),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textMain, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: AppColors.textMain,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionBox(String desc) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Text(
        desc,
        style: TextStyle(
          color: AppColors.textSecondary,
          height: 1.6,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildImageGrid(Map data) {
    final List<Widget> items = [
      _buildImage(data["image1"]),
      _buildImage(data["image2"]),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemCount: 2,
      itemBuilder: (context, index) => ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: items[index],
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(imageUrl, fit: BoxFit.cover),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(5),
            color: Colors.black38,
            child: const Text(
              "صورة من الساكن",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, state) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RepairDocumentationView(
                taskId: state.taskData['reportId'] ?? "#000",
              ),
            ),
          );
        },
        child: const Text(
            "توثيق الإصلاح",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
