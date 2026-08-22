import '../../../Data/Models/category_model.dart';
import '../../../Data/Models/maintenance_team_model.dart'; // <-- استيراد الموديل الجديد

abstract class ReportsEvent {}

class FetchTicketsEvent extends ReportsEvent {}

class SearchTicketsEvent extends ReportsEvent {
  final String query;
  SearchTicketsEvent(this.query);
}

class FilterByDateEvent extends ReportsEvent {
  final String? dateFrom;
  final String? dateTo;
  FilterByDateEvent({this.dateFrom, this.dateTo});
}

class FilterByTeamEvent extends ReportsEvent {
  final MaintenanceTeamModel? team;
  FilterByTeamEvent(this.team);
}

class FilterReportsEvent extends ReportsEvent {
  final CategoryModel? category;
  FilterReportsEvent(this.category);
}

class UpdateTempStatusFilterEvent extends ReportsEvent {
  final int? statusId;
  UpdateTempStatusFilterEvent(this.statusId);
}

class UpdateTempPriorityFilterEvent extends ReportsEvent {
  final String? priorityId;
  UpdateTempPriorityFilterEvent(this.priorityId);
}

class ApplyAdvancedFiltersEvent extends ReportsEvent {
  final int? statusId;
  final String? priorityId;
  ApplyAdvancedFiltersEvent({this.statusId, this.priorityId});
}

class ResetTempFiltersEvent extends ReportsEvent {}