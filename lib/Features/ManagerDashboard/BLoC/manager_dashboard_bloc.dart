import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Data/Repositories/manager_repository.dart';
import 'manager_dashboard_event.dart';
import 'manager_dashboard_state.dart';

class ManagerDashboardBloc extends Bloc<ManagerDashboardEvent, ManagerDashboardState> {
  final ManagerRepository managerRepository;

  ManagerDashboardBloc({required this.managerRepository}) : super(ManagerDashboardInitial()) {
    on<FetchManagerDashboardData>((event, emit) async {
      emit(ManagerDashboardLoading());
      try {
        final data = await managerRepository.fetchManagerSummary(teamId: event.teamId);
        emit(ManagerDashboardLoaded(summaryData: data));
      } catch (e) {
        emit(ManagerDashboardError(message: e.toString().replaceAll("Exception: ", "")));
      }
    });
  }
}