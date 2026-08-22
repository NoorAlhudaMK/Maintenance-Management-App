import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../../Data/Repositories/repair_documentation_repository.dart';
import '../BLoC/repair_documentation_bloc.dart';
import '../BLoC/repair_documentation_event.dart';
import '../BLoC/repair_documentation_state.dart';

class RepairDocumentationView extends StatelessWidget {
  final String taskId;

  const RepairDocumentationView({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RepairDocumentationBloc(
        repository: RepairDocumentationRepository(),
        id: taskId,
      )..add(FetchStatusesEvent()),
      child: BlocListener<RepairDocumentationBloc, RepairDocumentationState>(
        listener: (context, state) {
          if (state.status == SubmissionStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("تمت العملية بنجاح"),
              backgroundColor: Colors.green,
            ));
          } else if (state.status == SubmissionStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.errorMessage ?? "حدث خطأ ما"),
              backgroundColor: Colors.red,
            ));
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          appBar: AppBar(
            title: const Text("توثيق الإصلاح"),
            centerTitle: true,
            backgroundColor: AppColors.primary,
          ),
          body: BlocBuilder<RepairDocumentationBloc, RepairDocumentationState>(
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildImageUploadSection(context, state),
                    const SizedBox(height: 25),
                    _buildStatusDropdown(context, state),
                    const SizedBox(height: 25),
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
    );
  }

  Widget _buildImageUploadSection(BuildContext context, RepairDocumentationState state) {
    return Row(
      children: [
        Expanded(
          child: _buildDashedUploadBox(
            label: "قبل الإصلاح",
            imageFile: state.beforeImage,
            onTap: () => _pickAndUpload(context, ImageSource.camera, "before"),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildDashedUploadBox(
            label: "بعد الإصلاح",
            imageFile: state.afterImage,
            onTap: () => _pickAndUpload(context, ImageSource.camera, "after"),
          ),
        ),
      ],
    );
  }

  Future<void> _pickAndUpload(BuildContext context, ImageSource source, String type) async {
    final XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      // إرسال طلب الرفع المباشر
      context.read<RepairDocumentationBloc>().add(UploadImageEvent(
        imageFile: File(pickedFile.path),
        imageType: type,
        note: "صورة $type الإصلاح",
      ));
    }
  }

  Widget _buildDashedUploadBox({required String label, File? imageFile, required VoidCallback onTap}) {
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
            ? ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.file(imageFile, fit: BoxFit.cover))
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.camera_alt, color: Colors.grey),
            Text(label),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusDropdown(BuildContext context, RepairDocumentationState state) {
    if (state.statusesList.isEmpty) return const CircularProgressIndicator();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: state.statusesList.any((s) => s.code == state.selectedStatus)
              ? state.selectedStatus
              : state.statusesList.first.code,
          isExpanded: true,
          items: state.statusesList.map((status) => DropdownMenuItem(
            value: status.code,
            child: Text(status.name),
          )).toList(),
          onChanged: (newCode) => context.read<RepairDocumentationBloc>().add(UpdateStatusEvent(newCode!)),
        ),
      ),
    );
  }

  Widget _buildNotesField(BuildContext context) {
    return TextField(
      maxLines: 3,
      onChanged: (val) => context.read<RepairDocumentationBloc>().add(UpdateNotesEvent(val)),
      decoration: const InputDecoration(hintText: "ملاحظات الفني", filled: true, fillColor: Colors.white),
    );
  }

  Widget _buildSubmitButton(BuildContext context, RepairDocumentationState state) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: state.status == SubmissionStatus.loading
            ? null
            : () => context.read<RepairDocumentationBloc>().add(SubmitRepairReport(taskId)),
        child: const Text("إرسال التقرير النهائي"),
      ),
    );
  }
}