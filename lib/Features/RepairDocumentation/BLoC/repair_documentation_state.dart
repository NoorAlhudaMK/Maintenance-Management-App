import 'dart:io';

import '../../../Data/Models/maintenance_status_model.dart';

enum SubmissionStatus { initial, loading, success, failure }

class RepairDocumentationState {
  final SubmissionStatus status;
  final File? beforeImage;
  final File? afterImage;
  final String notes;
  final String selectedStatus;
  final List<MaintenanceStatusModel> statusesList;
  final String? errorMessage;

  const RepairDocumentationState({
    this.status = SubmissionStatus.initial,
    this.beforeImage,
    this.afterImage,
    this.notes = '',
    this.selectedStatus = '',
    this.statusesList = const [],
    this.errorMessage,
  });

  RepairDocumentationState copyWith({
    SubmissionStatus? status,
    File? beforeImage,
    File? afterImage,
    String? notes,
    String? selectedStatus,
    List<MaintenanceStatusModel>? statusesList,
    String? errorMessage,
  }) {
    return RepairDocumentationState(
      status: status ?? this.status,
      beforeImage: beforeImage ?? this.beforeImage,
      afterImage: afterImage ?? this.afterImage,
      notes: notes ?? this.notes,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      statusesList: statusesList ?? this.statusesList,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}