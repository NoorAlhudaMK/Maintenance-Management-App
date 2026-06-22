import '../../../Data/Models/TechnicianModel.dart';

class TechState {
  final List<TechnicianModel> technicians;
  final TechStatus selectedStatus;
  final String? selectedTechId;
  final TechnicianModel? selectedTechnician; // أضف هذا الحقل

  TechState({
    required this.technicians,
    required this.selectedStatus,
    this.selectedTechId,
    this.selectedTechnician,
  });

  TechState copyWith({
    List<TechnicianModel>? technicians,
    TechStatus? selectedStatus,
    String? selectedTechId,
    TechnicianModel? selectedTechnician,
  }) {
    return TechState(
      technicians: technicians ?? this.technicians,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      selectedTechId: selectedTechId ?? this.selectedTechId,
      selectedTechnician: selectedTechnician ?? this.selectedTechnician,
    );
  }
}