abstract class ManagerDashboardState {}

class ManagerDashboardInitial extends ManagerDashboardState {}

class ManagerDashboardLoading extends ManagerDashboardState {}

class ManagerDashboardLoaded extends ManagerDashboardState {
  final Map<String, dynamic> summaryData;
  ManagerDashboardLoaded({required this.summaryData});
}

class ManagerDashboardError extends ManagerDashboardState {
  final String message;
  ManagerDashboardError({required this.message});
}