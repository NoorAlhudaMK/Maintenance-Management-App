import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class RepairDocumentationEvent extends Equatable {
  const RepairDocumentationEvent();
  @override
  List<Object?> get props => [];
}

// حدث اختيار صورة (قبل أو بعد)
class PickImageEvent extends RepairDocumentationEvent {
  final bool isBeforeImage;
  final ImageSource source;
  const PickImageEvent({required this.isBeforeImage, required this.source});
}

// حدث تحديث الملاحظات أثناء الكتابة
class UpdateNotesEvent extends RepairDocumentationEvent {
  final String notes;
  const UpdateNotesEvent(this.notes);
}

// حدث إرسال التقرير النهائي
class SubmitRepairReport extends RepairDocumentationEvent {
  final String taskId;
  const SubmitRepairReport(this.taskId);
}

class UpdateStatusEvent extends RepairDocumentationEvent {
  final String status;
  const UpdateStatusEvent(this.status);
}