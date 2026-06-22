import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Data/Models/ReportModel.dart';
import 'incoming_reports_event.dart';
import 'incoming_reports_state.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  // بيانات تجريبية (Mock Data)
  final List<ReportModel> allData = [
    ReportModel(
      id: "REQ-2051",
      status: "طارئ",
      location: "عمارة 4 • شقة 12",
      description: "تسريب مياه من سقف الحمام الرئيسي.",
      icon: Icons.opacity,
      iconColor: Colors.blue,
      category: ReportCategory.plumbing,
      isUrgent: true,
    ),
    ReportModel(
      id: "REQ-2050",
      status: "جديد",
      location: "عمارة 1 • شقة 40",
      description: "انقطاع متكرر للتيار الكهربائي.",
      icon: Icons.bolt,
      iconColor: Colors.orange,
      category: ReportCategory.electric,
    ),
    ReportModel(
      id: "REQ-2049",
      status: "جديد",
      location: "عمارة 7 • شقة 03",
      description: "المكيف لا يبرد.",
      icon: Icons.ac_unit,
      iconColor: Colors.teal,
      category: ReportCategory.ac,
    ),
  ];

  ReportsBloc() : super(ReportsInitial([], ReportCategory.all)) {
    on<FilterReportsEvent>((event, emit) {
      if (event.category == ReportCategory.all) {
        emit(ReportsInitial(allData, event.category));
      } else {
        final filtered = allData
            .where((r) => r.category == event.category)
            .toList();
        emit(ReportsInitial(filtered, event.category));
      }
    });

    on<SelectTechnicianEvent>((event, emit) {
      emit(
        ReportsInitial(
          state.reports,
          state.selectedCategory,
          selectedTechnician: event.technician,
        ),
      );
    });

    add(FilterReportsEvent(ReportCategory.all));
  }
}
