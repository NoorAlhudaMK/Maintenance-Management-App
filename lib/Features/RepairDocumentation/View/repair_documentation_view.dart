import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Core/Colors/app_colors.dart';
import '../BLoC/repair_documentation_bloc.dart';
import '../BLoC/repair_documentation_event.dart';
import '../BLoC/repair_documentation_state.dart';

class RepairDocumentationView extends StatelessWidget {
  final String taskId;

  const RepairDocumentationView({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RepairDocumentationBloc(),
      child: BlocListener<RepairDocumentationBloc, RepairDocumentationState>(
        listener: (context, state) {
          if (state.status == SubmissionStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("تم إرسال التقرير بنجاح"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state.status == SubmissionStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? "حدث خطأ ما"),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: AppColors.scaffoldBackground,
              appBar: AppBar(
                backgroundColor: AppColors.primary,
                elevation: 0,
                centerTitle: true,
                title: const Text(
                  "توثيق الإصلاح",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body:
                  BlocBuilder<
                    RepairDocumentationBloc,
                    RepairDocumentationState
                  >(
                    builder: (context, state) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTaskInfoCard(),
                            const SizedBox(height: 25),
                            _buildSectionTitle(
                              Icons.camera_alt_outlined,
                              "صور الإصلاح",
                            ),
                            const SizedBox(height: 15),
                            _buildImageUploadSection(context, state),
                            const SizedBox(height: 20),
                            _buildLargeImagePreview(state),
                            const SizedBox(height: 25),
                            _buildSectionTitle(Icons.fact_check_outlined, "حالة العطل"),
                            const SizedBox(height: 15),
                            _buildStatusDropdown(context, state), // الودجت الجديدة
                            const SizedBox(height: 25),
                            _buildSectionTitle(
                              Icons.note_alt_outlined,
                              "ملاحظات الفني",
                            ),
                            const SizedBox(height: 15),
                            _buildNotesField(context),
                            const SizedBox(height: 30),
                            _buildSubmitButton(context, state),
                          ],
                        ),
                      );
                    },
                  ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Widgets ---

  Widget _buildTaskInfoCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "شقة 3B - بناية A",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
              ],
            ),
            child: Text(
              taskId,
              style: const TextStyle(
                color: Color(0xFF1A4D7E),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A4D7E),
          ),
        ),
        const SizedBox(width: 8),
        Icon(icon, color: const Color(0xFF1A4D7E), size: 22),
      ],
    );
  }

  Widget _buildImageUploadSection(
    BuildContext context,
    RepairDocumentationState state,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildDashedUploadBox(
            label: "صورة قبل الإصلاح",
            imageFile: state.beforeImage,
            onTap: () => context.read<RepairDocumentationBloc>().add(
              const PickImageEvent(
                isBeforeImage: true,
                source: ImageSource.camera,
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildDashedUploadBox(
            label: "صورة بعد الإصلاح",
            imageFile: state.afterImage,
            onTap: () => context.read<RepairDocumentationBloc>().add(
              const PickImageEvent(
                isBeforeImage: false,
                source: ImageSource.camera,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDashedUploadBox({
    required String label,
    File? imageFile,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: imageFile != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.file(imageFile, fit: BoxFit.cover),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_enhance_outlined,
                    color: Colors.grey.shade400,
                    size: 30,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildLargeImagePreview(RepairDocumentationState state) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: state.beforeImage != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(state.beforeImage!, fit: BoxFit.cover),
            )
          : const Center(
              child: Text(
                "معاينة الصورة (قبل الإصلاح)",
                style: TextStyle(color: Colors.grey),
              ),
            ),
    );
  }

  Widget _buildStatusDropdown(BuildContext context, RepairDocumentationState state) {
    final List<String> statusOptions = [
      "تم حل المشكلة",
      "بحاجة لزيارة أخرى",
      "بانتظار قطع غيار",
      "تم الرفض من قبل الساكن",
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: state.selectedStatus,
          isExpanded: true,
          items: statusOptions.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              context.read<RepairDocumentationBloc>().add(UpdateStatusEvent(newValue));
            }
          },
        ),
      ),
    );
  }

  Widget _buildNotesField(BuildContext context) {
    return TextField(
      maxLines: 4,
      onChanged: (value) =>
          context.read<RepairDocumentationBloc>().add(UpdateNotesEvent(value)),
      decoration: InputDecoration(
        hintText: "أضف ملاحظاتك هنا...",
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade100),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(
    BuildContext context,
    RepairDocumentationState state,
  ) {
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
        onPressed: state.status == SubmissionStatus.loading
            ? null
            : () => context.read<RepairDocumentationBloc>().add(
                SubmitRepairReport(taskId),
              ),
        child: state.status == SubmissionStatus.loading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                "إرسال التقرير",
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
