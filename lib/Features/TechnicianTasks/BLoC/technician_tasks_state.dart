import 'package:equatable/equatable.dart';

// تعريف التبويبات المتاحة في الواجهة
enum TaskTabStatus { all, emergency, inProgress, completed }

class TechnicianTasksState extends Equatable {
  final List<Map<String, dynamic>> tasks;
  final TaskTabStatus selectedTab;
  final bool isLoading;

  const TechnicianTasksState({
    this.tasks = const [],
    this.selectedTab = TaskTabStatus.all,
    this.isLoading = false,
  });

  TechnicianTasksState copyWith({
    List<Map<String, dynamic>>? tasks,
    TaskTabStatus? selectedTab,
    bool? isLoading,
  }) {
    return TechnicianTasksState(
      tasks: tasks ?? this.tasks,
      selectedTab: selectedTab ?? this.selectedTab,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [tasks, selectedTab, isLoading];
}