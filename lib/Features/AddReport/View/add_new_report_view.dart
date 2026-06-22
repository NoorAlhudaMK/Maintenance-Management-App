import 'package:flutter/material.dart';
import '../../../Core/Colors/app_colors.dart';

class AddNewReportView extends StatefulWidget {
  const AddNewReportView({super.key});

  @override
  State<AddNewReportView> createState() => _AddNewReportViewState();
}

class _AddNewReportViewState extends State<AddNewReportView> {
  // المعرفات للتحكم في الحقول
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _apartmentController = TextEditingController();

  String? _selectedBuilding;
  String? _selectedPriority;

  final List<String> _buildings = ['عمارة 1', 'عمارة 2', 'عمارة 3', 'عمارة 4'];
  final List<String> _priorities = ['عادي', 'متوسط', 'طارئ'];

  @override
  Widget build(BuildContext context) {
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
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("تفاصيل الموقع"),
              const SizedBox(height: 15),
              _buildDropdownField(
                label: "اختر العمارة",
                value: _selectedBuilding,
                items: _buildings,
                onChanged: (val) => setState(() => _selectedBuilding = val),
                icon: Icons.apartment,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _apartmentController,
                label: "رقم الشقة / الطابق",
                hint: "مثال: شقة 12 - الطابق 2",
                icon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 25),
              _buildSectionTitle("تفاصيل البلاغ"),
              const SizedBox(height: 15),
              _buildDropdownField(
                label: "درجة الأهمية",
                value: _selectedPriority,
                items: _priorities,
                onChanged: (val) => setState(() => _selectedPriority = val),
                icon: Icons.priority_high,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _descriptionController,
                label: "وصف المشكلة",
                hint: "اكتب تفاصيل العطل هنا...",
                icon: Icons.description_outlined,
                maxLines: 4,
              ),
              const SizedBox(height: 40),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widgets المساعدة ---

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

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 2,
        ),
        onPressed: () {
          // هنا يتم الربط مع الـ Bloc لإرسال البيانات
          _handleStatus();
        },
        child: const Text(
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

  void _handleStatus() {
    // محاكاة نجاح الإرسال
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("تم إضافة البلاغ بنجاح"),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }
}