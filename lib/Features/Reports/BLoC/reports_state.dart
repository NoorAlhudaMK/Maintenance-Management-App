import 'package:flutter/material.dart';

import '../../../Data/Models/TeamPerformanceModel.dart';

class ReportsStatsState {
  final String selectedFilter;
  final DateTimeRange? selectedRange; // النطاق المخصص
  final int totalReports;
  final String completionRate;
  final String avgClosingTime;
  final double residentsRating;
  final List<TeamPerformanceModel> teamPerformance;

  ReportsStatsState({
    required this.selectedFilter,
    this.selectedRange,
    required this.totalReports,
    required this.completionRate,
    required this.avgClosingTime,
    required this.residentsRating,
    required this.teamPerformance,
  });

  ReportsStatsState copyWith({
    String? selectedFilter,
    DateTimeRange? selectedRange,
    int? totalReports,
    String? completionRate,
    String? avgClosingTime,
    double? residentsRating,
    List<TeamPerformanceModel>? teamPerformance,
  }) {
    return ReportsStatsState(
      selectedFilter: selectedFilter ?? this.selectedFilter,
      selectedRange: selectedRange ?? this.selectedRange,
      totalReports: totalReports ?? this.totalReports,
      completionRate: completionRate ?? this.completionRate,
      avgClosingTime: avgClosingTime ?? this.avgClosingTime,
      residentsRating: residentsRating ?? this.residentsRating,
      teamPerformance: teamPerformance ?? this.teamPerformance,
    );
  }
}