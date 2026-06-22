import 'package:equatable/equatable.dart';
import 'technician_tasks_state.dart';

abstract class TechnicianTasksEvent extends Equatable {
  const TechnicianTasksEvent();

  @override
  List<Object?> get props => [];
}

class LoadTechnicianTasks extends TechnicianTasksEvent {}

class ChangeTaskTab extends TechnicianTasksEvent {
  final TaskTabStatus status;
  const ChangeTaskTab(this.status);

  @override
  List<Object?> get props => [status];
}