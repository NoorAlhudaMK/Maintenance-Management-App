import 'package:equatable/equatable.dart';
import 'package:maintenance_management_app/Data/Models/ticket_model.dart';

class TechnicianTasksState extends Equatable {
  final List<TicketModel> tasks;
  final bool isLoading;
  final String? searchQuery;
  final String? dateFrom;
  final String? dateTo;

  const TechnicianTasksState({
    this.tasks = const [],
    this.isLoading = false,
    this.searchQuery,
    this.dateFrom,
    this.dateTo,
  });

  TechnicianTasksState copyWith({
    List<TicketModel>? tasks,
    bool? isLoading,
    String? searchQuery,
    String? dateFrom,
    String? dateTo,
  }) {
    return TechnicianTasksState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
    );
  }

  @override
  List<Object?> get props => [tasks, isLoading, searchQuery, dateFrom, dateTo];
}