abstract class ManagerDashboardEvent {}

class FetchManagerDashboardData extends ManagerDashboardEvent {
  final int teamId;
  FetchManagerDashboardData({required this.teamId});
}