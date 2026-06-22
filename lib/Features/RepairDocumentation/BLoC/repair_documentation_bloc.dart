import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'repair_documentation_event.dart';
import 'repair_documentation_state.dart';

class RepairDocumentationBloc extends Bloc<RepairDocumentationEvent, RepairDocumentationState> {
  final ImagePicker _picker = ImagePicker();

  RepairDocumentationBloc() : super(const RepairDocumentationState()) {

    // منطق اختيار الصور
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

    // منطق تحديث الملاحظات
    on<UpdateNotesEvent>((event, emit) {
      emit(state.copyWith(notes: event.notes));
    });

    // منطق إرسال التقرير
    on<SubmitRepairReport>((event, emit) async {
      if (state.beforeImage == null || state.afterImage == null) {
        emit(state.copyWith(status: SubmissionStatus.failure, errorMessage: "يرجى إرفاق الصور المطلوبة"));
        return;
      }

      emit(state.copyWith(status: SubmissionStatus.loading));

      try {
        // هنا يتم استدعاء الـ API الخاص بكِ مستقبلاً
        await Future.delayed(const Duration(seconds: 2)); // محاكاة وقت الإرسال

        emit(state.copyWith(status: SubmissionStatus.success));
      } catch (e) {
        emit(state.copyWith(status: SubmissionStatus.failure, errorMessage: "حدث خطأ أثناء إرسال التقرير"));
      }
    });

    on<UpdateStatusEvent>((event, emit) {
      emit(state.copyWith(selectedStatus: event.status));
    });
  }
}