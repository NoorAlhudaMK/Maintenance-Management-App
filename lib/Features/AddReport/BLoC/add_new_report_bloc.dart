import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';

import '../../../Data/Models/category_model.dart';
import '../../../Data/Models/priority_model.dart';
import '../../../Data/Repositories/tickets_repository.dart';

part 'add_new_report_event.dart';
part 'add_new_report_state.dart';

class AddNewReportBloc extends Bloc<AddNewReportEvent, AddNewReportState> {
  final TicketsRepository ticketsRepository;

  AddNewReportBloc({required this.ticketsRepository}) : super(const AddNewReportState()) {
    on<LoadReportDataEvent>(_onLoadData);
    on<SelectBuildingEvent>(_onSelectBuilding);
    on<SelectPriorityEvent>(_onSelectPriority);
    on<SelectCategoryEvent>(_onSelectCategory); // <--- إضافة
    on<PickReportImageEvent>(_onPickImage);
    on<SubmitReportEvent>(_onSubmitReport);
  }

  Future<void> _onLoadData(LoadReportDataEvent event, Emitter<AddNewReportState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      // جلب الأولويات والفئات بالتوازي
      final prioritiesFuture = ticketsRepository.fetchPriorities();
      final categoriesFuture = ticketsRepository.fetchCategories(); // يمكنك تمرير team_id إذا رغبت

      final results = await Future.wait([prioritiesFuture, categoriesFuture]);

      emit(state.copyWith(
        isLoading: false,
        priorities: results[0] as List<PriorityModel>,
        categories: results[1] as List<CategoryModel>,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString().replaceAll("Exception: ", "")));
    }
  }

  void _onSelectBuilding(SelectBuildingEvent event, Emitter<AddNewReportState> emit) {
    emit(state.copyWith(selectedBuilding: event.building));
  }

  void _onSelectPriority(SelectPriorityEvent event, Emitter<AddNewReportState> emit) {
    emit(state.copyWith(selectedPriority: event.priority));
  }

  void _onSelectCategory(SelectCategoryEvent event, Emitter<AddNewReportState> emit) {
    emit(state.copyWith(selectedCategory: event.category));
  }

  void _onPickImage(PickReportImageEvent event, Emitter<AddNewReportState> emit) {
    emit(state.copyWith(reportImage: event.imageFile));
  }

  Future<void> _onSubmitReport(
      SubmitReportEvent event,
      Emitter<AddNewReportState> emit,
      ) async {
    emit(state.copyWith(isSubmitting: true, errorMessage: null, successMessage: null));
    try {
      await ticketsRepository.createTicket(
        title: event.title,
        description: event.description,
        categoryId: event.categoryId,
        unitId: event.unitId,
        priority: event.priority,
        teamId: event.teamId,
        expectedDate: event.expectedDate,
        images: event.images,
      );

      emit(state.copyWith(isSubmitting: false, successMessage: "تم إضافة البلاغ بنجاح"));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString().replaceAll("Exception: ", "")));
    }
  }
}