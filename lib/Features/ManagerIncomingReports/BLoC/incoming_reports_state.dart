import '../../../Data/Models/ReportModel.dart';
import '../../../Data/Models/TechnicianModel.dart';

abstract class ReportsState {
  final List<ReportModel> reports;
  final ReportCategory selectedCategory;
  ReportsState(this.reports, this.selectedCategory);
}

class ReportsInitial extends ReportsState {
  final TechnicianModel? selectedTechnician;
  ReportsInitial(super.reports, super.selectedCategory, {this.selectedTechnician});
}