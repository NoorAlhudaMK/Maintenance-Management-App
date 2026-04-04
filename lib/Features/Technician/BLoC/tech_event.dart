import '../../../Data/Models/TechnicianModel.dart';

abstract class TechEvent {}

class FilterTechEvent extends TechEvent {
  final TechStatus status;
  FilterTechEvent(this.status);
}

class SelectTechForAssignmentEvent extends TechEvent {
  final String techId;
  SelectTechForAssignmentEvent(this.techId);
}

class LoadTechProfileEvent extends TechEvent {
  final String techId;
  LoadTechProfileEvent(this.techId);
}