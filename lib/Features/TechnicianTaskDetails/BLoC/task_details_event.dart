import 'package:equatable/equatable.dart';

abstract class TaskDetailsEvent extends Equatable {
  const TaskDetailsEvent();
  @override
  List<Object?> get props => [];
}

class LoadTaskDetails extends TaskDetailsEvent {
  final String taskId;
  const LoadTaskDetails(this.taskId);
}