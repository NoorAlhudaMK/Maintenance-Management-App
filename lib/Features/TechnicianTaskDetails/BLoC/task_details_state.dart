import 'package:equatable/equatable.dart';

class TaskDetailsState extends Equatable {
  final bool isLoading;
  final Map<String, dynamic>? taskData;

  const TaskDetailsState({this.isLoading = false, this.taskData});

  TaskDetailsState copyWith({bool? isLoading, Map<String, dynamic>? taskData}) {
    return TaskDetailsState(
      isLoading: isLoading ?? this.isLoading,
      taskData: taskData ?? this.taskData,
    );
  }

  @override
  List<Object?> get props => [isLoading, taskData];
}