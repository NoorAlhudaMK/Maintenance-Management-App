import '../../../Data/Models/ReportModel.dart';
import '../../../Data/Models/TechnicianModel.dart';

abstract class ReportsState {
  final List<ReportModel> reports;
  final ReportCategory selectedCategory;
  ReportsState(this.reports, this.selectedCategory);
}

class ReportsLoading extends ReportsState {
  ReportsLoading() : super([], ReportCategory.all);
}

class ReportsInitial extends ReportsState {
  final TechnicianModel? selectedTechnician;
  ReportsInitial(
    super.reports,
    super.selectedCategory, {
    this.selectedTechnician,
  });
}

class ReportsFailure extends ReportsState {
  final String error;
  ReportsFailure(this.error) : super([], ReportCategory.all);
}
