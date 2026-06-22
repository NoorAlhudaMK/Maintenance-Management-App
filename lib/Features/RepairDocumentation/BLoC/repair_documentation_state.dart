import 'dart:io';
import 'package:equatable/equatable.dart';

enum SubmissionStatus { initial, loading, success, failure }

class RepairDocumentationState extends Equatable {
  final File? beforeImage;
  final File? afterImage;
  final String notes;
  final SubmissionStatus status;
  final String? errorMessage;

  final String selectedStatus;

  const RepairDocumentationState({
    this.beforeImage,
    this.afterImage,
    this.notes = "",
    this.status = SubmissionStatus.initial,
    this.errorMessage,
    this.selectedStatus = "تم حل المشكلة",
  });

  RepairDocumentationState copyWith({
    File? beforeImage,
    File? afterImage,
    String? notes,
    SubmissionStatus? status,
    String? errorMessage,
    String? selectedStatus,
  }) {
    return RepairDocumentationState(
      beforeImage: beforeImage ?? this.beforeImage,
      afterImage: afterImage ?? this.afterImage,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedStatus: selectedStatus ?? this.selectedStatus,
    );
  }

  @override
  List<Object?> get props => [beforeImage, afterImage, notes, status, errorMessage, selectedStatus];
}