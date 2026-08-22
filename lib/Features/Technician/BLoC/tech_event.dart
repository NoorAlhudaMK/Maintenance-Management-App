abstract class TechEvent {}

class FilterTechEvent extends TechEvent {
  FilterTechEvent();
}

class SearchTechEvent extends TechEvent {
  final String query;
  SearchTechEvent(this.query);
}

class SelectTechForAssignmentEvent extends TechEvent {
  final String techId;
  SelectTechForAssignmentEvent(this.techId);
}

class LoadTechProfileEvent extends TechEvent {
  final String techId;
  LoadTechProfileEvent(this.techId);
}

class LoadTeamsEvent extends TechEvent {}