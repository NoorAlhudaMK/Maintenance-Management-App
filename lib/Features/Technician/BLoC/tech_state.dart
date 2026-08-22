import '../../../Data/Models/maintenance_team_member_model.dart';

class TechState {
  final List<TeamMemberModel> technicians;
  final String? selectedTechId;
  final String? selectedTechnicianId;
  final bool isLoading;
  final String? errorMessage;
  final int totalCount;
  final int availableCount;
  final int busyCount;

  TechState({
    required this.technicians,
    this.selectedTechId,
    this.selectedTechnicianId,
    this.isLoading = false,
    this.errorMessage,
    this.totalCount = 0,
    this.availableCount = 0,
    this.busyCount = 0,
  });

  TechState copyWith({
    List<TeamMemberModel>? technicians,
    String? selectedTechId,
    String? selectedTechnicianId,
    bool? isLoading,
    String? errorMessage,
    int? totalCount,
    int? availableCount,
    int? busyCount,
  }) {
    return TechState(
      technicians: technicians ?? this.technicians,
      selectedTechId: selectedTechId ?? this.selectedTechId,
      selectedTechnicianId: selectedTechnicianId ?? this.selectedTechnicianId,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      totalCount: totalCount ?? this.totalCount,
      availableCount: availableCount ?? this.availableCount,
      busyCount: busyCount ?? this.busyCount,
    );
  }
}