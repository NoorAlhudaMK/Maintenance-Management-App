import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Data/Repositories/tickets_repository.dart';
import '../../../../Data/Models/maintenance_team_model.dart';
import 'incoming_reports_event.dart';
import 'incoming_reports_state.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  final TicketsRepository repository;

  ReportsBloc({required this.repository}) : super(ReportsInitial()) {
    on<FetchTicketsEvent>(_onFetchTickets);
    on<SearchTicketsEvent>(_onSearchTickets);
    on<FilterByDateEvent>(_onFilterByDate);
    on<FilterByTeamEvent>(_onFilterByTeam);
    on<FilterReportsEvent>(_onFilterReports);
    on<UpdateTempStatusFilterEvent>(_onUpdateTempStatusFilter);
    on<UpdateTempPriorityFilterEvent>(_onUpdateTempPriorityFilter);
    on<ApplyAdvancedFiltersEvent>(_onApplyAdvancedFilters);
    on<ResetTempFiltersEvent>(_onResetTempFilters);
  }

  Future<void> _onFetchTickets(
      FetchTicketsEvent event, Emitter<ReportsState> emit) async {
    emit(ReportsLoading(
      reports: state.reports,
      categories: state.categories,
      teams: state.teams,
      statuses: state.statuses,
      priorities: state.priorities,
    ));
    try {
      final results = await Future.wait([
        repository.fetchTickets(),
        repository.fetchCategories(),
        repository.fetchTeams(), // هذه الآن تُرجع List<MaintenanceTeamModel> مباشرة
        repository.fetchStatuses(),
        repository.fetchPriorities(),
      ]);

      final tickets = results[0] as List;
      final categories = results[1] as List;
      final teams = results[2] as List<MaintenanceTeamModel>; // <-- استقبالها بالنوع الصحيح مباشرة
      final statuses = results[3] as List;
      final priorities = results[4] as List;

      emit(ReportsLoaded(
        reports: tickets.cast(),
        categories: categories.cast(),
        teams: teams,
        statuses: statuses.cast(),
        priorities: priorities.cast(),
      ));
    } catch (e) {
      emit(ReportsFailure(e.toString()));
    }
  }

  Future<void> _onFilterByTeam(
      FilterByTeamEvent event, Emitter<ReportsState> emit) async {
    if (state is ReportsLoaded) {
      final currentState = state as ReportsLoaded;
      emit(ReportsLoading(
        reports: currentState.reports,
        categories: currentState.categories,
        teams: currentState.teams,
        statuses: currentState.statuses,
        priorities: currentState.priorities,
        selectedTeam: event.team,
        selectedCategory: currentState.selectedCategory,
      ));

      try {
        final tickets = await repository.fetchTickets(
          search: currentState.searchQuery,
          dateFrom: currentState.dateFrom,
          dateTo: currentState.dateTo,
          status: currentState.selectedStatusId?.toString(),
          priority: currentState.selectedPriorityId,
          // إذا كان الريبوزتري يدعم فلترة الفريق عبر الـ id يمكنك إضافتها هنا:
          // teamId: event.team?.id,
        );

        emit(currentState.copyWith(
          reports: tickets,
          selectedTeam: event.team,
          clearTeam: event.team == null,
        ));
      } catch (e) {
        emit(ReportsFailure(e.toString()));
      }
    }
  }

  Future<void> _onSearchTickets(
      SearchTicketsEvent event, Emitter<ReportsState> emit) async {
    if (state is ReportsLoaded) {
      final currentState = state as ReportsLoaded;
      try {
        final tickets = await repository.fetchTickets(
          search: event.query,
          dateFrom: currentState.dateFrom,
          dateTo: currentState.dateTo,
          status: currentState.selectedStatusId?.toString(),
          priority: currentState.selectedPriorityId,
        );
        emit(currentState.copyWith(
          reports: tickets,
          searchQuery: event.query,
        ));
      } catch (e) {
        emit(ReportsFailure(e.toString()));
      }
    }
  }

  Future<void> _onFilterByDate(
      FilterByDateEvent event, Emitter<ReportsState> emit) async {
    if (state is ReportsLoaded) {
      final currentState = state as ReportsLoaded;
      try {
        final tickets = await repository.fetchTickets(
          dateFrom: event.dateFrom,
          dateTo: event.dateTo,
          search: currentState.searchQuery,
          status: currentState.selectedStatusId?.toString(),
          priority: currentState.selectedPriorityId,
        );
        emit(currentState.copyWith(
          reports: tickets,
          dateFrom: event.dateFrom,
          dateTo: event.dateTo,
        ));
      } catch (e) {
        emit(ReportsFailure(e.toString()));
      }
    }
  }

  Future<void> _onFilterReports(
      FilterReportsEvent event, Emitter<ReportsState> emit) async {
    // مخصص للفئات إن أردت إبقاءها
  }

  void _onUpdateTempStatusFilter(
      UpdateTempStatusFilterEvent event, Emitter<ReportsState> emit) {
    if (state is ReportsLoaded) {
      final currentState = state as ReportsLoaded;
      emit(currentState.copyWith(
          tempSelectedStatusId: event.statusId,
          clearTempStatus: event.statusId == null));
    }
  }

  void _onUpdateTempPriorityFilter(
      UpdateTempPriorityFilterEvent event, Emitter<ReportsState> emit) {
    if (state is ReportsLoaded) {
      final currentState = state as ReportsLoaded;
      emit(currentState.copyWith(
          tempSelectedPriorityId: event.priorityId,
          clearTempPriority: event.priorityId == null));
    }
  }

  Future<void> _onApplyAdvancedFilters(
      ApplyAdvancedFiltersEvent event, Emitter<ReportsState> emit) async {
    if (state is ReportsLoaded) {
      final currentState = state as ReportsLoaded;
      try {
        final tickets = await repository.fetchTickets(
          search: currentState.searchQuery,
          dateFrom: currentState.dateFrom,
          dateTo: currentState.dateTo,
          status: event.statusId?.toString(),
          priority: event.priorityId,
        );
        emit(currentState.copyWith(
          reports: tickets,
          selectedStatusId: event.statusId,
          selectedPriorityId: event.priorityId,
          clearStatus: event.statusId == null,
          clearPriority: event.priorityId == null,
        ));
      } catch (e) {
        emit(ReportsFailure(e.toString()));
      }
    }
  }

  void _onResetTempFilters(
      ResetTempFiltersEvent event, Emitter<ReportsState> emit) {
    if (state is ReportsLoaded) {
      final currentState = state as ReportsLoaded;
      emit(currentState.copyWith(
        clearTempStatus: true,
        clearTempPriority: true,
      ));
    }
  }
}