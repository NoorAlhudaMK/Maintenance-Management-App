import '../../../Data/Models/ReportModel.dart';
import '../../../Data/Models/TechnicianModel.dart';

abstract class ReportsEvent {}

class FetchTicketsEvent extends ReportsEvent {}

class FilterReportsEvent extends ReportsEvent {
  final ReportCategory category;
  FilterReportsEvent(this.category);
}

class SelectTechnicianEvent extends ReportsEvent {
  final TechnicianModel technician;
  SelectTechnicianEvent(this.technician);
}
