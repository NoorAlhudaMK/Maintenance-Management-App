import 'package:flutter/material.dart';

abstract class ReportsStatsEvent {}

class ChangeTimeFilterEvent extends ReportsStatsEvent {
  final String filterName; // "اليوم", "هذا الأسبوع", "مخصص"...
  final DateTimeRange? customRange; // اختياري: يُرسل فقط عند اختيار "مخصص"

  ChangeTimeFilterEvent(this.filterName, {this.customRange});
}