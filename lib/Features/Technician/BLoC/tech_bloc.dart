import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Data/Models/maintenance_team_member_model.dart';
import 'tech_event.dart';
import 'tech_state.dart';
import '../../../Data/Repositories/tickets_repository.dart';

class TechBloc extends Bloc<TechEvent, TechState> {
  final TicketsRepository ticketsRepository;
  List<TeamMemberModel> _allMembers = [];

  TechBloc({required this.ticketsRepository})
      : super(TechState(technicians: [])) {
    on<LoadTeamsEvent>(_onLoadTeams);
    on<FilterTechEvent>(_onFilterTech);
    on<SelectTechForAssignmentEvent>(_onSelectTechForAssignment);
    on<LoadTechProfileEvent>(_onLoadTechProfile);
    on<SearchTechEvent>(_onSearchTech);

    add(LoadTeamsEvent());
  }

  Future<void> _onLoadTeams(LoadTeamsEvent event, Emitter<TechState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final List<TeamMemberModel> membersData = await ticketsRepository.fetchTeamMembers();
      _allMembers = membersData;

      final total = membersData.length;
      // final available = membersData.where((m) => m. == 'active').length;
      // final busy = membersData.where((m) => m.status == 'busy').length;

      emit(state.copyWith(
        isLoading: false,
        technicians: membersData,
        totalCount: total,
        // availableCount: available,
        // busyCount: busy,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSearchTech(SearchTechEvent event, Emitter<TechState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final List<TeamMemberModel> membersData = await ticketsRepository.fetchTeamMembers(
        search: event.query,
      );
      emit(state.copyWith(
        isLoading: false,
        technicians: membersData,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onFilterTech(FilterTechEvent event, Emitter<TechState> emit) {
    // // التأكد من أن الحدث والحالة ليسا null
    // final status = event.status ?? TechStatus.all;
    //
    // if (status == TechStatus.all) {
    //   emit(state.copyWith(technicians: _allMembers, selectedStatus: status));
    // } else {
    //   final filtered = _allMembers.where((t) => (t.status ?? '') == status.name).toList();
    //   emit(state.copyWith(technicians: filtered, selectedStatus: status));
    // }
  }

  void _onSelectTechForAssignment(SelectTechForAssignmentEvent event, Emitter<TechState> emit) {
    emit(state.copyWith(selectedTechId: event.techId));
  }

  void _onLoadTechProfile(LoadTechProfileEvent event, Emitter<TechState> emit) {
    TeamMemberModel? foundMember;

    for (var member in _allMembers) {
      if (member.id.toString() == event.techId) {
        foundMember = member;
        break;
      }
    }

    // ملاحظة: إذا كنت تحتفظ بـ selectedTechnician كـ MaintenanceTeamModel،
    // يمكنك تعديل الحالة لتتناسب مع موديل العضو الجديد أو تركه بحسب تصميمك.
    emit(state.copyWith(selectedTechnicianId: event.techId));
  }
}