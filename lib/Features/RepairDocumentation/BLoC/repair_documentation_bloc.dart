import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Data/Repositories/repair_documentation_repository.dart';
import 'repair_documentation_event.dart';
import 'repair_documentation_state.dart';

class RepairDocumentationBloc extends Bloc<RepairDocumentationEvent, RepairDocumentationState> {
  final ImagePicker _picker = ImagePicker();
  final RepairDocumentationRepository repository;
  String id;

  RepairDocumentationBloc({required this.repository, required this.id}) : super(const RepairDocumentationState()) {

    on<FetchStatusesEvent>((event, emit) async {
      try {
        final statuses = await repository.getMaintenanceStatuses();
        emit(state.copyWith(
          statusesList: statuses,
          selectedStatus: statuses.isNotEmpty ? statuses.first.code : '',
        ));
      } catch (e) {
        // التعامل مع الخطأ إن وجد
      }
    });

    on<PickImageEvent>((event, emit) async {
      final XFile? pickedFile = await _picker.pickImage(source: event.source);

      if (pickedFile != null) {
        if (event.isBeforeImage) {
          emit(state.copyWith(beforeImage: File(pickedFile.path)));
        } else {
          emit(state.copyWith(afterImage: File(pickedFile.path)));
        }
      }
    });

    on<UpdateNotesEvent>((event, emit) {
      emit(state.copyWith(notes: event.notes));
    });

    on<UpdateStatusEvent>((event, emit) {
      emit(state.copyWith(selectedStatus: event.status));
    });

    on<SubmitRepairReport>((event, emit) async {
      emit(state.copyWith(status: SubmissionStatus.loading));

      try {
        final response = await repository.submitRepair(
          taskId: event.taskId,
          status: state.selectedStatus,
          notes: state.notes,
          beforeImage: state.beforeImage,
          afterImage: state.afterImage,
        );

        if (response.success) {
          emit(state.copyWith(status: SubmissionStatus.success));
        } else {
          emit(state.copyWith(
              status: SubmissionStatus.failure,
              errorMessage: response.message.isNotEmpty ? response.message : "حدث خطأ ما"
          ));
        }
      } catch (e) {
        emit(state.copyWith(status: SubmissionStatus.failure, errorMessage: e.toString()));
      }
    });

    on<UploadImageEvent>((event, emit) async {
      emit(state.copyWith(status: SubmissionStatus.loading));

      try {
        final response = await repository.uploadTaskImage(
          taskId: id,
          imageFile: event.imageFile,
          imageType: event.imageType,
          note: event.note,
        );

        if (response.success) {
          if (event.imageType == "before") {
            emit(state.copyWith(
              status: SubmissionStatus.initial,
              beforeImage: event.imageFile,
            ));
          } else {
            emit(state.copyWith(
              status: SubmissionStatus.initial,
              afterImage: event.imageFile,
            ));
          }
        } else {
          emit(state.copyWith(
            status: SubmissionStatus.failure,
            errorMessage: response.message,
          ));
        }
      } catch (e) {
        emit(state.copyWith(
          status: SubmissionStatus.failure,
          errorMessage: e.toString(),
        ));
      }
    });


  }
}