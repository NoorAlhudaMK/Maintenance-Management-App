import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintenance_management_app/Features/Reports/BLoC/reports_event.dart';
import 'package:maintenance_management_app/Features/Reports/BLoC/reports_state.dart';

import '../../../Data/Models/TeamPerformanceModel.dart';

class ReportsStatsBloc extends Bloc<ReportsStatsEvent, ReportsStatsState> {
  ReportsStatsBloc() : super(_initialState()) {
    on<ChangeTimeFilterEvent>(_onFilterChanged);
  }

  static ReportsStatsState _initialState() {
    // نمرر بيانات "هذا الأسبوع" كحالة افتراضية
    return _generateMockData("هذا الأسبوع", null);
  }

  Future<void> _onFilterChanged(ChangeTimeFilterEvent event, Emitter<ReportsStatsState> emit) async {
    // محاكاة تأخير بسيط لإعطاء إيحاء بالتحميل (اختياري)
    // await Future.delayed(const Duration(milliseconds: 300));

    emit(_generateMockData(event.filterName, event.customRange));
  }

  // دالة مركزية لتوليد بيانات منطقية بناءً على نوع الفلتر
  static ReportsStatsState _generateMockData(String filterName, DateTimeRange? range) {
    int multiplier = 1;

    // تحديد "مُعامل الضرب" بناءً على الفترة الزمنية
    if (filterName == "اليوم") {
      multiplier = 1;
    } else if (filterName == "هذا الأسبوع") {
      multiplier = 7;
    } else if (filterName == "هذا الشهر") {
      multiplier = 30;
    } else if (filterName == "مخصص" && range != null) {
      multiplier = range.duration.inDays.abs() + 1;
    }

    // حساب الأرقام الإجمالية بشكل تناسبي
    int totalReports = 5 * multiplier + (multiplier % 3);
    double rating = 4.5 + (multiplier % 5) / 10; 

    return ReportsStatsState(
      selectedFilter: filterName,
      selectedRange: range,
      totalReports: totalReports,
      completionRate: "${80 + (multiplier % 15)}%", // نسبة متغيرة منطقياً
      avgClosingTime: "${(1.5 + (multiplier % 4) / 2).toStringAsFixed(1)} ساعة",
      residentsRating: rating > 5.0 ? 5.0 : rating,
      teamPerformance: [
        _createTech("محمد العمري", 1.2, multiplier),
        _createTech("حسن الوائلي", 1.5, multiplier),
        _createTech("أحمد السالم", 0.8, multiplier),
        _createTech("عمر الفاروق", 0.6, multiplier),
        _createTech("مصطفى الجبوري", 1.0, multiplier),
        _createTech("ليث القيسي", 0.4, multiplier),
        _createTech("زيد الرافدين", 0.7, multiplier),
      ],
    );
  }

  // دالة مساعدة لتوليد بيانات الفني الواحد بشكل منطقي
  static TeamPerformanceModel _createTech(String name, double productivity, int days) {
    // عدد المهام يعتمد على إنتاجية الفني وعدد الأيام
    int tasks = (productivity * days).round();
    if (tasks == 0 && days > 0) tasks = 1; // لضمان عدم ظهور أصفار في الفترات الطويلة

    // نسبة الإنجاز (عشوائية منظمة لتبدو واقعية)
    double progress = (0.5 + (productivity / 3)).clamp(0.0, 1.0);

    return TeamPerformanceModel(
      name: name,
      tasksCount: tasks,
      progress: progress,
      percentage: "${(progress * 100).toInt()}%",
    );
  }
}