import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Data/Repositories/tickets_repository.dart';
import 'technician_tasks_event.dart';
import 'technician_tasks_state.dart';

class TechnicianTasksBloc extends Bloc<TechnicianTasksEvent, TechnicianTasksState> {
  final TicketsRepository _repository = TicketsRepository();

  TechnicianTasksBloc() : super(const TechnicianTasksState()) {

    on<LoadTechnicianTasks>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final tasks = await _repository.fetchTickets(
          search: event.search,
          dateFrom: event.dateFrom,
          dateTo: event.dateTo,
        );
        emit(state.copyWith(
          tasks: tasks,
          isLoading: false,
          searchQuery: event.search,
          dateFrom: event.dateFrom,
          dateTo: event.dateTo,
        ));
      } catch (e) {
        emit(state.copyWith(isLoading: false));
      }
    });
  }
}
