import '../../../Data/Models/category_model.dart';
import '../../../Data/Models/priority_model.dart';
import '../../../Data/Models/status_model.dart';
import '../../../Data/Models/ticket_model.dart';
import '../../../Data/Models/maintenance_team_model.dart'; // <-- استيراد الموديل الجديد

abstract class ReportsState {
  final List<TicketModel> reports;
  final String? searchQuery;
  final String? dateFrom;
  final String? dateTo;
  final CategoryModel? selectedCategory;
  final MaintenanceTeamModel? selectedTeam; // <-- تحديث النوع هنا أيضاً
  final List<CategoryModel> categories;
  final List<MaintenanceTeamModel> teams; // <-- تحديث نوع القائمة
  final List<StatusModel> statuses;
  final List<PriorityModel> priorities;
  final int? selectedStatusId;
  final String? selectedPriorityId;
  final int? tempSelectedStatusId;
  final String? tempSelectedPriorityId;

  const ReportsState({
    required this.reports,
    this.searchQuery,
    this.dateFrom,
    this.dateTo,
    this.selectedCategory,
    this.selectedTeam,
    required this.categories,
    required this.teams,
    required this.statuses,
    required this.priorities,
    this.selectedStatusId,
    this.selectedPriorityId,
    this.tempSelectedStatusId,
    this.tempSelectedPriorityId,
  });
}

class ReportsInitial extends ReportsState {
  ReportsInitial()
      : super(
    reports: [],
    categories: [],
    teams: [],
    statuses: [],
    priorities: [],
  );
}

class ReportsLoading extends ReportsState {
  const ReportsLoading({
    required super.reports,
    required super.categories,
    required super.teams,
    required super.statuses,
    required super.priorities,
    super.searchQuery,
    super.dateFrom,
    super.dateTo,
    super.selectedCategory,
    super.selectedTeam,
    super.selectedStatusId,
    super.selectedPriorityId,
    super.tempSelectedStatusId,
    super.tempSelectedPriorityId,
  });
}

class ReportsLoaded extends ReportsState {
  const ReportsLoaded({
    required super.reports,
    required super.categories,
    required super.teams,
    required super.statuses,
    required super.priorities,
    super.searchQuery,
    super.dateFrom,
    super.dateTo,
    super.selectedCategory,
    super.selectedTeam,
    super.selectedStatusId,
    super.selectedPriorityId,
    super.tempSelectedStatusId,
    super.tempSelectedPriorityId,
  });

  ReportsLoaded copyWith({
    List<TicketModel>? reports,
    String? searchQuery,
    String? dateFrom,
    String? dateTo,
    CategoryModel? selectedCategory,
    MaintenanceTeamModel? selectedTeam, // <-- تحديث النوع
    bool clearTeam = false,
    List<CategoryModel>? categories,
    List<MaintenanceTeamModel>? teams, // <-- تحديث النوع
    List<StatusModel>? statuses,
    List<PriorityModel>? priorities,
    int? selectedStatusId,
    bool clearStatus = false,
    String? selectedPriorityId,
    bool clearPriority = false,
    int? tempSelectedStatusId,
    bool clearTempStatus = false,
    String? tempSelectedPriorityId,
    bool clearTempPriority = false,
  }) {
    return ReportsLoaded(
      reports: reports ?? this.reports,
      searchQuery: searchQuery ?? this.searchQuery,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedTeam: clearTeam ? null : (selectedTeam ?? this.selectedTeam),
      categories: categories ?? this.categories,
      teams: teams ?? this.teams,
      statuses: statuses ?? this.statuses,
      priorities: priorities ?? this.priorities,
      selectedStatusId: clearStatus ? null : (selectedStatusId ?? this.selectedStatusId),
      selectedPriorityId: clearPriority ? null : (selectedPriorityId ?? this.selectedPriorityId),
      tempSelectedStatusId: clearTempStatus ? null : (tempSelectedStatusId ?? this.tempSelectedStatusId),
      tempSelectedPriorityId: clearTempPriority ? null : (tempSelectedPriorityId ?? this.tempSelectedPriorityId),
    );
  }
}

class ReportsFailure extends ReportsState {
  final String error;
  ReportsFailure(this.error)
      : super(
    reports: [],
    categories: [],
    teams: [],
    statuses: [],
    priorities: [],
  );
}