import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Data/Repositories/tickets_repository.dart';
import 'task_details_event.dart';
import 'task_details_state.dart';

class TaskDetailsBloc extends Bloc<TaskDetailsEvent, TaskDetailsState> {
  final TicketsRepository ticketsRepository;

  TaskDetailsBloc({required this.ticketsRepository}) : super(const TaskDetailsState(isLoading: true)) {
    on<LoadTaskDetails>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final ticketData = await ticketsRepository.fetchTaskDetails(event.taskId);
        emit(state.copyWith(isLoading: false, taskData: ticketData));
      } catch (e) {
        emit(state.copyWith(isLoading: false));
      }
    });
  }
}