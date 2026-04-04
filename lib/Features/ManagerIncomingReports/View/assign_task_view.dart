import 'package:flutter/material.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../../Data/Models/TechnicianModel.dart';

class AssignTaskView extends StatefulWidget {
  final String reportId;
  final String category;

  const AssignTaskView({
    super.key,
    required this.reportId,
    required this.category,
  });

  @override
  State<AssignTaskView> createState() => _AssignTaskViewState();
}

class _AssignTaskViewState extends State<AssignTaskView> {
  final Set<String> _selectedTechNames = {};

  final List<TechnicianModel> allTechnicians = [
    // --- قسم الكهرباء (الموجود سابقاً) ---
    TechnicianModel(name: "محمد العمري", specialty: "كهرباء", activeTasks: 0, isAvailable: true, id: '1', initials: 'مع', rating: 4.5, status: TechStatus.available, avatarColor: Colors.blue),
    TechnicianModel(name: "أحمد النجار", specialty: "كهرباء", activeTasks: 1, isAvailable: true, id: '2', initials: 'أن', rating: 4.0, status: TechStatus.available, avatarColor: Colors.green),
    TechnicianModel(name: "خالد سعيد", specialty: "كهرباء", activeTasks: 3, isAvailable: false, id: '3', initials: 'خس', rating: 3.5, status: TechStatus.busy, avatarColor: Colors.orange),
    TechnicianModel(name: "سعد الفهد", specialty: "كهرباء", activeTasks: 2, isAvailable: true, id: '4', initials: 'سف', rating: 4.8, status: TechStatus.available, avatarColor: Colors.purple),

    // --- قسم السباكة (جديد) ---
    TechnicianModel(name: "حسن الوائلي", specialty: "سباكة", activeTasks: 0, isAvailable: true, id: '5', initials: 'حو', rating: 4.7, status: TechStatus.available, avatarColor: Colors.teal),
    TechnicianModel(name: "عمر الفاروق", specialty: "سباكة", activeTasks: 2, isAvailable: true, id: '6', initials: 'عف', rating: 4.2, status: TechStatus.available, avatarColor: Colors.cyan),
    TechnicianModel(name: "ليث القيسي", specialty: "سباكة", activeTasks: 4, isAvailable: false, id: '7', initials: 'لق', rating: 3.9, status: TechStatus.busy, avatarColor: Colors.brown),

    // --- قسم التكييف (جديد) ---
    TechnicianModel(name: "مصطفى الجبوري", specialty: "تكييف", activeTasks: 1, isAvailable: true, id: '8', initials: 'مج', rating: 4.9, status: TechStatus.available, avatarColor: Colors.indigo),
    TechnicianModel(name: "ياسر المحمد", specialty: "تكييف", activeTasks: 0, isAvailable: true, id: '9', initials: 'يم', rating: 4.6, status: TechStatus.available, avatarColor: Colors.deepPurple),
    TechnicianModel(name: "بلال الراوي", specialty: "تكييف", activeTasks: 5, isAvailable: false, id: '10', initials: 'بر', rating: 3.8, status: TechStatus.busy, avatarColor: Colors.blueGrey),
  ];

  @override
  Widget build(BuildContext context) {
    // تصفية الفنيين حسب التخصص
    final filteredTechnicians = allTechnicians
        .where((tech) => tech.specialty == widget.category)
        .toList();

    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text("توزيع المهمة يدوياً", style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold)),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: AppColors.textMain),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildReportSummary(),
              _buildSelectionHeader(filteredTechnicians),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: filteredTechnicians.length,
                  itemBuilder: (context, index) {
                    final tech = filteredTechnicians[index];
                    final isSelected = _selectedTechNames.contains(tech.name);
                    return _buildTechCard(tech, isSelected);
                  },
                ),
              ),
              _buildConfirmButton(),
            ],
          ),
        ),
      ),
    );
  }

  // هيدر يحتوي على عنوان القسم وزر "اختيار الكل"
  Widget _buildSelectionHeader(List<TechnicianModel> techs) {
    final isAllSelected = _selectedTechNames.length == techs.length && techs.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "اختر الفني المناسب:",
            style: TextStyle(color: AppColors.textMain, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                if (isAllSelected) {
                  _selectedTechNames.clear();
                } else {
                  _selectedTechNames.addAll(techs.map((t) => t.name));
                }
              });
            },
            child: Text(
              isAllSelected ? "إلغاء الكل" : "اختيار الكل",
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportSummary() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("البلاغ #${widget.reportId}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                _badge(widget.category, Colors.white.withOpacity(0.2)),
              ],
            ),
          ),
          const ListTile(
            leading: Icon(Icons.location_on, color: Colors.redAccent),
            title: Text("شقة 3B - بناية A", style: TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }

  Widget _buildTechCard(TechnicianModel tech, bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppColors.primary : Colors.transparent,
          width: 2,
        ),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 10)],
      ),
      child: ListTile(
        onTap: () {
          setState(() {
            if (isSelected) {
              _selectedTechNames.remove(tech.name);
            } else {
              _selectedTechNames.add(tech.name);
            }
          });
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: AppColors.primary,
              child: Text(tech.initials.isEmpty ? tech.name.substring(0,1) : tech.initials, style: const TextStyle(color: Colors.white)),
            ),
            if (isSelected)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                  child: const Icon(Icons.check, color: Colors.white, size: 14),
                ),
              ),
          ],
        ),
        title: Text(tech.name, style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold)),
        subtitle: Text("${tech.specialty} • ${tech.activeTasks} مهام نشطة", style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        trailing: _statusIndicator(tech.isAvailable),
      ),
    );
  }

  Widget _statusIndicator(bool available) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: available ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        available ? "متاح" : "مشغول",
        style: TextStyle(color: available ? Colors.green : Colors.grey, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Widget _buildConfirmButton() {
    final bool hasSelection = _selectedTechNames.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: hasSelection ? () {
          // هنا يتم استدعاء الـ BLoC لإرسال القائمة المختارة
          print("تم تحويل البلاغ إلى: $_selectedTechNames");
        } : null, // الزر يكون معطلاً إذا لم يتم اختيار أي شخص
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primary.withOpacity(0.3),
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Text(
          hasSelection ? "تأكيد إسناد (${_selectedTechNames.length})" : "يرجى اختيار فني",
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
    );
  }
}