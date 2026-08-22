part of 'add_new_report_bloc.dart';

abstract class AddNewReportEvent {}

class LoadReportDataEvent extends AddNewReportEvent {}

class SelectBuildingEvent extends AddNewReportEvent {
  final String? building;
  SelectBuildingEvent(this.building);
}

class SelectPriorityEvent extends AddNewReportEvent {
  final PriorityModel? priority;
  SelectPriorityEvent(this.priority);
}

class SelectCategoryEvent extends AddNewReportEvent {
  final CategoryModel? category;
  SelectCategoryEvent(this.category);
}

class PickReportImageEvent extends AddNewReportEvent {
  final File imageFile;
  PickReportImageEvent(this.imageFile);
}

class SubmitReportEvent extends AddNewReportEvent {
  final String title;
  final String description;
  final int categoryId;
  final int unitId;
  final String priority;
  final int? teamId;
  final String? expectedDate;
  final List<Map<String, dynamic>>? images;

  SubmitReportEvent({
    required this.title,
    required this.description,
    required this.categoryId,
    required this.unitId,
    required this.priority,
    this.teamId,
    this.expectedDate,
    this.images,
  });
}