import 'package:equatable/equatable.dart';

abstract class TechnicianTasksEvent extends Equatable {
  const TechnicianTasksEvent();

  @override
  List<Object?> get props => [];
}
class LoadTechnicianTasks extends TechnicianTasksEvent {
  final String? search;
  final String? dateFrom;
  final String? dateTo;

  const LoadTechnicianTasks({this.search, this.dateFrom, this.dateTo});
}