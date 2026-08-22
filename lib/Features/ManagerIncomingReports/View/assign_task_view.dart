import 'package:flutter/material.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../../Data/Models/maintenance_team_model.dart';
import '../../../Data/Models/team_member_model.dart';
import '../../../Data/Repositories/tickets_repository.dart';

class AssignTaskView extends StatefulWidget {
  final String reportId;
  final String category;

  const AssignTaskView({
    super.key,
    required this.reportId,
    required this.category,
  });

  @override
  State<AssignTaskView> createState() => _AssignTaskViewState();
}

class _AssignTaskViewState extends State<AssignTaskView> {
  final TicketsRepository _repository = TicketsRepository();

  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _isSubmitting = ValueNotifier<bool>(false);
  final ValueNotifier<String?> _selectedTechId = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _selectedTeamId = ValueNotifier<String?>(null);

  List<dynamic> _allTechnicians = [];

  @override
  void initState() {
    super.initState();
    _fetchTeamsAndTechnicians();
  }

  Future<void> _fetchTeamsAndTechnicians() async {
    try {
      final teams = await _repository.fetchTeams();
      List<TeamMemberModel> tempTechs = [];

      for (var team in teams) {
        if (team.members.isNotEmpty) {
          for (var member in team.members) {
            tempTechs.add(
              member
            );
          }
        }
      }

      _allTechnicians = tempTechs;
      _isLoading.value = false;
    } catch (e) {
      _isLoading.value = false;
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("خطأ في جلب البيانات: $e")),
      );
    }
  }

  Future<void> _submitAssignment() async {
    if (_selectedTechId.value == null) return;

    _isSubmitting.value = true;

    try {
      await _repository.assignTicket(
        ticketId: widget.reportId,
        technicianId: _selectedTechId.value!,
        teamId: _selectedTeamId.value,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم تحويل المهمة بنجاح")),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      _isSubmitting.value = false;
    }
  }

  @override
  void dispose() {
    _isLoading.dispose();
    _isSubmitting.dispose();
    _selectedTechId.dispose();
    _selectedTeamId.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              "تحويل المهمة الى فني",
              style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: AppColors.textMain),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: ValueListenableBuilder<bool>(
            valueListenable: _isLoading,
            builder: (context, loading, child) {
              if (loading) {
                return const Center(child: CircularProgressIndicator());
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: _allTechnicians.length,
                      itemBuilder: (context, index) {
                        final TeamMemberModel tech = _allTechnicians[index];
                        return ValueListenableBuilder<String?>(
                          valueListenable: _selectedTechId,
                          builder: (context, selectedId, child) {
                            final bool isSelected = selectedId == tech.memberId.toString();
                            return _buildTechCard(tech, isSelected);
                          },
                        );
                      },
                    ),
                  ),
                  _buildConfirmButton(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTechCard(TeamMemberModel tech, bool isSelected) {
    return GestureDetector(
      onTap: () {
        _selectedTechId.value = tech.memberId.toString();
        _selectedTeamId.value = tech.teamId.toString();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Text(tech.name[0], style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tech.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(tech.teamName ?? "", style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
            const Spacer(),
            if (isSelected) const Icon(Icons.check_circle, color: Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: ValueListenableBuilder<String?>(
        valueListenable: _selectedTechId,
        builder: (context, selectedId, child) {
          return ValueListenableBuilder<bool>(
            valueListenable: _isSubmitting,
            builder: (context, submitting, child) {
              final bool isEnabled = selectedId != null && !submitting;

              return ElevatedButton(
                onPressed: isEnabled ? _submitAssignment : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.primary.withOpacity(0.3),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: submitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  "تأكيد التحويل",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            },
          );
        },
      ),
    );
  }
}