import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintenance_management_app/Features/Technician/BLoC/tech_event.dart';
import 'package:maintenance_management_app/Features/Technician/BLoC/tech_state.dart';
import '../../../Data/Models/TechnicianModel.dart';

class TechBloc extends Bloc<TechEvent, TechState> {
  // القائمة الأساسية للبيانات
  final List<TechnicianModel> _allData = [
    // --- الحالة: متاح (Available) ---
    TechnicianModel(
      id: "EMP-0042",
      name: "محمد العمري",
      specialty: "كهرباء",
      initials: "مح",
      rating: 4.9,
      activeTasks: 0,
      status: TechStatus.available,
      avatarColor: const Color(0xFFE3F2FD), // أزرق فاتح
      isAvailable: true,
      completedTasks: 28,
      onTimePercentage: "96%",
    ),
    TechnicianModel(
      id: "EMP-0044",
      name: "حسن الوائلي",
      specialty: "سباكة",
      initials: "حو",
      rating: 4.8,
      activeTasks: 0,
      status: TechStatus.available,
      avatarColor: const Color(0xFFE8F5E9), // أخضر فاتح
      isAvailable: true,
      completedTasks: 42,
      onTimePercentage: "98%",
    ),
    TechnicianModel(
      id: "EMP-0047",
      name: "مصطفى الجبوري",
      specialty: "تكييف",
      initials: "مج",
      rating: 4.6,
      activeTasks: 0,
      status: TechStatus.available,
      avatarColor: const Color(0xFFF3E5F5), // بنفسجي فاتح
      isAvailable: true,
      completedTasks: 31,
      onTimePercentage: "92%",
    ),

    // --- الحالة: مشغول (Busy) ---
    TechnicianModel(
      id: "EMP-0043",
      name: "أحمد السالم",
      specialty: "سباكة",
      initials: "أح",
      rating: 4.7,
      activeTasks: 3,
      status: TechStatus.busy,
      avatarColor: const Color(0xFFFFF3E0), // برتقالي فاتح
      isAvailable: false,
      completedTasks: 15,
      onTimePercentage: "88%",
    ),
    TechnicianModel(
      id: "EMP-0045",
      name: "عمر الفاروق",
      specialty: "كهرباء",
      initials: "عف",
      rating: 4.2,
      activeTasks: 2,
      status: TechStatus.busy,
      avatarColor: const Color(0xFFE1F5FE), // سماوي فاتح
      isAvailable: false,
      completedTasks: 20,
      onTimePercentage: "85%",
    ),

    // --- الحالة: غير متاح / إجازة (Not Available) ---
    TechnicianModel(
      id: "EMP-0046",
      name: "ليث القيسي",
      specialty: "تكييف",
      initials: "لق",
      rating: 4.5,
      activeTasks: 0,
      status: TechStatus.notAvailable,
      avatarColor: const Color(0xFFFFEBEE), // أحمر فاتح جداً
      isAvailable: false,
      completedTasks: 50,
      onTimePercentage: "94%",
    ),
    TechnicianModel(
      id: "EMP-0048",
      name: "ياسر المحمد",
      specialty: "مصاعد",
      initials: "يم",
      rating: 4.9,
      activeTasks: 0,
      status: TechStatus.notAvailable,
      avatarColor: const Color(0xFFF5F5F5), // رمادي فاتح
      isAvailable: false,
      completedTasks: 12,
      onTimePercentage: "100%",
    ),
  ];

  TechBloc() : super(TechState(technicians: [], selectedStatus: TechStatus.all)) {

    // عند التشغيل، نعرض البيانات فوراً
    on<FilterTechEvent>((event, emit) {
      if (event.status == TechStatus.all) {
        emit(state.copyWith(technicians: _allData, selectedStatus: event.status));
      } else {
        final filtered = _allData.where((t) => t.status == event.status).toList();
        emit(state.copyWith(technicians: filtered, selectedStatus: event.status));
      }
    });

    on<SelectTechForAssignmentEvent>((event, emit) {
      emit(state.copyWith(selectedTechId: event.techId));
    });

    on<LoadTechProfileEvent>((event, emit) {
      // نستخدم _allData هنا أيضاً
      final tech = _allData.firstWhere((t) => t.id == event.techId);
      emit(state.copyWith(selectedTechnician: tech));
    });

    // استدعاء الفلتر الأولي لجلب البيانات عند أول تشغيل
    add(FilterTechEvent(TechStatus.all));
  }
}