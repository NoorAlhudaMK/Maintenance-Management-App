import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Data/Models/ReportModel.dart';
import '../../../Data/Repositories/tickets_repository.dart';
import 'incoming_reports_event.dart';
import 'incoming_reports_state.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  final TicketsRepository repository;
  List<ReportModel> _allReports = [];

  ReportsBloc({required this.repository}) : super(ReportsLoading()) {
    on<FetchTicketsEvent>((event, emit) async {
      emit(ReportsLoading());
      try {
        final tickets = await repository.fetchTickets();
        _allReports = tickets
            .map(
              (t) => ReportModel(
                id: "REQ-${t.id}",
                status: t.stageName,
                location: t.unitName,
                description: t.description,
                category: _mapCategory(t.categoryName),
                icon: Icons.assignment,
                iconColor: Colors.blue,
                isUrgent: t.status == 'urgent',
              ),
            )
            .toList();

        emit(ReportsInitial(_allReports, ReportCategory.all));
      } catch (e) {
        print("The error os the error --->");

        emit(ReportsFailure(e.toString()));
      }
    });

    on<FilterReportsEvent>((event, emit) {
      if (event.category == ReportCategory.all) {
        emit(ReportsInitial(_allReports, event.category));
      } else {
        final filtered = _allReports
            .where((r) => r.category == event.category)
            .toList();
        emit(ReportsInitial(filtered, event.category));
      }
    });

    on<SelectTechnicianEvent>((event, emit) {
      emit(
        ReportsInitial(
          state.reports,
          state.selectedCategory,
          selectedTechnician: event.technician,
        ),
      );
    });
  }

  ReportCategory _mapCategory(String name) {
    if (name.contains("كهرباء")) return ReportCategory.electric;
    if (name.contains("سباكة")) return ReportCategory.plumbing;
    return ReportCategory.ac;
  }
}
