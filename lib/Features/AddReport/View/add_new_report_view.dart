import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../../Data/Models/category_model.dart';
import '../../../Data/Models/priority_model.dart';
import '../../../Data/Repositories/tickets_repository.dart';
import '../BLoC/add_new_report_bloc.dart';

class AddNewReportView extends StatelessWidget {
  const AddNewReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddNewReportBloc(
        ticketsRepository: TicketsRepository(),
      )..add(LoadReportDataEvent()),
      child: const _AddNewReportViewBody(),
    );
  }
}

class _AddNewReportViewBody extends StatelessWidget {
  const _AddNewReportViewBody();

  @override
  Widget build(BuildContext context) {
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController apartmentController = TextEditingController();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "إضافة بلاغ جديد",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocConsumer<AddNewReportBloc, AddNewReportState>(
          listener: (context, state) {
            if (state.successMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.successMessage!),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            } else if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("تفاصيل الموقع"),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: apartmentController,
                    label: "رقم الشقة / الطابق",
                    hint: "مثال: شقة 12 - الطابق 2",
                    icon: Icons.location_on_outlined,
                  ),
                  const SizedBox(height: 25),
                  _buildSectionTitle("تفاصيل البلاغ"),
                  const SizedBox(height: 15),
                  // حقل الفئة الجديد
                  _buildDropdownFieldForCategories(
                    label: "فئة البلاغ",
                    selectedCategory: state.selectedCategory,
                    categories: state.categories,
                    onChanged: (category) {
                      context.read<AddNewReportBloc>().add(SelectCategoryEvent(category));
                    },
                    icon: Icons.category_outlined,
                  ),
                  const SizedBox(height: 15),
                  _buildDropdownFieldForPriorities(
                    label: "درجة الأهمية",
                    selectedPriority: state.selectedPriority,
                    priorities: state.priorities,
                    onChanged: (priority) {
                      context.read<AddNewReportBloc>().add(SelectPriorityEvent(priority));
                    },
                    icon: Icons.priority_high,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: descriptionController,
                    label: "وصف المشكلة",
                    hint: "اكتب تفاصيل العطل هنا...",
                    icon: Icons.description_outlined,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 25),
                  _buildSectionTitle("صورة العطل (اختياري)"),
                  const SizedBox(height: 15),
                  _buildImageUploadSection(context, state),
                  const SizedBox(height: 40),
                  _buildSubmitButton(context, state, descriptionController),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
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
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: const Text("اختر من القائمة"),
              icon: Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownFieldForCategories({
    required String label,
    required CategoryModel? selectedCategory,
    required List<CategoryModel> categories,
    required Function(CategoryModel?) onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<CategoryModel>(
              value: selectedCategory,
              isExpanded: true,
              hint: const Text("اختر الفئة"),
              icon: Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
              items: categories.map((CategoryModel category) {
                return DropdownMenuItem<CategoryModel>(
                  value: category,
                  child: Text(category.name),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownFieldForPriorities({
    required String label,
    required PriorityModel? selectedPriority,
    required List<PriorityModel> priorities,
    required Function(PriorityModel?) onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<PriorityModel>(
              value: selectedPriority,
              isExpanded: true,
              hint: const Text("اختر درجة الأهمية"),
              icon: Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
              items: priorities.map((PriorityModel priority) {
                return DropdownMenuItem<PriorityModel>(
                  value: priority,
                  child: Text(priority.name),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageUploadSection(BuildContext context, AddNewReportState state) {
    return Row(
      children: [
        Expanded(
          child: _buildDashedUploadBox(
            label: "صورة المشكلة",
            imageFile: state.reportImage,
            onTap: () async {
              final XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
              if (pickedFile != null) {
                if (context.mounted) {
                  context.read<AddNewReportBloc>().add(PickReportImageEvent(File(pickedFile.path)));
                }
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDashedUploadBox({
    required String label,
    required File? imageFile,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
        ),
        child: imageFile != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.file(imageFile, fit: BoxFit.cover, width: double.infinity),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_outlined, color: AppColors.primary, size: 30),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, AddNewReportState state, TextEditingController descriptionController) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 2,
        ),
        onPressed: state.isSubmitting
            ? null
            : () async {
          if (state.selectedCategory == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("الرجاء اختيار الفئة"), backgroundColor: Colors.red),
            );
            return;
          }
          if (state.selectedPriority == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("الرجاء اختيار درجة الأهمية"), backgroundColor: Colors.red),
            );
            return;
          }

          List<Map<String, dynamic>>? imagesList;
          if (state.reportImage != null) {
            final bytes = await state.reportImage!.readAsBytes();
            final base64Image = base64Encode(bytes);
            imagesList = [
              {
                "image": base64Image,
                "filename": "ac-before.jpg",
                "mimetype": "image/jpeg",
                "image_type": "before",
                "note": "Indoor unit display"
              }
            ];
          }

          if (context.mounted) {
            context.read<AddNewReportBloc>().add(
              SubmitReportEvent(
                title: descriptionController.text.isNotEmpty
                    ? descriptionController.text.substring(0, descriptionController.text.length > 25 ? 25 : descriptionController.text.length)
                    : "Air conditioner not cooling",
                description: descriptionController.text,
                categoryId: state.selectedCategory!.id,
                unitId: 1,
                priority: state.selectedPriority!.code,
                teamId: 1,
                expectedDate: "2026-07-26T10:00:00+03:00",
                images: imagesList,
              ),
            );
          }
        },
        child: state.isSubmitting
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
          "حفظ وإرسال البلاغ",
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